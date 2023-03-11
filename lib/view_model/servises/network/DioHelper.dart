import 'package:dio/dio.dart';
import 'package:todo_shared/view_model/servises/network/endPoints.dart';

class DioHelper {
  static late final Dio dio;

  static initialize() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        headers: {
          'Accept' : 'application/json',
        },
      ),
    );
  }

  static Future<Response?> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization' : 'Bearer $token',
    };
    try {
      var response = await dio.get(
        endPoint,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  static Future<Response> put({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) async {
    try {
      var response = await dio.put(
        endPoint,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> post({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization' : 'Bearer $token',
    };
    try {
      var response = await dio.post(
        endPoint,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  static Future<Response> patch({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization' : 'Bearer $token',
    };
    try {
      var response = await dio.patch(
        endPoint,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> delete({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization' : 'Bearer $token',
    };
    try {
      var response = await dio.delete(
        endPoint,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
