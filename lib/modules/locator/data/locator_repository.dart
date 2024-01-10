import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:app_core/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:oneshout/common/common.dart';
import 'package:oneshout/modules/locator/data/data.dart';
import 'package:oneshout/modules/locator/domain/domain.dart';

/// {@template shout_repository}
/// A repository that handles customer related requests.
/// {@endtemplate}
class LocatorRepository {
  /// {@macro shout_repository}
  LocatorRepository({
    required LocatorApi locatorApi,
    required AuthenticationRepository auth,
  }) : _locatorApi = locatorApi {
    // init();
    _user = auth.currentUser;
  }

  final LocatorApi _locatorApi;
  late User _user;
  final connectivity = getItCore.get<NetworkConnectionBloc>();

//  @override
  // AuthenticationRepository _auth;

  // Future<void> init() async {
  //   final auth = await getIt.getAsync<AuthenticationRepository>();
  //   _user = auth.currentUser;
  // }

  /// Provides a [Stream] of all shout.
  Stream<ApiResponse<Locator>> getLocator() => _locatorApi.getLocator();

  Future<Either<Failure, List<Locator>>> fetchLocator({
    int page = 1,
    int limit = 10,
    required List<String> contacts,
  }) async {
    try {
      if (connectivity.state.networkConnectionStatus ==
          NetworkConnectionStatus.connected) {
        final response = await _locatorApi.fetchLocator(
          page: page,
          limit: limit,
          contacts: contacts,
        );
        return Right(response);
      } else {
        return const Left(NetworkFailure());
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  /// Saves a [shout].
  ///
  /// If a [shout] with the same id already exists, it will be replaced.
  Future<Either<Failure, Locator>> sendLocator({required Locator shout}) async {
    try {
      if (connectivity.state.networkConnectionStatus ==
          NetworkConnectionStatus.connected) {
        final response = await _locatorApi.sendLocator(
          shout: shout,
          userId: _user.id,
        );
        return response;
      } else {
        return const Left(NetworkFailure());
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  /// Send a locator request [].
  ///
  /// If a [] with the same id already exists, it will be replaced.
  Future<Either<Failure, bool>> requestLocator({required String phone}) async {
    try {
      if (connectivity.state.networkConnectionStatus ==
          NetworkConnectionStatus.connected) {
        final response = await _locatorApi.requestLocator(
          phone: phone,
        );
        return response;
      } else {
        return const Left(NetworkFailure());
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  /// Send a locator request [].
  ///
  /// If a [] with the same id already exists, it will be replaced.
  Future<Either<Failure, bool>> respondToLocatorRequest({
    required String phone,
    required bool accept,
  }) async {
    try {
      if (connectivity.state.networkConnectionStatus ==
          NetworkConnectionStatus.connected) {
        final response = await _locatorApi.respondToLocatorRequest(
          phone: phone,
          accept: accept,
        );
        return response;
      } else {
        return const Left(NetworkFailure());
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  /// Send a locator request [].
  ///
  /// If a [] with the same id already exists, it will be replaced.
  Future<Either<Failure, bool>> setCanLocateMe({
    required bool canLocateMe,
    required List<String> viewers,
    required double lat,
    required double lng,
  }) async {
    try {
      if (connectivity.state.networkConnectionStatus ==
          NetworkConnectionStatus.connected) {
        final response = await _locatorApi.setCanLocateMe(
          canLocateMe: canLocateMe,
          viewers: viewers,
          lat: lat,
          lng: lng,
        );
        return response;
      } else {
        return const Left(NetworkFailure());
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  /// If a [] with the same id already exists, it will be replaced.
  Future<Either<Failure, bool>> updateMyLocation({
    required double lng,
    required double lat,
  }) async {
    try {
      if (connectivity.state.networkConnectionStatus ==
          NetworkConnectionStatus.connected) {
        final response = await _locatorApi.updateMyLocation(
          lat: lat,
          lng: lng,
        );
        return response;
      } else {
        return const Left(NetworkFailure());
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  /// Cancel a [shout].
  ///
  /// Sends a notification to emergency contacts that the user is now out of danger.
  Future<Either<Failure, Locator>> cancelLocator(
      {required Locator shout}) async {
    try {
      if (connectivity.state.networkConnectionStatus ==
          NetworkConnectionStatus.connected) {
        final response = await _locatorApi.cancelLocator(
          shout: shout,
          userId: _user.id,
        );
        return response;
      } else {
        return const Left(NetworkFailure());
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
