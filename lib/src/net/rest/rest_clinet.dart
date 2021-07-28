import 'package:dio/dio.dart';
import 'package:global_configuration/global_configuration.dart';

import 'app_interceptors.dart';

class RestClient {

  static Dio dioInstance = Dio(BaseOptions(connectTimeout: 10000, receiveTimeout: 30000, baseUrl: GlobalConfiguration().get("baseUrl")))
      ..interceptors.add(AppInterceptors());

  static Dio createDio() {
    // pay attention the dio instance should be single
    // and the interceptor should add for one
    // should not be added every time, it may cause multiple duplicate interceptor
    // this may cause a massive flood http request(important)
    return dioInstance;
  }

  static Future<Response> postHttp(String path, Object data) async {
    Dio dio = createDio();
    Response response = await dio.post(path, data: data);
    return response;
  }

  static Future<Response> postHttpNewDio(String path, Object data) async {
    final url = GlobalConfiguration().get("baseUrl") + path;
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
