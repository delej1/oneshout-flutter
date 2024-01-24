library app_auth;

export 'package:authentication_repository/authentication_repository.dart';
export 'package:form_inputs/form_inputs.dart';

export 'auth_settings.dart';
export 'src/app_auth.dart';
export 'src/auth/auth.dart';
export 'src/auth_routes.dart';
export 'src/change_password/change_password.dart';
export 'src/forgot_password/forgot_password.dart';
export 'src/login/login.dart';
export 'src/sign_up/sign_up.dart';

//routes.
const String forgotPasswordRoute = '/auth/forgot_password';
const String signUpRoute = '/auth/sign_up';
const String loginRoute = '/auth/login';
const String changePasswordRoute = '/auth/change_password';
