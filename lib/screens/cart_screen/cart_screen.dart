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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios
          ,color: Colors.white,), onPressed: () { Navigator.pop(context); },
        ),
        title: const Text(
          "My Cart",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.green, // Green app bar color
      ),
      body: Consumer<CartNotifier>(
        builder: (context, cartNotifier, _) {
          if (cartNotifier.cartLength == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Your cart is empty."),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      getIt<NavigationService>()
                              .navigateTo(mainScreenRoute, arguments: {});
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.green),
                      ),
                    ),
                    child: const Text("Shop Now"),
                  ),
                ],
              ),
            );
          } else {
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
                          child: const Icon(
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
                        'Total: ₱${cartNotifier.totalCartPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
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
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
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
          }
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
            SizedBox(width: 8),
            Text(
              'Shop Name: ' + cart.product.seller.shopName,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          child: SizedBox(
            height: 120, // Adjusting the height of the Card
            child: Card(
              elevation: 2,
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
                      height: 100,
                      width: 100,
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
                            "₱${cart.product.product.price.toStringAsFixed(2)}",
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
          ),
        ),
      ],
    ),
  );
}

}
