import 'package:global_configuration/global_configuration.dart';

enum ConfigType { DEV, PRO }

class GlobalConfig {
  final baseUrl = GlobalConfiguration().get("baseUrl");
  final shareUrl = GlobalConfiguration().get("shareUrl");
  final staticResourceUrl = GlobalConfiguration().get("staticUrl");

  static init(ConfigType configType) {
    switch (configType) {
      case ConfigType.DEV:
        break;
      case ConfigType.PRO:
        break;
    }
  }
}
