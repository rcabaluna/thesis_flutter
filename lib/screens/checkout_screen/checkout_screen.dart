// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/cart/cart.dart';
import 'package:local_marketplace/models/orders/orders_model.dart';
import 'package:local_marketplace/models/placeorder/placeorder_model.dart';
import 'package:local_marketplace/notifiers/cart/cart_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/cart/cart_service.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:local_marketplace/widget/input_field/input_field.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  bool isMeetUp = false;
  bool isDelivery = false;
  TextEditingController address = TextEditingController();
  TextEditingController notes = TextEditingController();
  var deliveryOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Checkout",
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.green, // Green app bar color
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0), // Adjust the value as needed
                  child: Text(
                    'Order Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<CartNotifier>(
                    builder: (_, notifier, __) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildProductList(notifier.cartItems),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Order Total:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "P ${notifier.totalCartPrice}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10), // Adjusted SizedBox height
                          DropdownButtonFormField<String>(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: InputDecoration(
                              labelText: 'Select Delivery Option',
                              border: OutlineInputBorder(),
                            ),
                            value: deliveryOption,
                            onChanged: (String? value) {
                              setState(() {
                                deliveryOption = value!;
                                if (deliveryOption == 'Meet-Up') {
                                  isMeetUp = true;
                                  isDelivery = false;
                                } else if (deliveryOption == 'Delivery') {
                                  isDelivery = true;
                                  isMeetUp = false;
                                }
                              });
                            },
                            items: ['Meet-Up', 'Delivery']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 10), // Adjusted SizedBox height
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: BuildInputField(
                              maxLines: 1,
                              controller: address,
                              obscureText: false,
                              hintText: "Enter Address",
                            ),
                          ),

                          SizedBox(height: 10), // Adjusted SizedBox height
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: BuildInputField(
                              maxLines: 2,
                              controller: notes,
                              obscureText: false,
                              hintText: "Enter Notes",
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 25), // Adjust the padding as needed
                        child: ElevatedButton(
                          onPressed: () async {
                            final CartService cartService = CartService();
                            List<Map<String, dynamic>> orders = [];
                            List<Cart> cartItems =
                                getIt<CartNotifier>().cartItems;
                            for (var cart in cartItems) {
                              orders.add({
                                "quantity": cart.quantity,
                                "productBySellerId": cart.product.id
                              });
                            }

                            PlaceOrder orderSummary = PlaceOrder(
                              deliveryType: deliveryOption,
                              address: address.text,
                              notes: notes.text,
                            );

                            // Convert PlaceOrder object to JSON
                            Map<String, dynamic> orderJson =
                                orderSummary.toJson();

                            try {
                              await cartService.order(orderSummary, orders);
                              if (context.mounted) {
                                context.loaderOverlay.hide();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Your order has been placed.",
                                    ),
                                  ),
                                );
                                getIt<NavigationService>()
                                    .navigateTo(mainScreenRoute, arguments: {});
                                getIt<CartNotifier>()
                                    .clearCart(); // Clear the cart here
                              }
                            } catch (e) {
                              if (context.mounted) {
                                context.loaderOverlay.hide();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Error ordering"),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            "Place Order",
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<Cart> cartitems) {
    return ListView.builder(
      itemCount: cartitems.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      cartitems[index].product.imageUrls.first,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartitems[index].product.product.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "P ${cartitems[index].product.price.toStringAsFixed(2)}",
                      ),
                      Text(" x ${cartitems[index].quantity}"),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
