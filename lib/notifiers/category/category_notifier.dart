import 'package:flutter/material.dart';
import 'package:local_marketplace/models/category/category.dart';
import 'package:local_marketplace/services/category/category_service.dart';

class CategoryNotifier extends ChangeNotifier {
  CategoryService categoryService = CategoryService();

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  set categories(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  init() async {
    await getCategories();
  }

  getCategories() async {
    categories = await categoryService.getCategories();
  }
}
