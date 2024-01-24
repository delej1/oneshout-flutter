// ignore_for_file: comment_references, avoid_unused_constructor_parameters, lines_longer_than_80_chars

import 'package:equatable/equatable.dart';

///Failure entity returned as a Type
class Failure extends Equatable {
  const Failure([this.message = '']);
  final String? message;
  // ignore: prefer_const_constructors_in_immutables

  @override
  List<Object?> get props => [];
}

// Internal App failures

///Failure returned from [RequestNotFoundException]
class RequestNotFoundFailure extends Failure {
  const RequestNotFoundFailure([String? message]) : super(message);
}

///Failure returned from [CacheException]
class CacheFailure extends Failure {
  const CacheFailure([String? message]) : super(message);
}

///Failure returned from [ServerException]
class ServerFailure extends Failure {
  const ServerFailure([String? message]) : super(message);
}

///Failure returned from [BadRequestException]
class BadRequestFailure extends Failure {
  const BadRequestFailure([String? message, String? url]) : super(message);
}

///Failure returned from [ServerNotRespondingException]
class ServerNotRespondingFailure extends Failure {
  const ServerNotRespondingFailure([String? message, String? url])
      : super(message);
}

///Failure returned from [UnAuthorizedException]
class UnAuthorizedFailure extends Failure {
  const UnAuthorizedFailure([String? message, String? url]) : super(message);
}

///Failure returned from [UnableToProcessDataException]
class UnableToProcessFailure extends Failure {
  const UnableToProcessFailure([String? message, String? url]) : super(message);
}

///Failure returned when there is no internet connection available.
class NetworkFailure extends Failure {
  const NetworkFailure([
    String? message = 'Please check the internet connection and try again.',
  ]) : super(message);
}
