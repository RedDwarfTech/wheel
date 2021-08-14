import 'package:global_configuration/global_configuration.dart';

enum ConfigType { DEV, PRO }

class GlobalConfig {
  GlobalConfig(this.baseUrl, this.shareUrl, this.staticResourceUrl);

  String baseUrl = GlobalConfiguration().get("baseUrl");
  String shareUrl = GlobalConfiguration().get("shareUrl");
  String staticResourceUrl = GlobalConfiguration().get("staticUrl");

  static getBaseUrl() {
    return GlobalConfiguration().get("baseUrl");
  }

  static getShareUrl() {
    return GlobalConfiguration().get("shareUrl");
  }

  static getStaticResouceUrl() {
    return GlobalConfiguration().get("staticUrl");
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
