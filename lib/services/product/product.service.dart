// ignore_for_file: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:local_marketplace/common/core/network/endpoint.dart';
import 'package:local_marketplace/common/core/network/index.dart';
import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/models/productbyseller/product_by_seller.dart';
import 'package:local_marketplace/models/seller/seller.dart';

class ProductService {
  final NetworkService _networkService = NetworkService();

  Future<List<ProductBySeller>> getProducts() async {
    try {
      final result = await _networkService.getRequest(PRODUCT_URL);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(result);

      return data.map((json) {
        Product product = Product.fromJson(json["productId"]);
        Seller seller = Seller.fromJson(json["sellerId"]);

        var urls = (json["imageUrls"] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        return ProductBySeller(
            product: product,
            id: json["_id"],
            seller: seller,
            imageUrls: urls,
            price: json["price"],
            qty: json["quantity"]);
      }).toList();
    } on DioException catch (e) {
      return [];
    }
  }

  Future<List<ProductBySeller>> searchProducts(String searchTerm) async {
    final url = "$PRODUCT_URL/name/$searchTerm";
    try {
      final result = await _networkService.getRequest(url);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(result);
      return data.map((json) {
        Product product = Product.fromJson(json["productId"]);

        Seller seller = Seller.fromJson(json["sellerId"]);
        var urls = (json["imageUrls"] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        return ProductBySeller(
            product: product,
            id: json["_id"],
            seller: seller,
            imageUrls: urls,
            price: json["price"],
            qty: json["quantity"]);
      }).toList();
    } on DioException catch (e) {
      return [];
    }
  }

  Future<List<ProductBySeller>> searchProductsbyCategory(
      String searchInput) async {
    final url = "$PRODUCT_URL/categoryId/$searchInput";
    try {
      final result = await _networkService.getRequest(url);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(result);
      return data.map((json) {
        Product product = Product.fromJson(json["productId"]);

        Seller seller = Seller.fromJson(json["sellerId"]);
        var urls = (json["imageUrls"] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        return ProductBySeller(
            product: product,
            id: json["_id"],
            seller: seller,
            imageUrls: urls,
            price: json["price"],
            qty: json["quantity"]);
      }).toList();
    } on DioException catch (e) {
      return [];
    }
  }

  Future<List<ProductBySeller>> getProductDetails(String searchInput) async {
    final url = "$PRODUCT_URL/productId/$searchInput";

    try {
      final result = await _networkService.getRequest(url);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(result);
      return data.map((json) {
        Product product = Product.fromJson(json["productId"]);

        Seller seller = Seller.fromJson(json["sellerId"]);
        var urls = (json["imageUrls"] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        return ProductBySeller(
            product: product,
            id: json["_id"],
            seller: seller,
            imageUrls: urls,
            price: json["price"],
            qty: json["quantity"]);
      }).toList();
    } on DioException catch (e) {
      return [];
    }
  }
}
