import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:wheel/src/model/rest_log_model.dart';
import 'package:wheel/src/net/rest/rest_api_error.dart';

import '../../wheel.dart';

class AppLogHandler {
  static Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  static Future<void> logErrorException(String message, Object e) async {
    FirebaseCrashlytics.instance.log(message);
  }

  static Future<void> logErrorStack(String message, Object obj, StackTrace stackTrace) async {
    https: //stackoverflow.com/questions/49707028/how-to-check-flutter-application-is-running-in-debug/49707787#49707787
    if (kReleaseMode) {
      restLogger(message);
      FirebaseCrashlytics.instance.log(message + "," + stackTrace.toString());
    } else {
      logger.e(message, obj, stackTrace);
    }
  }

  static Future<void> logFlutterErrorDetails(FlutterErrorDetails details) async {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.log(details.toString());
    } else {
      logger.e("logFlutterErrorDetails", details);
    }
  }

  static Future<void> logError(RestApiError error, String message) async {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.log(message);
    } else {
      logger.e(message, error);
    }
  }

  static Future<void> logWaring(String message) async {
    logger.w(message);
  }

  static Future<void> logDebugging(RestApiError error, String message) async {
    logger.d(message);
  }

  static Future<void> restLogger(String restLog) async {
    RestLogModel restLogModel = RestLogModel(message: restLog);
    restLogModel.message = restLog;
    Map jsonMap = restLogModel.toMap();
    try {
      final String domain = GlobalConfiguration().get("logUrl");
      RestClient.postHttpDomain(domain, "/post/logger/v1/log", jsonMap);
    } on Exception catch (e) {

    }
  }

  static Future<void> restLoggerException(String restLog,StackTrace stackTrace) async {
    RestLogModel restLogModel = RestLogModel(message: restLog);
    restLogModel.stackTrace = stackTrace.toString();
    Map jsonMap = restLogModel.toMap();
    try {
      final String domain = GlobalConfiguration().get("logUrl");
      RestClient.postHttpDomain(domain, "/post/logger/v1/log", jsonMap);
    } on Exception catch (e) {

    }
  }
}
