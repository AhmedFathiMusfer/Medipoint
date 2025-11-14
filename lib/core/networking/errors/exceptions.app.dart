import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';

class ApiException implements Exception {
  ApiException();

  factory ApiException.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 204:
        return NoContentException();
      case 401:
        return UnauthenticatedException();
      case 404:
        return NotFoundException();
      case 406:
        return InvalidException();
      case 410:
        return ExpireException();
      case 434:
        return UserExistsException();
      case 439:
        return BlockedException();
      case 500:
        return ServerException();
      default:
        return UnexpectedException();
    }
  }

  factory ApiException.fromEnumeration([ExceptionTypes? types]) {
    switch (types) {
      case ExceptionTypes.cache:
        return CacheException();
      case ExceptionTypes.process:
        return ProcessException();
      case ExceptionTypes.connection:
        return ConnectionException();
      case ExceptionTypes.timeout:
        return TimeoutException();
      case ExceptionTypes.empty:
        return EmptyException();
      case ExceptionTypes.badRequest:
        return BadRequestException();
      default:
        return UnexpectedException();
    }
  }
}

class ServerException extends ApiException {}

class CacheException extends ApiException {}

class EmptyException extends ApiException {}

class NoContentException extends ApiException {}

class InvalidException extends ApiException {}

class NotFoundException extends ApiException {}

class ExpireException extends ApiException {}

class UserExistsException extends ApiException {}

class PasswordException extends ApiException {}

class UnexpectedException extends ApiException {}

class UnauthenticatedException extends ApiException {}

class BlockedException extends ApiException {}

class ConnectionException extends ApiException {}

class ProcessException extends ApiException {}

class TimeoutException extends ApiException {}

class BadRequestException extends ApiException {}
