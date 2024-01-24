// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_core/app_core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:mocktail/mocktail.dart';

@Injectable(as: NetworkClient)
enum NetworkClient { dio, http }

abstract class IHttpNetworkController {
  Future<dynamic> get(String api);
  Future<dynamic> post(String api, dynamic payloadObj);
  Future<dynamic> put(String api, dynamic payloadObj);
  Future<dynamic> delete(String api);
}

// @Injectable(as: IHttpNetworkController, env: ['dev'])
class MockHttpNetworkController extends Mock implements IHttpNetworkController {
}

// @Singleton(as: IHttpNetworkController)
@singleton
class HttpNetworkController
    with NetworkLogger
    implements IHttpNetworkController {
  HttpNetworkController() {
    _baseUrl = _baseUrl;
    _initHttpClient();
    _initDioClient();
  }

  static HttpNetworkController get to => GetIt.I<HttpNetworkController>();
  static const int _defaultConnectTimeout = Duration.millisecondsPerMinute;
  static const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

  NetworkClient baseClient = NetworkClient.dio;

  http.Client httpClient = http.Client();

  final dioClient = Dio();

  String _baseUrl = '';

  String jwt = '';
  final dioInterceptors = <Interceptor>[];

  void onInit() {
    _initHttpClient();
    _initDioClient();
  }

  void setup({
    required String baseUrl,
    String token = '',
    NetworkClient client = NetworkClient.dio,
  }) {
    _baseUrl = baseUrl;
    jwt = token;
    baseClient = client;
    onInit();
    if (jwt.isNotEmpty) {
      logger.d('NetworkClient Built');
    }
  }

  void rebuildWithJwt(String token) {
    jwt = token;
    _initHttpClient();
    _initDioClient();
  }

  void _initHttpClient() {}

  void _initDioClient() {
    final headers = {'Authorization': 'Bearer $jwt'};
    dioClient.options = BaseOptions(
      baseUrl: _baseUrl,
      headers: headers,
      connectTimeout: _defaultConnectTimeout,
      receiveTimeout: _defaultReceiveTimeout,
    );

    if (dioInterceptors.isNotEmpty) {
      dioClient.interceptors.addAll(dioInterceptors);
    }

    if (kDebugMode) {
      dioClient.interceptors.add(
        LogInterceptor(
          responseBody: true,
          error: false,
          // requestHeader: true,
          responseHeader: false,
          request: false,
        ),
      );
    }
  }

  //GET
  @override
  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse(_baseUrl + endpoint);
    logger.d('GET: $uri');
    try {
      if (baseClient == NetworkClient.dio) {
        final response = await dioClient
            .get<dynamic>(_baseUrl + endpoint)
            .timeout(const Duration(seconds: _defaultConnectTimeout));
        return _processDioResponse(response);
      } else {
        final response = await httpClient
            .get(uri)
            .timeout(const Duration(seconds: _defaultConnectTimeout));
        return _processHttpResponse(response);
      }
    } on SocketException {
      throw ServerException('Server error', uri.toString());
    } on TimeoutException {
      throw ServerNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    } on DioError catch (e) {
      if (e.response != null) {
        return _processDioResponse(e.response!);
      }
    }
  }

  //POST
  @override
  Future<dynamic> post(
    String api,
    dynamic payloadObj, {
    Options? options,
  }) async {
    final uri = Uri.parse(_baseUrl + api);
    final data = <String, dynamic>{'data': payloadObj};
    final payload = json.encode(data);

    try {
      if (baseClient == NetworkClient.dio) {
        final response = await dioClient
            .post<dynamic>(_baseUrl + api, data: payload)
            .timeout(const Duration(seconds: _defaultConnectTimeout));
        return _processDioResponse(response);
      } else {
        final response = await httpClient
            .post(uri, body: payload)
            .timeout(const Duration(seconds: _defaultConnectTimeout));
        return _processHttpResponse(response);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return _processDioResponse(e.response!);
      }
    } on SocketException {
      throw ServerException('Server error', uri.toString());
    } on TimeoutException {
      throw ServerNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    }
  }

  //PUT
  @override
  Future<dynamic> put(String api, dynamic payloadObj) async {
    final uri = Uri.parse(_baseUrl + api);
    final data = <String, dynamic>{'data': payloadObj};
    final payload = json.encode(data);

    try {
      if (baseClient == NetworkClient.dio) {
        final response = await dioClient
            .put<dynamic>(_baseUrl + api, data: payload)
            .timeout(const Duration(seconds: _defaultConnectTimeout));
        return _processDioResponse(response);
      } else {
        final response = await httpClient
            .put(uri, body: payload)
            .timeout(const Duration(seconds: _defaultConnectTimeout));
        return _processHttpResponse(response);
      }
    } on SocketException {
      throw ServerException('Server error', uri.toString());
    } on TimeoutException {
      throw ServerNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    } on DioError catch (e) {
      if (e.response != null) {
        return _processDioResponse(e.response!);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  //DELETE
  @override
  Future<dynamic> delete(String api) async {
    final uri = Uri.parse(_baseUrl + api);
    try {
      if (baseClient == NetworkClient.dio) {
        final response = await dioClient
            .delete<dynamic>(_baseUrl + api)
            .timeout(const Duration(seconds: _defaultConnectTimeout));
        return _processDioResponse(response);
      } else {
        final response = await httpClient
            .delete(uri)
            .timeout(const Duration(seconds: _defaultConnectTimeout));
        return _processHttpResponse(response);
      }
    } on SocketException {
      throw ServerException('Server error', uri.toString());
    } on TimeoutException {
      throw ServerNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    } on DioError catch (e) {
      if (e.response != null) {
        return _processDioResponse(e.response!);
      }
    }
  }
  //OTHER

  dynamic _processHttpResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 201:
        final responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 400:
        throw BadRequestException(
          utf8.decode(response.bodyBytes),
          response.request!.url.toString(),
        );
      case 401:
      case 403:
        throw UnAuthorizedException(
          utf8.decode(response.bodyBytes),
          response.request!.url.toString(),
        );
      case 404:
        throw RequestNotFoundException(
          utf8.decode(response.bodyBytes),
          response.request!.url.toString(),
        );
      case 422:
        throw BadRequestException(
          utf8.decode(response.bodyBytes),
          response.request!.url.toString(),
        );
      case 500:
      default:
        throw ServerException(
          'Error occurred with code : ${response.statusCode}',
          response.request!.url.toString(),
        );
    }
  }

  dynamic _processDioResponse(Response response) {
    final data = response.data as Map<String, dynamic>;
    final errorMessage = data['error'] != null
        ? (data['error'] as Map<String, dynamic>)['message'] as String
        : '';
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 201:
        return response.data;
      case 400:
        throw BadRequestException(errorMessage, response.realUri.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(errorMessage, response.realUri.toString());
      case 404:
        throw RequestNotFoundException(
          errorMessage,
          response.realUri.toString(),
        );
      case 422:
        throw DuplicateRequestException(
          errorMessage,
          response.realUri.toString(),
        );
      case 500:
        throw ServerException(
          'Internal Server Error: ${response.statusCode}',
          response.realUri.toString(),
        );
      default:
        throw ServerException(
          'Error occurred with code : ${response.statusCode}',
          response.realUri.toString(),
        );
    }
  }
}
