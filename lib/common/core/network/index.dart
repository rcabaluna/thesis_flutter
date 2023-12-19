import 'dart:io';

import 'package:local_marketplace/common/core/network/app_interceptor.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:dio/dio.dart';

class NetworkService {
  // final String _baseUrl = "95.111.202.26:3000";
  final String _baseUrl = "192.168.117.234:3000";
  // final String _baseUrl = "192.168.204.234:3000";

  late Dio _dio;
  NetworkService() {
    _dio = Dio(_options)..interceptors.add(getIt<AppInterceptor>());
  }

  BaseOptions get _options => BaseOptions(headers: _getHeaders());

  Map<String, String> _getHeaders() {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };

    return headers;
  }

  Future<dynamic> getRequest(
    String url, {
    String? baseUrl,
    Map<String, String>? queryParameters,
  }) async {
    Uri endpoint = Uri.http(baseUrl ?? _baseUrl, url, queryParameters);
    Response response = await _dio.getUri(endpoint);

    return response.data;
  }

  Future<Response> getRawRequest(
    String url, {
    String? baseUrl,
    Map<String, String>? queryParameters,
  }) async {
    Uri endpoint = Uri.http(baseUrl ?? _baseUrl, url, queryParameters);
    Response response = await _dio.getUri(endpoint);

    return response;
  }

  Future<dynamic> deleteRequest(String url) async {
    Uri endpoint = Uri.http(_baseUrl, url);
    Response response = await _dio.deleteUri(endpoint);
    return response;
  }

  Future<dynamic> postRequest(
    String url, {
    dynamic body,
    bool withCookies = false,
  }) async {
    Uri endpoint = Uri.http(_baseUrl, url);
    return await _dio.postUri(endpoint, data: body ?? {});
  }

  Future<dynamic> putRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    Uri endpoint = Uri.http(_baseUrl, url);
    Response response = await _dio.putUri(endpoint, data: body ?? {});

    return response;
  }

  Future<dynamic> patchRequest(String url, {Map<String, dynamic>? body}) async {
    Uri endpoint = Uri.http(_baseUrl, url);
    Response response = await _dio.patchUri(endpoint, data: body ?? {});

    return response;
  }
}
