class AccessInfo {
  String token;
  static final AccessInfo _singleton = AccessInfo._create();

  factory AccessInfo() {
    return _singleton;
  }

  AccessInfo._create();
}
