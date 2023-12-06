import 'package:flutter/material.dart';
import 'package:local_marketplace/models/cart/cart.dart';
import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/models/productbyseller/product_by_seller.dart';

class CartNotifier extends ChangeNotifier {
  List<Cart> _cartItems = [];
  List<Cart> get cartItems => _cartItems;

  set cartItems(List<Cart> cartItems) {
    _cartItems = cartItems;
    notifyListeners();
  }

  int get cartLength => _cartItems.length;

  double get totalCartPrice {
    double totalPrice = 0.0;
    for (Cart cart in _cartItems) {
      if (cart.includeInTotal) {
        totalPrice += (cart.product.product.price * cart.quantity);
      }
    }
    return totalPrice;
  }

  addItemsToCart(ProductBySeller product) {
    Cart? existingCartItem;
    try {
      existingCartItem =
          _cartItems.firstWhere((cart) => cart.product.id == product.id);
    } catch (_) {
      existingCartItem = null;
    }

    if (existingCartItem != null) {
      // If the product is already in the cart, increment the quantity
      existingCartItem.quantity += 1;
    } else {
      // If the product is not in the cart, add a new cart item
      _cartItems.add(Cart(product: product, quantity: 1));
    }

    // Notify listeners and update the total price
    notifyListeners();
    updateTotalPrice();
  }

  updateCartItemQuantity(Cart cart, int newQuantity) {
    cart.quantity = newQuantity;
    notifyListeners();
  }

  updateTotalPrice() {
    notifyListeners();
  }

  removeCartItem(Cart cart) {
    _cartItems.remove(cart);
    notifyListeners();
  }
}
