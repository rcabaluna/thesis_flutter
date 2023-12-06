// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
        title: const Text(
          "Product",
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
                        // Remove the item from the cart
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      'Total: Php ${cartNotifier.totalCartPrice.toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        getIt<NavigationService>()
                            .navigateTo(checkoutRoute, arguments: {});
                      },
                      child: Container(
                        color: Colors.green,
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Check Out  ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
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
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.store_outlined,
                size: 30,
              ),
              Text(cart.product.seller.shopName),
            ],
          ),
          Card(
            margin: EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Checkbox(
                    value: cart.includeInTotal,
                    onChanged: (value) {
                      setState(() {
                        cart.includeInTotal = value ?? false;
                        cartNotifier.updateTotalPrice();
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Image.network(
                    cart.product.imageUrls.first,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  flex: 2,
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
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      // Replace the counter with a TextField
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                              text: cart.quantity.toString()),
                          onChanged: (value) {
                            // Validate input and update quantity
                            int newQuantity = int.tryParse(value) ?? 0;
                            print(newQuantity);
                            cartNotifier.updateCartItemQuantity(
                                cart, newQuantity);
                            cartNotifier.updateTotalPrice();
                          },
                        ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
