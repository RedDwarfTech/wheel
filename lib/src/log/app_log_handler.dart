import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:wheel/src/net/rest/rest_api_error.dart';

class AppLogHandler {
  static Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  static Future<void> logErrorException(String message, Object e) async {
    FirebaseCrashlytics.instance.log(message);
  }

  static Future<void> logErrorStack(String message, StackTrace e) async {
    FirebaseCrashlytics.instance.log(message+","+e.toString());
  }

  static Future<void> logFlutterErrorDetails(FlutterErrorDetails details) async {
    FirebaseCrashlytics.instance.log(details.toString());
  }

  static Future<void> logError(RestApiError error, String message) async {
    FirebaseCrashlytics.instance.log(message);
  }

  static Future<void> logWaring(String message) async {
    logger.w(message);
  }

  static Future<void> logDebugging(RestApiError error, String message) async {
    logger.d(message);
  }
}
