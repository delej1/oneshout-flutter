import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:app_core/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:oneshout/common/common.dart';
import 'package:oneshout/modules/shout/shout.dart';

/// {@template shout_repository}
/// A repository that handles customer related requests.
/// {@endtemplate}
class ShoutRepository {
  /// {@macro shout_repository}
  ShoutRepository({
    required ShoutApi shoutApi,
    required AuthenticationRepository auth,
  }) : _shoutApi = shoutApi {
    // init();
    _user = auth.currentUser;
  }

  final ShoutApi _shoutApi;
  late User _user;
  final connectivity = getItCore.get<NetworkConnectionBloc>();

//  @override
  // AuthenticationRepository _auth;

  // Future<void> init() async {
  //   final auth = await getIt.getAsync<AuthenticationRepository>();
  //   _user = auth.currentUser;
  // }

  /// Provides a [Stream] of all shout.
  Stream<ApiResponse<Shout>> getShouts() => _shoutApi.getShouts();

  Future<Either<Failure, ApiResponse<Shout>>> fetchShouts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (connectivity.state.networkConnectionStatus ==
          NetworkConnectionStatus.connected) {
        final response = await _shoutApi.fetchShouts(
          page: page,
          limit: limit,
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
  Future<Either<Failure, Shout>> sendShout({required Shout shout}) async {
    try {
      if (connectivity.state.networkConnectionStatus ==
          NetworkConnectionStatus.connected) {
        final response = await _shoutApi.sendShout(
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

  /// Cancel a [shout].
  ///
  /// Sends a notification to emergency contacts that the user is now out of danger.
  Future<Either<Failure, Shout>> cancelShout({required Shout shout}) async {
    try {
      if (connectivity.state.networkConnectionStatus ==
          NetworkConnectionStatus.connected) {
        final response = await _shoutApi.cancelShout(
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
