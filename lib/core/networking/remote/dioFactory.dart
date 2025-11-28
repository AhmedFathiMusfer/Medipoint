import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  DioFactory._();
  static Dio? dio;
  static Dio getDio() {
    Duration timeout = const Duration(seconds: 30);
    if (dio == null) {
      dio = Dio();
      dio!.options.receiveTimeout = timeout;
      dio!.options.connectTimeout = timeout;
      addTokenInterceptors();
      addInterceptors();

      return dio!;
    }
    return dio!;
  }

  static void addInterceptors() {
    dio?.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
      ),
    );
  }

  static void addTokenInterceptors() {
    dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = AuthManager().accessToken;
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          handler.next(options);
        },

        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 &&
              e.requestOptions.headers["isRetry"] != true) {
            final refreshToken = AuthManager().refreshToken;
            if (refreshToken == null) {
              await AuthManager().logout();
              return handler.next(e);
            }
            try {
              final refreshDio = Dio();
              final refreshResponse = await refreshDio.post(
                ApiConstants.refreshTokenEndpoint,
                data: {"refresh": refreshToken},
              );

              await AuthManager().setToken(refreshResponse.data);

              final newToken = AuthManager().accessToken;
              final requestOptions = e.requestOptions;
              requestOptions.headers["Authorization"] = "Bearer $newToken";
              requestOptions.headers["isRetry"] = true;
              final retryResponse = await dio!.fetch(requestOptions);
              return handler.resolve(retryResponse);
            } catch (_) {
              await AuthManager().logout();
              return handler.next(e);
            }
          }

          handler.next(e);
        },
      ),
    );
  }
}
