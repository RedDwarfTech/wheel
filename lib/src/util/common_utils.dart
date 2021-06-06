
import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheel/src/config/global_config.dart';
import 'custom_en.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'history.dart';

class CommonUtils{

  static Future<void> initialApp() async {
    GlobalConfig.init(ConfigType.PRO);
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize Firebase, collection app crash report
    // https://firebase.flutter.dev/docs/crashlytics/usage/
    await Firebase.initializeApp();
    timeago.setLocaleMessages('en', CustomEn());
    await HistoryManager.init();

    // in app purchase initial
    if (defaultTargetPlatform == TargetPlatform.android) {
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
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
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId;  //UUID for Android
        deviceType = "2";
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;  //UUID for iOS
        deviceType = "1";
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    return [deviceName, deviceType, identifier];
  }
}

