enum Flavor {
  local,
  development,
  production,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.local:
        return '핏엔드 코치_local';
      case Flavor.development:
        return '핏엔드 코치_dev';
      case Flavor.production:
        return '핏엔드 코치';
      default:
        return 'title';
    }
  }
}
