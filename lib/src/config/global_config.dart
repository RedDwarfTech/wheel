import 'package:global_configuration/global_configuration.dart';

enum ConfigType { DEV, PRO }

class GlobalConfig {
  GlobalConfig(this.baseUrl, this.shareUrl, this.staticResourceUrl);

  static final GlobalConfiguration config = GlobalConfiguration();
  String baseUrl = config.get("baseUrl");
  String shareUrl = config.get("shareUrl");
  String staticResourceUrl = config.get("staticUrl");

  static getBaseUrl() {
    String configBaseUrl = config.get("baseUrl");
    return configBaseUrl;
  }

  static getShareUrl() {
    return config.get("shareUrl");
  }

  static getStaticResourceUrl() {
    return config.get("staticUrl");
  }

  static getConfig(String key) {
    return config.get(key);
  }

  static init(ConfigType configType) {
    switch (configType) {
      case ConfigType.DEV:
        break;
      case ConfigType.PRO:
        break;
    }
  }
}
