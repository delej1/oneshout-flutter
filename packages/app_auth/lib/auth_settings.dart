enum AuthProviders { email, google, apple, phone, facebook, twitter }

class AppAuthSettings {
  const AppAuthSettings({
    this.authProviders = const [AuthProviders.email],
    this.pathToLogo,
    this.logoSize = 100,
  });

  final List<AuthProviders>? authProviders;
  final String? pathToLogo;
  final double logoSize;
}
