//Exceptions
// ignore_for_file: lines_longer_than_80_chars, comment_references

import 'package:app_core/app_core.dart';
import 'package:equatable/equatable.dart';

///Exception that originates from within the system.
abstract class AppException extends Equatable
    with NetworkLogger
    implements Exception {
  AppException([this.message, this.url]);
  final String? message;
  final String? url;

  @override
  List<Object?> get props => [];

  ///Returns the equivalent type of [Failure] for the [appException] thrown.
  Failure toFailure(Object e, StackTrace stackTrace) {
    final message = (e is AppException)
        ? e.message ?? 'An unknown error occurred'
        : 'An unknown error occurred';
    logger.e(message, e, stackTrace);
    return ExceptionMixin().exceptionToFailure(message, e, stackTrace);
  }
}

///Exception from the internal storage system
class CacheException extends AppException {
  CacheException([String? message, String? url]) : super(message, url);
}

///Exception that originates from network calls.
// class ServerException extends Equatable
class ServerException extends Equatable
    with NetworkLogger
    implements AppException {
  ServerException([this.message, this.url]);
  @override
  final String? message;
  @override
  final String? url;

  @override
  List<Object?> get props => [];

  ///Returns the equivalent type of [Failure] for the [ServerException] thrown.
  @override
  Failure toFailure(Object e, StackTrace stackTrace) {
    final message = (e is ServerException)
        ? e.message ?? e.runtimeType.toString()
        : 'We could not establish a connection to the server.';
    logger.e(message, e, stackTrace);
    // logger.log(Level.error, message, e, stackTrace);
    return ExceptionMixin().exceptionToFailure(message, e, stackTrace);
  }
}

//Exception thrown when request is not found on the api.
class RequestNotFoundException extends ServerException {
  RequestNotFoundException([String? message, String? url])
      : super(message, url);
}

///Exception thrown when server is rejected a post request due to duplicate entries.
class DuplicateRequestException extends ServerException {
  DuplicateRequestException([String? message, String? url])
      : super(message, url);
}

///Exception thrown when the data or format sent to the server is rejected.
class BadRequestException extends ServerException {
  BadRequestException([String? message, String? url]) : super(message, url);
}

///Exception thrown when server or api is not responding.
class ServerNotRespondingException extends ServerException {
  ServerNotRespondingException([String? message, String? url])
      : super(message, url);
}

///Exception thrown when the api needs authorization.
class UnAuthorizedException extends ServerException {
  UnAuthorizedException([String? message, String? url]) : super(message, url);
}

///Exception thrown when token expires.
class SessionExpiredException extends ServerException {
  SessionExpiredException([String? message, String? url]) : super(message, url);
}

///Exception thrown when the we can not process the data from the api.
class UnableToProcessDataException extends AppException {
  UnableToProcessDataException([String? message, String? url])
      : super(message, url);
}

class ExceptionMixin with NetworkLogger {
  ///Returns the equivalent type of [Failure] for the exception.
  Failure exceptionToFailure(String message, Object e, StackTrace stackTrace) {
    switch (e.runtimeType) {
      case ServerException:
        // return ServerFailure((e as ServerException).message);
        return ServerFailure(message);
      case AppException:
        return UnableToProcessFailure(e.toString());
      default:
        return UnableToProcessFailure(message);
    }
  }
}
