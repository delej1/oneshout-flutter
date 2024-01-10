// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:app_core/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

import 'package:oneshout/common/common.dart';
import 'package:oneshout/modules/shout/shout.dart';

/// {@template local_storage_customers_api}
/// A Flutter implementation of the [AlertsApi] that uses local storage.
/// {@endtemplate}
class ShoutApi with NetworkLogger {
  /// {@macro local_storage_customers_api}
  ShoutApi({
    HttpNetworkController? network,
    NetworkConnectionBloc? networkConnectionBloc,
  })  : _network = network ?? getItCore.get<HttpNetworkController>(),
        _networkConnection =
            networkConnectionBloc ?? getItCore.get<NetworkConnectionBloc>() {
    _init();
  }

  final HttpNetworkController _network;
  final NetworkConnectionBloc _networkConnection;

  final _shoutStreamController =
      BehaviorSubject<ApiResponse<Shout>>.seeded(ApiResponse<Shout>());

  /// The key used for storing the customers locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kAlertsCollectionKey = '__alerts_collection_key__';

  void _init() {
    // loadInitialAlerts(businessId: "1");
  }

  // @override
  Stream<ApiResponse<Shout>> getShouts() =>
      _shoutStreamController.asBroadcastStream();

  ///Returns a list of [Shout] from remote api.
  ///
  ///Returns a [Shout] or typeof [Failure]
  // @override
  Future<ApiResponse<Shout>> fetchShouts({
    int page = 1,
    int limit = 10,
  }) async {
    final url =
        '${Urls.shoutsEndpoint}?pagination[page]=$page&pagination[pageSize]=$limit';

    try {
      dynamic response = await _network.get(url);

      if (response != null) {
        response = response as Map<String, dynamic>;

        final shouts = Shout.listFromJson(
          response['data'] as List,
        );

        final pagination = Pagination.fromJson(
          response['meta'] as Map<String, dynamic>,
        );
        // _shoutStreamController
        // .add(ApiResponse(data: shouts, pagination: pagination));
        return ApiResponse(data: shouts, pagination: pagination);
      } else {
        // _shoutStreamController.add(ApiResponse());
        // ignore: only_throw_errors
        throw UnableToProcessDataException;
      }
    } catch (e, s) {
      logger.d(s);
      throw ServerException(ServerException().toFailure(e, s).message);
    }
  }

  Future<Either<Failure, Shout>> sendShout({
    required Shout shout,
    required String userId,
  }) async {
    try {
      dynamic response;
      var url = Urls.shoutsEndpoint;

      response = await _network.post(url, shout.toJson());

      if (response != null) {
        response =
            (response as Map<String, dynamic>)['data'] as Map<String, dynamic>;
        final data = Shout.fromJson(response);
        return Right(data);
      } else {
        throw UnableToProcessDataException();
      }
    } catch (e, s) {
      logger.e(e.toString());
      print(s);
      throw ServerException(ServerException().toFailure(e, s).message);
    }
  }

  Future<Either<Failure, Shout>> cancelShout({
    required Shout shout,
    required String userId,
  }) async {
    try {
      dynamic response;
      final url = '${Urls.shoutsEndpoint}/cancel-shout/${shout.id}';

      response = await _network.post(url, shout.toJson());

      if (response != null) {
        response =
            (response as Map<String, dynamic>)['data'] as Map<String, dynamic>;
        final data = Shout.fromJson(response);
        return Right(data);
      } else {
        throw UnableToProcessDataException();
      }
    } catch (e, s) {
      logger.e(e.toString());
      print(s);
      throw ServerException(ServerException().toFailure(e, s).message);
    }
  }
}
