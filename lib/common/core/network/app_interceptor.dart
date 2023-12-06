// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:dio/dio.dart';

import '../../../notifiers/app_notifier.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    String authorization = "Bearer ${getIt<AppNotifier>().currentToken}";
    options.headers[HttpHeaders.authorizationHeader] = authorization;
    return handler.next(options);
  }
}
