import 'package:flutter/material.dart';
import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/models/productbyseller/product_by_seller.dart';
import 'package:local_marketplace/services/product/product.service.dart';

class ProductNotifier extends ChangeNotifier {
  final ProductService _productService = ProductService();

  Product? _product;
  Product? get product => _product;

  set product(Product? product) {
    _product = product;
    notifyListeners();
  }

  ProductBySeller? _productBySeller;
  ProductBySeller? get productBySeller => _productBySeller;

  set productBySeller(ProductBySeller? productBySeller) {
    _productBySeller = productBySeller;
    notifyListeners();
  }

  List<ProductBySeller> _productsBySeller = [];
  List<ProductBySeller> get productsBySeller => _productsBySeller;

  set productsBySeller(List<ProductBySeller> productsBySeller) {
    _productBySeller = productBySeller;
    notifyListeners();
  }

  List<Product> _products = [];
  List<Product> get products => _products;

  set products(List<Product> products) {
    _products = products;
    notifyListeners();
  }

  Future getProductsBySeller() async {
    _productsBySeller = await _productService.getProductsBySeller();
  }

  Future getProducts() async {
    products = await _productService.getProducts();
  }

  Future init() async {
    await getProductsBySeller();
    await getProducts();
  }
}
