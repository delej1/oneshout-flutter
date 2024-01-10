// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/models/user_subscription.dart';
import 'package:cache/cache.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
// import 'package:twitter_login/src/twitter_login.dart';

/// {@template sign_up_with_email_and_password_failure}
/// Thrown if during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template log_in_with_email_and_password_failure}
/// Thrown during the login process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
/// {@endtemplate}
class LogInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template log_in_with_google_failure}
/// Thrown during the sign in with google process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithCredential.html
/// {@endtemplate}
class LogInWithGoogleFailure implements Exception {
  /// {@macro log_in_with_google_failure}
  const LogInWithGoogleFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithGoogleFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithGoogleFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const LogInWithGoogleFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const LogInWithGoogleFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithGoogleFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithGoogleFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const LogInWithGoogleFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const LogInWithGoogleFailure(
          'The credential verification ID received is invalid.',
        );
      default:
        return const LogInWithGoogleFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template log_in_with_google_failure}
/// Thrown during the sign in with facebook process if a failure occurs.
/// {@endtemplate}
class LogInWithFacebookFailure implements Exception {
  /// {@macro log_in_with_google_failure}
  const LogInWithFacebookFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithFacebookFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithFacebookFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithFacebookFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const LogInWithFacebookFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const LogInWithFacebookFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithFacebookFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithFacebookFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const LogInWithFacebookFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const LogInWithFacebookFailure(
          'The credential verification ID received is invalid.',
        );
      default:
        return const LogInWithFacebookFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template log_in_with_google_failure}
/// Thrown during the sign in with facebook process if a failure occurs.
/// {@endtemplate}
class LogInWithTwitterFailure implements Exception {
  /// {@macro log_in_with_google_failure}
  const LogInWithTwitterFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithTwitterFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithTwitterFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithTwitterFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const LogInWithTwitterFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const LogInWithTwitterFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithTwitterFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithTwitterFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const LogInWithTwitterFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const LogInWithTwitterFailure(
          'The credential verification ID received is invalid.',
        );
      default:
        return const LogInWithTwitterFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template send_reset_password_email_failure}
/// Thrown during the send reset email process if a failure occurs.
/// {@endtemplate}
class SendPasswordResetEmailFailure implements Exception {
  /// {@macro send_reset_password_email_failure}
  const SendPasswordResetEmailFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory SendPasswordResetEmailFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':

      case 'user-not-found':
        return const SendPasswordResetEmailFailure(
          'Email is not found, please create an account.',
        );

      default:
        return const SendPasswordResetEmailFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template send_reset_password_email_failure}
/// Thrown during the send reset email process if a failure occurs.
/// {@endtemplate}
class ServerLoginFailure implements Exception {
  /// {@macro send_reset_password_email_failure}
  const ServerLoginFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory ServerLoginFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':

      case 'user-not-found':
        return const ServerLoginFailure(
          'Email is not found, please create an account.',
        );

      default:
        return const ServerLoginFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

///
enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    required String baseUrl,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _baseUrl = baseUrl,
        api = baseUrl;

  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final String _baseUrl;
  final String api;
  final _controller = StreamController<AuthStatus>();
  final _controllerUser = StreamController<User>();

  /// Whether or not the current environment is web
  /// Should only be overriden for testing purposes. Otherwise,
  /// defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  Stream<User> get user async* {
    final c = currentUser;
    if (c == User.empty) {
      yield User.empty;
    } else {
      yield c;
    }
    yield* _controllerUser.stream;
  }

  Stream<AuthStatus> get status async* {
    final c = currentUser;
    if (c == User.empty) {
      yield AuthStatus.unknown;
    } else {
      yield AuthStatus.authenticated;
    }
    yield* _controller.stream;
  }

  ///save user to cache
  Future<void> saveUser(User user, {bool redirect = true}) async {
    final box = GetStorage();
    await box.write('userCacheKey', jsonEncode(user.toJson()));
    if (redirect) _controllerUser.add(user);
  }

  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  User get currentUser {
    final box = GetStorage();
    // ignore: omit_local_variable_types
    final user = box.read<String>('userCacheKey');
    // return User.empty;
    if (user == null) {
      return User.empty;
    } else {
      final u = jsonDecode(user) as Map<String, dynamic>;
      return User.fromJson(u);
    }
  }

  ///
  Future<User> formatUser(Map<String, dynamic> data, String jwt,
      {bool save = true, bool redirect: true}) async {
    final user = currentUser.copyWith(
      jwt: jwt,
      id: data['id'] != null ? data['id'].toString() : '',
      email: data['email'] != null ? data['email'].toString() : '',
      firstname: data['firstname'] != null ? data['firstname'].toString() : '',
      lastname: data['lastname'] != null ? data['lastname'].toString() : '',
      phone: data['phone'] != null ? data['phone'].toString() : '',
      country: data['country'] != null ? data['country'].toString() : '',
      confirmed: data['confirmed'] != null && data['confirmed'] as bool,
      userSubscription: data['subscription'] != null
          ? UserSubscription.fromJson(
              data['subscription'] as Map<String, dynamic>,
            )
          : UserSubscription.empty,
      hasValidSubscription: data['hasValidSubscription'] as bool || false,
      type: data['type'] != null ? data['type'].toString() : 'private',
      // photo: data['photo']?.toString() ?? '',
    );

    if (save) await saveUser(user, redirect: redirect);
    return user;
  }

  // /// Stream of [User] which will emit the current user when
  // /// the authentication state changes.
  // ///
  // /// Emits [User.empty] if the user is not authenticated.
  // Stream<User> get user {
  //   // return _firebaseAuth.authStateChanges().map((firebaseUser) {
  //   //   final user = firebaseUser == null ? User.empty : firebaseUser.toUser;

  //   //   _cache.write(key: userCacheKey, value: user);

  //   //   return user;
  //   // });
  //   return currentUser;
  // }

  // ///save user to cache
  // Future<void> saveUser(User user) async {
  //   // final box = GetStorage();
  //   // await box.write('userCacheKey', user);
  //   // final u = box.read<User>('userCacheKey') ?? User.empty;
  //   _cache.write(key: userCacheKey, value: user);
  // }

  // /// Returns the current cached user.
  // /// Defaults to [User.empty] if there is no cached user.
  // User get currentUser {
  //   // final box = GetStorage();
  //   // ignore: omit_local_variable_types
  //   // final user = box.read<User>('userCacheKey') ?? User.empty;
  //   // return user;
  //   return _cache.read<User>(key: userCacheKey) ?? User.empty;
  // }

  ///
  Future<void> getFCMToken() async {
    try {
      await FirebaseMessaging.instance.getToken().then(
        (String? token) async {
          print('fcmtoken= ${token!}');

          if (token.isNotEmpty) {
            await writeFCMTokenToStorage(token);
            unawaited(
              sendFCMTokenToServer(
                newToken: token,
                oldToken: readFCMTokenFromStorage()!,
              ),
            );
          } else {
            await getFCMToken();
          }
        },
        onError: (dynamic err) async {
          if (kDebugMode) {
            print(err.toString());
          }
          await getFCMToken();
        },
      );
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    }
  }

  /// Return fct token
  String? readFCMTokenFromStorage() {
    final box = GetStorage();
    return box.read<String>('currentFCMToken');
  }

  /// Return fct token
  Future<void> writeFCMTokenToStorage(String token) async {
    final box = GetStorage();
    await box.write('currentFCMToken', token);
  }

  ///
  Future<void> sendFCMTokenToServer({
    required String newToken,
    required String oldToken,
  }) async {
    final res = await http.post(
      Uri.parse('${_baseUrl}firebase/update-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${currentUser.jwt}'
      },
      body: jsonEncode({
        'oldToken': oldToken,
        'newToken': newToken,
        'uid': currentUser.uid,
      }),
    );

    if (res.statusCode == 200) {
      print('FCM recorded.');
    } else {
      print('FCM recording failed.');
    }
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  Future<User?> signUp({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String phone,
    required String country,
  }) async {
    // try {
    // await _firebaseAuth.createUserWithEmailAndPassword(
    //   email: email,
    //   password: password,
    // );
    final res = await http.post(
      Uri.parse('${_baseUrl}auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'phone': phone,
        'email': email,
        'password': password,
        'firstname': firstname,
        'lastname': lastname,
        'country': country,
        'isGroup': const bool.fromEnvironment('IS_GROUP_TARGET')
      }),
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      final user = await formatUser(
        data['user'] as Map<String, dynamic>,
        data['jwt'] as String,
        save: false,
      );

      // _controller.add(AuthStatus.authenticated);
      // return user;
      return user;
    } else {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final err = data['error'] as Map<String, dynamic>;
      throw SignUpWithEmailAndPasswordFailure(err['message'].toString());
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<firebase_auth.UserCredential?> logInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      if (isWeb) {
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }
      return await _firebaseAuth.signInWithCredential(credential);

      // final idToken =
      //     (credential as firebase_auth.GoogleAuthCredential).idToken;

      // await logInToServer(idToken: idToken);
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<User?> logInWithEmailAndPassword({
    required String phone,
    required String password,
  }) async {
    try {
      // await _firebaseAuth.signInWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
      // return await _firebaseAuth.currentUser!.getIdToken();
      final dio = Dio(BaseOptions(baseUrl: _baseUrl));
      final response = await dio.post<dynamic>(
        'auth/login',
        data: jsonEncode({
          'phone': phone,
          'password': password,
        }),
      );

      // final res = response as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;

        final user = await formatUser(
          data['user'] as Map<String, dynamic>,
          data['jwt'] as String,
        );

        _controller.add(AuthStatus.authenticated);
        return user;
      }
    } on DioError catch (e) {
      throw LogInWithEmailAndPasswordFailure(
        e.response!.data['error']['message'].toString(),
      );
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_, s) {
      // print(s);
      throw const LogInWithEmailAndPasswordFailure();
    }
    return null;
  }

  /// Signs in with Facebook.
  ///
  /// Throws a [LogInWithFacebookFailure] if an exception occurs.
  Future<firebase_auth.UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // Create a credential from the access token
        final facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        // Once signed in, return the UserCredential
        return await _firebaseAuth.signInWithCredential(facebookAuthCredential);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw LogInWithFacebookFailure.fromCode(e.code);
    } catch (e) {
      throw const LogInWithFacebookFailure();
    }
  }

  /// Signs in with Facebook.
  ///
  /// Throws a [LogInWithTwitterFailure] if an exception occurs.
  Future<firebase_auth.UserCredential?> signInWithTwitter() async {
    try {
      // // Trigger the sign-in flow
      // final twitterLogin = TwitterLogin(
      //   // Consumer API keys
      //   apiKey: 'xxxx',
      //   // Consumer API Secret keys
      //   apiSecretKey: 'xxxx',
      //   // Registered Callback URLs in TwitterApp
      //   // Android is a deeplink
      //   // iOS is a URLScheme
      //   redirectURI: 'example://',
      // );
      // final result = await twitterLogin.login();
      // if (result.status == TwitterLoginStatus.loggedIn) {
      //   // Create a credential from the access token
      //   const accessToken = '...'; // From 3rd party provider
      //   const secret = '...'; // From 3rd party provider
      //   final twitterAuthCredential = TwitterAuthProvider.credential(
      //     accessToken: accessToken,
      //     secret: secret,
      //   );

      //   // Once signed in, return the UserCredential
      //   return await _firebaseAuth.signInWithCredential(twitterAuthCredential);
      // }
      return null;
    } on FirebaseAuthException catch (e) {
      throw LogInWithTwitterFailure.fromCode(e.code);
    } catch (e) {
      throw const LogInWithTwitterFailure();
    }
  }

  /// Signs in to server with provided firebase user.
  ///
  /// Throws a [ServerLoginFailure] if an exception occurs.
  Future<User> logInToServer() async {
    try {
      final idToken = await _firebaseAuth.currentUser?.getIdToken();
      final dioClient = Dio()
        ..options = BaseOptions(
          baseUrl: _baseUrl,
        );
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

      final response = await dioClient.post<dynamic>(
        'auth/login',
        data: {
          'identifier': 'owner@test.com',
          'password': '123456',
          'idToken': idToken,
        },
      ).timeout(const Duration(seconds: Duration.millisecondsPerMinute));

      if (response.statusCode == 200) {
        var data = response.data as Map<String, dynamic>;
        data = data['data'] as Map<String, dynamic>;
        // print(data);
        final u = data['user'] as Map<String, dynamic>;
        // print(u);
        // print(currentUser);
        final user = currentUser.copyWith(
          jwt: data['jwt'] != null ? data['jwt'] as String : null,
          id: u['id'] != null ? u['id'].toString() : '',
          // businessId: u['businessId'] != null ? u['businessId'].toString() : '',
          // locationId: u['locationId'] != null ? u['locationId'].toString() : '',
          // email: u['email'] != null ? u['email'] as String : null,
          // username: u['username'] != null ? u['username'] as String : null,
          // confirmed: u['confirmed'] != null ? u['confirmed'] as bool : false,
          // blocked: u['blocked'] as bool,
        );

        await saveUser(user);
        return user;
      } else {
        return User.empty;
      }
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const ServerLoginFailure();
    }
  }

  ///
  Future<void> storeJwtToken(String token) async {
    try {
      final box = GetStorage();
      await box.write('jwtToken', token);

      debugPrint('Fetched and stored JWT.');
    } catch (e) {
      throw Exception(e);
    }
  }

  ///
  String retrieveJwtToken() {
    try {
      final box = GetStorage();
      // ignore: omit_local_variable_types
      final String? token = box.read('jwtToken');
      return token ?? '';
    } catch (e) {
      return '';
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        // _firebaseAuth.signOut(),
        // _googleSignIn.signOut(),
        // FacebookAuth.instance.logOut()
      ]);
      _controller.add(AuthStatus.unauthenticated);
      _controllerUser.add(User.empty);
      final box = GetStorage();
      await box.remove('userCacheKey');
    } catch (_) {
      throw LogOutFailure();
    }
  }

  /// Signs in with the provided [email].
  ///
  /// Throws a [SendPasswordResetEmailFailure] if an exception occurs.
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      throw SendPasswordResetEmailFailure.fromCode(e.code);
    } catch (_) {
      throw const SendPasswordResetEmailFailure();
    }
  }
}

// extension on firebase_auth.User {
  // User get toUser {
//     return User(
//       id: '',
//       businessId: '',
//       locationId: '',
//       email: email,
//       name: displayName,
//       photo: photoURL,
//       // uid: uid
//     );
//   }
// }
