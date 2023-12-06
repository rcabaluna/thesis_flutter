
import 'package:local_marketplace/models/product/product.dart'; // Import the necessary classes

class CartItem {
  Product product;
  int quantity;
  bool includeInTotal;

  CartItem({
    required this.product,
    required this.quantity,
    this.includeInTotal = true,
  });
}
