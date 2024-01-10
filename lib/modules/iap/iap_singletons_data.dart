class IapAppData {
  factory IapAppData() {
    return iapAppData;
  }
  IapAppData._internal();
  static final IapAppData iapAppData = IapAppData._internal();

  bool entitlementIsActive = false;
  String appUserID = '';
}

final iapAppData = IapAppData();
