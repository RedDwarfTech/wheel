import 'package:dio/dio.dart';
import 'package:global_configuration/global_configuration.dart';

import '../../../wheel.dart';
import 'app_interceptors.dart';

class RestClient {
  static RestClient _instance = RestClient._internal();
  static Dio? dioInstance;

  factory RestClient() => _instance;

  ///通用全局单例，第一次使用时初始化
  RestClient._internal() {
    if (null == dioInstance) {
      dioInstance = Dio(BaseOptions(connectTimeout: 10000, receiveTimeout: 30000, baseUrl: GlobalConfig.getBaseUrl()))
        ..interceptors.add(AppInterceptors());
    }
  }

  static Dio createDio() {
    // pay attention the dio instance should be single
    // and the interceptor should add for one
    // should not be added every time, it may cause multiple duplicate interceptor
    // this may cause a massive flood http request(important)
    if (null == dioInstance) {
      dioInstance = Dio(BaseOptions(connectTimeout: 10000, receiveTimeout: 30000, baseUrl: GlobalConfig.getBaseUrl()))
        ..interceptors.add(AppInterceptors());
    }
    return dioInstance!;
  }

  static Future<Response> postHttp(String path, Object data) async {
    Dio dio = createDio();
    Response response = await dio.post(path, data: data);
    return response;
  }

  static Future<Response> postAuthDio(String path, Object data) async {
    final url = GlobalConfig.getConfig("authUrl") + path;
    Dio dio = new Dio();
    Response response = await dio.post(url, data: data);
    return response;
  }

  static Future<Response> postHttpDomain(String domain,String path, Object data) async {
    final url = domain + path;
    Dio dio = new Dio();
    Response response = await dio.post(url, data: data);
    return response;
  }

  static Future<Response> putHttp(String path, Object? data) async {
    final url = GlobalConfiguration().get("baseUrl") + path;
    Dio dio = createDio();
    Response response = await dio.put(url, data: data);
    return response;
  }

  static Future<Response> getHttp(String path) async {
    final url = GlobalConfiguration().get("baseUrl") + path;
    Dio dio = createDio();
    Response response = await dio.get(url);
    return response;
  }

  static bool respSuccess(Response response) {
    return response.statusCode == 200 && response.data["statusCode"] == "200" && response.data["resultCode"] == "200";
  }
}
