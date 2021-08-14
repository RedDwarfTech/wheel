import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum ConfigType { DEV, PRO }
class GlobalConfig {

  final String baseUrl;
  final String shareUrl;
  final String staticResourceUrl;

  static init(ConfigType configType) {
    switch (configType) {
      case ConfigType.DEV:
        baseUrl = "https://beta-api.poemhub.top";
        shareUrl = "https://beta-share.poemhub.top";
        staticResourceUrl = "https://beta-static.poemhub.top";
        break;
      case ConfigType.PRO:
        baseUrl = GlobalConfiguration().get("baseUrl");
        shareUrl = GlobalConfiguration().get("shareUrl");
        staticResourceUrl = GlobalConfiguration().get("staticUrl");
        break;
    }
  }
}
