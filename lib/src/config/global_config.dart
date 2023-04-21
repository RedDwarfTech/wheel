import 'package:global_configuration/global_configuration.dart';

enum ConfigType { DEV, PRO }

class GlobalConfig {
  static Map config = Map<String, String>();

  GlobalConfig() {}

  static getBaseUrl() {
    String configBaseUrl = config["baseUrl"];
    return configBaseUrl;
  }

  static getShareUrl() {
    return config["shareUrl"];
  }

  static getStaticResourceUrl() {
    return config["staticUrl"];
  }

  static getConfig(String key) {
    return config[key];
  }

  static getUserNameCachedKey() {
    return config["userName"];
  }

  // why use the get function?
  // when we want to change the key
  // just change this one place
  static getAccessTokenCachedKey() {
    return config["accessToken"];
  }

  static getRefreshTokenCachedKey() {
    return config["refreshToken"];
  }

  static getRegisterTimeCachedKey() {
    return config["registerTime"];
  }

  static init(ConfigType configType) {
    var globalConfig = GlobalConfiguration();
    if (globalConfig.appConfig.isNotEmpty) {
      config = Map.unmodifiable(globalConfig.appConfig);
    }
    switch (configType) {
      case ConfigType.DEV:
        break;
      case ConfigType.PRO:
        break;
    }
  }
}
