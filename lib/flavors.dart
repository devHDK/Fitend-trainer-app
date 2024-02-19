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
        return 'fitend for trainer_local';
      case Flavor.development:
        return 'fitend tor trainer_dev';
      case Flavor.production:
        return 'fitend for trainer';
      default:
        return 'title';
    }
  }

}
