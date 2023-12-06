import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/models/seller/seller.dart';

class ProductBySeller {
  Product product;
  String id;
  Seller seller;
  List<String> imageUrls = [];
  int qty;
  num price;
  ProductBySeller(
      {required this.product,
      required this.id,
      required this.qty,
      required this.seller,
      required this.imageUrls,
      required this.price});
}
