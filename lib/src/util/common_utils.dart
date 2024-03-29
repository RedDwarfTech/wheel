import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wheel/src/config/global_config.dart';
import 'package:wheel/src/model/common/region_flag.dart';

import 'custom_en.dart';
import 'history.dart';

class CommonUtils {
  // pay attention that the load config is async
  // we should wait the file load complete if we want to use the config immediately
  // otherwise the config will get null
  static Future<GlobalConfiguration> initialApp(ConfigType configType) {
    WidgetsFlutterBinding.ensureInitialized();
    timeago.setLocaleMessages('en', CustomEn());
    HistoryManager.init();

    // in app purchase initial
    if (defaultTargetPlatform == TargetPlatform.android) {
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    }
    if (configType == ConfigType.PRO) {
      return GlobalConfiguration().loadFromAsset("pro_app_settings");
    } else if (configType == ConfigType.DEV) {
      return GlobalConfiguration().loadFromAsset("dev_app_settings");
    } else {
      return GlobalConfiguration().loadFromAsset("default_app_settings");
    }
  }

  static Future<List<String>> getDeviceDetails() async {
    String deviceName = "";
    String deviceVersion = "";
    String identifier = "";
    String deviceType = "-1";
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.device!;
        deviceVersion = build.version.toString();
        identifier = build.id!; //UUID for Android
        deviceType = "2";
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name!;
        deviceVersion = data.systemVersion!;
        identifier = data.identifierForVendor!; //UUID for iOS
        deviceType = "1";
      } else if (Platform.isLinux) {
        var data = await deviceInfoPlugin.linuxInfo;
        deviceName = data.name;
        deviceVersion = data.version!;
        identifier = data.id;
        deviceType = "6";
      } else if (Platform.isMacOS) {
        var data = await deviceInfoPlugin.macOsInfo;
        deviceName = data.model;
        deviceVersion = data.kernelVersion;
        identifier = data.systemGUID!;
        deviceType = "9";
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    return [deviceName, deviceType, identifier, deviceVersion];
  }

  /// Read emoji flags from assets.
  static Future<List<RegionFlag>> getRegions() async {
    final jsonStr = await rootBundle.loadString("assets/static/emoji-flags.json", cache: false);
    final flags = json.decode(jsonStr) as List;
    final result = flags.cast<Map>().map((map) => RegionFlag.fromMap(map)).where((flag) {
      return flag.dialCode != null && flag.dialCode!.trim().isNotEmpty;
    }).toList();
    return result;
  }

}
