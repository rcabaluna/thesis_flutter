import 'package:local_marketplace/common/core/network/endpoint.dart';
import 'package:local_marketplace/common/core/network/index.dart';
import 'package:dio/dio.dart';
import 'package:local_marketplace/models/category/category.dart';

class CategoryService {
  final NetworkService _networkService = NetworkService();

  Future<List<Category>> getCategories() async {
    try {
      final result = await _networkService.getRequest(CATEGORY_URL);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(result);
      return data.map((e) => Category.fromJson(e)).toList();
    } on DioException catch (e) {
      return [];
    }
  }
}
