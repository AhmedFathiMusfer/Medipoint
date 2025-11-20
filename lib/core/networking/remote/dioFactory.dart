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
          if (e.response?.statusCode == 401) {
            final refreshToken = AuthManager().refreshToken;
            if (refreshToken != null) {
              try {
                final response = await dio!.post(
                  ApiConstants.refreshTokenEndpoint,
                  data: {"refresh": refreshToken},
                );
                await AuthManager().setToken(response.data);
                final newToken = AuthManager().accessToken;
                final opts = e.requestOptions;
                opts.headers["Authorization"] = "Bearer $newToken";
                final cloneReq = await dio!.fetch(opts);
                return handler.resolve(cloneReq);
              } catch (_) {
                await AuthManager().logout();
              }
            } else {
              await AuthManager().logout();
            }
          }
          handler.next(e);
        },
      ),
    );
  }
}
