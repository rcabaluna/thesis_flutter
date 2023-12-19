// ignore_for_file: depend_on_referenced_packages_TypeError (type '_Map<String, dynamic>' is not a subtype of type 'Iterable<dynamic>')
import 'package:dio/dio.dart';
import 'package:local_marketplace/common/core/network/endpoint.dart';
import 'package:local_marketplace/common/core/network/index.dart';
import 'package:local_marketplace/models/orders/order_details_model.dart';
import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/models/shop/shop_orders_model.dart';
import 'package:local_marketplace/models/customer/customer_details.dart';

class OrderService {
  final NetworkService _networkService = NetworkService();

  Future<List<ShopOrders>> getShopOrders() async {
    final url = "$SHOP_URL/my-shop-orders";
    try {
      final result = await _networkService.getRequest(ORDER_URL);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(result);
      return data.map((json) {
        print(json);
        return ShopOrders(
            orderId: json['_id'],
            status: json['status'],
            deliveryType: json['deliveryType'],
            address: json['address'],
            notes: json['notes']);
      }).toList();
    } on DioException catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<OrderDetails>> getShopOrderDetails(String searchInput) async {
    final url = "$ORDER_URL/order-details/$searchInput";

    try {
      final result = await _networkService.getRequest(url);

      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(result);

      return data.map((json) {
        return OrderDetails(
            id: json['_id'],
            orderId: json['orderId'],
            quantity: json['quantity'],
            total: json['total'],
            createdAt: json['createdAt'],
            updatedAt: json['updatedAt']);
      }).toList();
    } on DioException catch (e) {
      return [];
    }
  }

  Future<List<ShopOrders>> acceptOrder(String orderShopId) async {
    final url = "$ORDER_URL/accept-order/$orderShopId";
    try {
      final result = await _networkService.getRequest(url);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(result);
      return data.map((json) {
        print(json);
        return ShopOrders(
            orderId: json['_id'],
            status: json['status'],
            deliveryType: json['deliveryType'],
            address: json['address'],
            notes: json['notes']);
      }).toList();
    } on DioException catch (e) {
      print(e);
      return [];
    }
  }
}
