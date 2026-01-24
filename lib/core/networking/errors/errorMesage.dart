import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:easy_localization/easy_localization.dart';

class ErrorMessages {
  // singleton
  ErrorMessages._();
  static final ErrorMessages instance = ErrorMessages._();

  // جلب رسالة حسب status code
  String fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 401:
        return "error_unauthorized".tr();
      case 403:
      case 404:
      case 400:
        return "error_unknown".tr();
      case 408:
        return "error_check_internet".tr();
      case 500:
      case 502:
      case 503:
        return "error_server_error".tr();
      default:
        return "";
    }
  }

  String fromExceptionType(ExceptionTypes type) {
    switch (type) {
      case ExceptionTypes.timeout:
        return "error_connection_timeout".tr();
      case ExceptionTypes.connection:
        return "error_no_internet".tr();
      default:
        return "error_unknown".tr();
    }
  }
}
