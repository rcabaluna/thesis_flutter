import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/cart/cart.dart';
import 'package:local_marketplace/notifiers/cart/cart_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [],
      ),
      body: Consumer<CartNotifier>(
        builder: (context, cartNotifier, _) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartNotifier.cartLength,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(
                          cartNotifier.cartItems[index].product.id.toString()),
                      onDismissed: (direction) {
                        cartNotifier
                            .removeCartItem(cartNotifier.cartItems[index]);
                      },
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: buildCartItem(
                        cartNotifier.cartItems[index],
                        cartNotifier,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: Php ${cartNotifier.totalCartPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        getIt<NavigationService>()
                            .navigateTo(checkoutRoute, arguments: {});
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        child: Text(
                          "Checkout",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildCartItem(
    Cart cart,
    CartNotifier cartNotifier,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.store_outlined,
                size: 30,
              ),
              SizedBox(width: 8),
              Text(
                cart.product.seller.shopName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Card(
            elevation: 4,
            margin: EdgeInsets.all(0.0),
            child: Row(
              children: [
                Checkbox(
                  value: cart.includeInTotal,
                  onChanged: (value) {
                    setState(() {
                      cart.includeInTotal = value ?? false;
                      cartNotifier.updateTotalPrice();
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    cart.product.imageUrls.first,
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cart.product.product.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Php ${cart.product.product.price.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                if (cart.quantity > 1) {
                                  cartNotifier.updateCartItemQuantity(
                                    cart,
                                    cart.quantity - 1,
                                  );
                                  cartNotifier.updateTotalPrice();
                                }
                              },
                            ),
                            Text(
                              cart.quantity.toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                cartNotifier.updateCartItemQuantity(
                                  cart,
                                  cart.quantity + 1,
                                );
                                cartNotifier.updateTotalPrice();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
