// ignore_for_file: depend_on_referenced_packages_TypeError (type '_Map<String, dynamic>' is not a subtype of type 'Iterable<dynamic>')
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:local_marketplace/common/core/network/endpoint.dart';
import 'package:local_marketplace/common/core/network/index.dart';
import 'package:local_marketplace/models/orders/order_details_model.dart';
import 'package:local_marketplace/models/orders/orders_model.dart';
import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/models/seller/seller.dart';
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
        Seller seller = Seller.fromJson(json["sellerId"]);

        return OrderDetails(
            id: json['_id'],
            orderId: json['orderId'],
            quantity: json['quantity'],
            status: json['status'],
            total: json['total'],
            seller: seller,
            createdAt: json['createdAt'],
            updatedAt: json['updatedAt']);
      }).toList();
    } on DioException catch (e) {
      return [];
    }
  }

  Future<bool> acceptOrder(String orderId) async {
    final url = "$ORDER_URL/accept-order/$orderId";

    try {
      final result = await _networkService.putRequest(url);
      return true;
    } on DioException catch (e) {
      return false;
    }
  }

  Future<bool> receiveOrder(String orderId) async {
    final url = "$ORDER_URL/receive-order/$orderId";

    try {
      final result = await _networkService.putRequest(url);
      return true;
    } on DioException catch (e) {
      return false;
    }
  }

  // MY ORDERS
  Future<List<ShopOrders>> getMyOrders() async {
    final url = "$ORDER_URL/my-orders";
    try {
      final result = await _networkService.getRequest(url);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(result);
      return data.map((json) {
        print(json);
        return ShopOrders(
            orderId: json['_id'],
            deliveryType: json['deliveryType'],
            address: json['address'],
            notes: json['notes']);
      }).toList();
    } on DioException catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<OrderSummary>> getOrderSummary(String orderIdx) async {
    final url = "$ORDER_URL/get-order-summary/$orderIdx";
    try {
      final result = await _networkService.getRequest(url);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(result);
      return data.map((json) {
        return OrderSummary(
            deliveryType: json['deliveryType'],
            address: json['address'],
            notes: json['notes']);
      }).toList();
    } on DioException catch (e) {
      print(e);
      throw 'Error';
    }
  }
}
