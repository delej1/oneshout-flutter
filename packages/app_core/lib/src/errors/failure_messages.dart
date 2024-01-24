import 'package:app_core/app_core.dart';

enum AppState {
  general,
  loading,
  noResult,
  notFound,
  serverError,
  noConnection,
}

mixin FailureMessages {
  String errorMessage(Failure failure) {
    if (failure is RequestNotFoundFailure) {
      return 'The information you requested was not found.';
    } else if (failure is ServerFailure) {
      return 'There was an unexpected error on the server.';
    } else if (failure is BadRequestFailure) {
      return 'The server could not process your request.';
    } else if (failure is ServerNotRespondingFailure) {
      return 'The server is taking too long to respond.';
    } else if (failure is UnAuthorizedFailure) {
      return 'You have been denied access by the server.';
    } else if (failure is UnableToProcessFailure) {
      return 'The response from the server could not be processed.';
    } else if (failure is NetworkFailure) {
      return 'There is no internet connection.';
    } else {
      return 'An error occurred!';
    }
  }

  AppState errorType(Failure failure) {
    if (failure is RequestNotFoundFailure) {
      return AppState.notFound;
    } else if (failure is ServerFailure) {
      return AppState.serverError;
    } else if (failure is BadRequestFailure) {
      return AppState.serverError;
    } else if (failure is ServerNotRespondingFailure) {
      return AppState.serverError;
    } else if (failure is UnAuthorizedFailure) {
      return AppState.serverError;
    } else if (failure is UnableToProcessFailure) {
      return AppState.serverError;
    } else if (failure is NetworkFailure) {
      return AppState.noConnection;
    } else {
      return AppState.general;
    }
  }
}
