import 'package:app_auth/app_auth.dart';

class BaseRepository {
  BaseRepository({required this.auth});
  final AuthenticationRepository auth;
  // Future<void> init() async {
  //   auth = await getIt.getAsync<AuthenticationRepository>();
  // }
}
