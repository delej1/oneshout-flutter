import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class Urls {
  static var baseUrl = kReleaseMode
      ? Platform.isIOS
          ? 'https://oneshout-api.herokuapp.com/'
          : String.fromEnvironment('ENV_TYPE') == 'live'
              ? 'https://oneshout-api.herokuapp.com/'
              : 'https://oneshout-staging.herokuapp.com/'
      // : 'https://oneshout-api.herokuapp.com/';
      : String.fromEnvironment('ENV_TYPE') == 'test'
          ? 'https://oneshout-staging.herokuapp.com/'
          // : 'http://192.168.43.3:1400/';
          // : 'http://192.168.43.9:1400/';
          // : 'http://192.168.0.155:1400/';
          : 'https://oneshout-staging.herokuapp.com/';

  // : 'http://192.168.8.155:1400/';
  // : 'http://192.168.8.144:1400/';
  // : 'http://172.20.10.3:1400/';

  static var baseApi = '${Urls.baseUrl}api/';
  static var getJWTToken = 'auth/provider';
  static var register = '${Urls.baseUrl}firebase/auth/';
  static var shoutsEndpoint = 'v1/shouts';
  static var locatorEndpoint = 'v1/locators';
}

class Keys {
  // static const googleMapKey = kReleaseMode
  //     ? 'AIzaSyCRk8ckRhR9AW4NEal-3Q7jzaYN4QlYTdo'
  //     : 'AIzaSyC3MttpUGjhhvnLGAW0l6K1FPvcifs-lWA';
  static const googleMapKey = 'AIzaSyCRk8ckRhR9AW4NEal-3Q7jzaYN4QlYTdo';
  static const oneSignalAppId = kReleaseMode
      ? '73ab6e9c-a06c-427f-b6ea-6dfa8519ac79'
      : '73ab6e9c-a06c-427f-b6ea-6dfa8519ac79';
  static const appConfigTarget = 'IS_GROUP_TARGET';
}
