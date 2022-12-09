import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as GetX;
import 'package:uuid/uuid.dart';
import 'package:wheel/src/biz/auth.dart';
import 'package:wheel/src/biz/user/login_type.dart';
import 'package:wheel/src/global/net_const.dart';
import 'package:wheel/src/model/user/app_login_request.dart';
import 'package:wheel/src/net/rest/response_status.dart';
import 'package:wheel/src/net/rest/result.dart';
import 'package:wheel/src/util/navigation_service.dart';
import 'package:wheel/wheel.dart' show AppLogHandler, GlobalConfig, RestClient, SecureStorageUtil;

class AppInterceptors extends InterceptorsWrapper {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!options.headers.containsKey(HTTP_ACCESS_TOKEN_HEADER)) {
      String? accessToken = await SecureStorageUtil.getString(GlobalConfig.getAccessTokenCachedKey());
      options.headers[HTTP_ACCESS_TOKEN_HEADER] = accessToken ?? "";
    }
    if (!options.headers.containsKey(HTTP_REQUEST_ID_HEADER)) {
      options.headers[HTTP_REQUEST_ID_HEADER] = Uuid().v4();
    }
    handler.next(options);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    Response handleResponse = await autoLogin(response);
    Response handleAccessToken = await handleResponseByCode(handleResponse);
    return super.onResponse(handleAccessToken, handler);
  }

  Future<Response> handleResponseByCode(Response response) async {
    String statusCode = response.data["resultCode"];
    if (statusCode == ResponseStatus.ACCESS_TOKEN_EXPIRED.statusCode) {
      return handleAccessTokenExpired(response);
    }
    if (statusCode == ResponseStatus.ACCESS_TOKEN_INVALID.statusCode) {
      if (NavigationService.instance.navigationKey.currentState != null) {
        NavigationService.instance.navigationKey.currentState!.pushNamedAndRemoveUntil("login", ModalRoute.withName("/"));
      }
    }
    return response;
  }

  Future<Response> handleAccessTokenExpired(Response response) async {
    String? refreshToken = await SecureStorageUtil.getString("refreshToken");
    if (refreshToken == null) {
      return response;
    }
    AuthResult result = await Auth.refreshAccessToken(refreshToken: refreshToken);
    if (result.result == Result.ok) {
      Dio dio = RestClient.createDio();
      return _retryResponse(response, dio);
    } else {
      AppLogHandler.logErrorException("refresh access token failed", result);
    }
    return response;
  }

  Future<Response> autoLogin(Response response) async {
    String loginInvalidCode = ResponseStatus.LOGIN_INVALID.statusCode;
    String notLoginCode = ResponseStatus.NOT_LOGIN.statusCode;
    String statusCode = response.data["statusCode"];
    if (statusCode == loginInvalidCode || statusCode == notLoginCode) {
      String? userName = await SecureStorageUtil.getString("username");
      String? password = await SecureStorageUtil.getString("password");
      /**
       * the refresh time record the refresh request count
       * to avoid a dead loop of refresh token
       */
      String? tokenRefreshTimes = await SecureStorageUtil.getString("refreshTimes") ?? "0";
      if (userName != null && password != null && int.parse(tokenRefreshTimes) < 3) {
        String newRefreshTimes = (int.parse(tokenRefreshTimes) + 1).toString();
        SecureStorageUtil.putString("refreshTimes", newRefreshTimes);
        Future<Response> res = refreshAuthToken(userName, password, response);
        res.whenComplete(() => {}).then((value) => {
              if (RestClient.respSuccess(response)) {SecureStorageUtil.putString("refreshTimes", "0")}
            });
        return res;
      } else {
        //NavigationService.instance.navigateToReplacement("login");
        /**
         * if login invalid
         * jump to the login page
         * it will clear all page except / page
         */
        if (NavigationService.instance.navigationKey.currentState != null) {
          NavigationService.instance.navigationKey.currentState!.pushNamedAndRemoveUntil("login", ModalRoute.withName("/"));
        } else {
          GetX.Get.toNamed('/login');
        }
        return response;
      }
    } else {
      return response;
    }
  }

  Future<Response> _retryResponse(Response response, Dio dio) async {
    // replace the new token
    String? accessToken = await SecureStorageUtil.getString("accessToken");
    response.requestOptions.headers[HTTP_ACCESS_TOKEN_HEADER] = accessToken;
    final options = new Options(
      method: response.requestOptions.method,
      headers: response.requestOptions.headers,
    );
    return dio.request<dynamic>(response.requestOptions.path,
        data: response.requestOptions.data, queryParameters: response.requestOptions.queryParameters, options: options);
  }

  Future<Response> refreshAuthToken(String userName, String password, Response response) async {
    Dio dio = RestClient.createDio();
    dio.lock();
    try {
      AppLoginRequest appLoginRequest = new AppLoginRequest(
        username: userName,
        password: password,
        loginType: LoginType.PHONE,
      );
      AuthResult result = await Auth.login(appLoginRequest: appLoginRequest);
      if (result.result == Result.ok) {
        // resend a request to fetch data
        return _retryResponse(response, dio);
      } else {
        return response;
      }
    } on Exception catch (e) {
      AppLogHandler.logErrorException("登录失败", e);
      return response;
    } finally {
      dio.unlock();
    }
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    AppLogHandler.logDioError(err, handler);
    return super.onError(err, handler);
  }
}
