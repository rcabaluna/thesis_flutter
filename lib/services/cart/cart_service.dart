import 'package:local_marketplace/common/core/network/endpoint.dart';
import 'package:local_marketplace/common/core/network/index.dart';
import 'package:dio/dio.dart';

class CartService {
  final NetworkService _networkService = NetworkService();

  Future order(List<Map<String, dynamic>> data) async {
    try {
      await _networkService.postRequest(ORDER_URL, body: {"orders": data});
    } on DioException catch (e) {
      rethrow;
    }
  }
}
