import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/models/productbyseller/product_by_seller.dart';

class Cart {
  late int quantity;
  late ProductBySeller product;
  late bool includeInTotal;
  Cart({this.quantity = 1, required this.product, this.includeInTotal = true});
}
