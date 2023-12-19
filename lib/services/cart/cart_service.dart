// ignore_for_file: depend_on_referenced_packages

import 'package:local_marketplace/common/core/network/endpoint.dart';
import 'package:local_marketplace/common/core/network/index.dart';
import 'package:dio/dio.dart';

class CartService {
  final NetworkService _networkService = NetworkService();

  Future order(summary, List<Map<String, dynamic>> data) async {
    try {
      await _networkService
          .postRequest(ORDER_URL, body: {"summary": summary, "orders": data});
    } on DioException catch (e) {
      rethrow;
    }
  }
}
