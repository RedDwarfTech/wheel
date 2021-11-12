import 'dart:io';

import 'package:dio/dio.dart';
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
    RestLogModel restLogModel = RestLogModel(message: message);
    restLogModel.error = e.toString();
    Map jsonMap = restLogModel.toMap();
    try {
      final String domain = GlobalConfiguration().get("logUrl");
      RestClient.postHttpDomain(domain, "/post/logger/v1/log", jsonMap);
    } on Exception catch (e) {}
  }

  static Future<void> logDioError(DioError err, ErrorInterceptorHandler handler) async {
    RestLogModel restLogModel = RestLogModel(message: "dio http request error");
    restLogModel.error = err.toString();
    restLogModel.requestId = err.requestOptions.headers["X-Request-ID"];
    Map jsonMap = restLogModel.toMap();
    try {
      final String domain = GlobalConfiguration().get("logUrl");
      RestClient.postHttpDomain(domain, "/post/logger/v1/log", jsonMap);
    } on Exception catch (e) {}
  }

  static Future<void> logErrorStack(
      String message, Object obj, StackTrace stackTrace) async {
    https: //stackoverflow.com/questions/49707028/how-to-check-flutter-application-is-running-in-debug/49707787#49707787
    if (kReleaseMode) {
      restLogger(message);
    } else {
      logger.e(message, obj, stackTrace);
    }
  }

  static Future<void> logFlutterErrorDetails(
      FlutterErrorDetails details) async {
    if (kReleaseMode) {
    } else {
      logger.e("logFlutterErrorDetails", details);
    }
  }

  static Future<void> logError(RestApiError error, String message) async {
    if (kReleaseMode) {
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
    } on Exception catch (e) {}
  }

  static Future<void> restLoggerException(
      String restLog, StackTrace stackTrace, Object obj) async {
    RestLogModel restLogModel = RestLogModel(message: restLog);
    restLogModel.stackTrace = stackTrace.toString();
    restLogModel.error = obj.toString();
    Map jsonMap = restLogModel.toMap();
    try {
      final String domain = GlobalConfiguration().get("logUrl");
      RestClient.postHttpDomain(domain, "/post/logger/v1/log", jsonMap);
    } on Exception catch (e) {}
  }
}
