import 'dart:developer';
import 'package:diagno_bot/core/networking/remote/dioFactory.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.app.dart';
import 'package:diagno_bot/core/networking/remote/methods.enums..dart';
import 'package:diagno_bot/core/networking/remote/request.dart';
import 'package:dio/dio.dart';

class RemoteProvider {
  factory RemoteProvider() {
    _singleton ??= RemoteProvider._();

    return _singleton!;
  }

  static RemoteProvider? _singleton;

  final Dio dio = DioFactory.getDio();

  RemoteProvider._();

  Future<dynamic> send({
    required Request request,
    required RemoteMethod method,
    List<int> successStates = const [200, 201, 202],
    Function(Response, int)? onSuccess,
    Function(Response, int)? onError,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
    ResponseType? responseType,
    CancelToken? cancelToken,
  }) async {
    Response<dynamic> response = Response(requestOptions: RequestOptions());
    int statusCode = 500;
    try {
      Response<dynamic> response = await dio
          .request(
            request.urlQueryString,
            data: request.body,
            options: Options(
              method: method.name,
              headers: request.header,
              responseType: responseType,
              receiveTimeout: const Duration(days: 1),
              validateStatus: (status) {
                return status != null && status < 500;
              },
            ),
            onSendProgress: (received, total) {
              if (onSendProgress != null) {
                if (total == -1) {
                  total = 7340032;
                }
                if ((received / total) > 1) {
                  received = total;
                }
                onSendProgress(received, total);
              }
            },
            onReceiveProgress: (received, total) {
              if (onReceiveProgress != null) {
                if (total == -1) {
                  total = 7340032;
                }
                if ((received / total) > 1) {
                  received = total;
                }
                onReceiveProgress(received, total);
              }
            },
            cancelToken: cancelToken,
          )
          .timeout(
            Duration(milliseconds: dio.options.connectTimeout!.inMilliseconds),
            onTimeout: () {
              throw ApiException.fromEnumeration(ExceptionTypes.timeout);
            },
          );

      var statusCode = response.statusCode!;
      // log("kkkkk");
      if (successStates.contains(statusCode)) {
        if (onSuccess != null) await onSuccess(response, statusCode);
      } else {
        if (onError != null) {
          onError(response, statusCode);
        } else {
          throw ApiException.fromStatusCode(statusCode);
        }
      }

      return response;
    } catch (exception) {
      log(exception.toString());
      //statusCode = 500;
      if (onError != null) {
        onError(response, statusCode);
      } else {
        throw ApiException.fromStatusCode(statusCode);
      }
      //  throw ApiException.fromStatusCode(statusCode);
      _catchExceptions(exception);
    }
  }
}

void _catchExceptions(Object exception) {
  var statusCode = 500;
  if (exception is DioException) {
    statusCode = exception.response?.statusCode ?? 500;
    log(
      exception.response?.data?.toString() ?? 'Error message is null',
      name: 'dio error',
    );
  }
  throw ApiException.fromStatusCode(statusCode);
}
