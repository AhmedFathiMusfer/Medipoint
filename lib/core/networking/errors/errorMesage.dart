import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';

class ErrorMessages {
  // singleton
  ErrorMessages._();
  static final ErrorMessages instance = ErrorMessages._();

  // جلب رسالة حسب status code
  String fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 401:
        return "Unauthorized. Please login again.";
      case 403:
      case 404:
      case 400:
        return "An unknown error occurred.";
      case 408:
        return "Please check your internet.";
      case 500:
      case 502:
      case 503:
        return "Internal server error. Please try again later.";
      default:
        return "Something went wrong.";
    }
  }

  String fromExceptionType(ExceptionTypes type) {
    switch (type) {
      case ExceptionTypes.timeout:
        return "Connection timed out. Please check your internet.";
      case ExceptionTypes.connection:
        return "No internet connection. Please check your network.";
      default:
        return "An unknown error occurred.";
    }
  }
}
