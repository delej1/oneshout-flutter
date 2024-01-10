// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:app_core/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

import 'package:oneshout/common/common.dart';
import 'package:oneshout/modules/locator/domain/domain.dart';

/// {@template local_storage_customers_api}
/// A Flutter implementation of the [LocatorApi] that uses local storage.
/// {@endtemplate}
class LocatorApi with NetworkLogger {
  /// {@macro local_storage_customers_api}
  LocatorApi({
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
      BehaviorSubject<ApiResponse<Locator>>.seeded(ApiResponse<Locator>());

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
  Stream<ApiResponse<Locator>> getLocator() =>
      _shoutStreamController.asBroadcastStream();

  ///Returns a list of [Locator] from remote api.
  ///
  ///Returns a [Locator] or typeof [Failure]
  // @override
  Future<List<Locator>> fetchLocator({
    int page = 1,
    int limit = 10,
    required List<String> contacts,
  }) async {
    var url = Urls.locatorEndpoint;

    try {
      dynamic response = await _network.post(url, {'contacts': contacts});

      if (response != null) {
        response = response as Map<String, dynamic>;

        final locators = Locator.listFromJson(
          response['data'] as List,
        );

        return locators;
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

  Future<Either<Failure, Locator>> sendLocator({
    required Locator shout,
    required String userId,
  }) async {
    try {
      dynamic response;
      var url = Urls.shoutsEndpoint;

      response = await _network.post(url, shout.toJson());

      if (response != null) {
        response =
            (response as Map<String, dynamic>)['data'] as Map<String, dynamic>;
        final data = Locator.fromJson(response);
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

  Future<Either<Failure, bool>> requestLocator({
    required String phone,
  }) async {
    try {
      dynamic response;
      var url = '${Urls.locatorEndpoint}/request';

      response = await _network.post(url, {'phone': phone});

      if (response != null) {
        final r = response['data'] as bool;
        return Right(r);
      } else {
        throw UnableToProcessDataException();
      }
    } catch (e, s) {
      logger.e(e.toString());
      print(s);
      throw ServerException(ServerException().toFailure(e, s).message);
    }
  }

  Future<Either<Failure, bool>> respondToLocatorRequest({
    required String phone,
    required bool accept,
  }) async {
    try {
      dynamic response;
      var url = '${Urls.locatorEndpoint}/locator-request-response';

      response = await _network.post(url, {'phone': phone, 'accept': accept});

      if (response != null) {
        final r = response['data'] as bool;
        return Right(r);
      } else {
        throw UnableToProcessDataException();
      }
    } catch (e, s) {
      logger.e(e.toString());

      throw ServerException(ServerException().toFailure(e, s).message);
    }
  }

  Future<Either<Failure, bool>> setCanLocateMe({
    required bool canLocateMe,
    required List<String> viewers,
    required double lat,
    required double lng,
  }) async {
    try {
      dynamic response;
      var url = '${Urls.locatorEndpoint}/update-can-locate';

      response = await _network.post(url, {
        'canLocateMe': canLocateMe,
        'viewers': viewers,
        'lng': lng,
        'lat': lat,
      });

      if (response != null) {
        final r = response['data'] as bool;
        return Right(r);
      } else {
        throw UnableToProcessDataException();
      }
    } catch (e, s) {
      logger.e(e.toString());
      print(s);
      throw ServerException(ServerException().toFailure(e, s).message);
    }
  }

  Future<Either<Failure, bool>> updateMyLocation({
    required double lat,
    required double lng,
  }) async {
    try {
      dynamic response;
      var url = '${Urls.locatorEndpoint}/update-location';

      response = await _network.post(url, {
        'lng': lng,
        'lat': lat,
      });

      if (response != null) {
        final r = response['data'] as bool;
        return Right(r);
      } else {
        throw UnableToProcessDataException();
      }
    } catch (e, s) {
      logger.e(e.toString());
      print(s);
      throw ServerException(ServerException().toFailure(e, s).message);
    }
  }

  Future<Either<Failure, Locator>> cancelLocator({
    required Locator shout,
    required String userId,
  }) async {
    try {
      dynamic response;
      final url = '${Urls.shoutsEndpoint}/cancel-shout/${shout.id}';

      response = await _network.post(url, shout.toJson());

      if (response != null) {
        response =
            (response as Map<String, dynamic>)['data'] as Map<String, dynamic>;
        final data = Locator.fromJson(response);
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
