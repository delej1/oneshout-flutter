part of 'auth_bloc.dart';

// enum AuthStatus {
//   authenticated,
//   unauthenticated,
// }

class AuthState extends Equatable {
  const AuthState._({
    required this.status,
    this.user = User.empty,
    this.jwt = '',
  });

  const AuthState.authenticated(User user)
      : this._(
          status: AuthStatus.authenticated,
          user: user,
        );

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  const AuthState.jwt(String jwt)
      : this._(
          status: AuthStatus.authenticated,
          jwt: jwt,
        );

  final AuthStatus status;
  final User user;
  final String jwt;

  @override
  List<Object> get props => [status, user, jwt];
}
