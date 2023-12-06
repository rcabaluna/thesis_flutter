import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/cart/cart.dart';
import 'package:local_marketplace/notifiers/cart/cart_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/cart/cart_service.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
              hasScrollBody: true,
              child: Column(
                children: [
                  Expanded(
                    child: Consumer<CartNotifier>(
                      builder: (_, notifier, __) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 2,
                                child: _buildProductList(notifier.cartItems)),
                            // const SizedBox(
                            //   height: 30,
                            // ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Order Total:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    "P ${notifier.totalCartPrice}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
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
                              try {
                                await cartService.order(orders);
                                if (context.mounted) {
                                  context.loaderOverlay.hide();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Successfully added products")));
                                  getIt<NavigationService>().navigateTo(
                                      mainScreenRoute,
                                      arguments: {});
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  context.loaderOverlay.hide();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Error ordering")));
                                }
                              }
                            },
                            child: const Text("Place Order")),
                      )
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildProductList(List<Cart> cartitems) {
    return ListView.builder(
        itemCount: cartitems.length,
        itemBuilder: (context, index) {
          return Container(
            // margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          cartitems[index].product.imageUrls.first),
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
                            "P ${cartitems[index].product.price.toStringAsFixed(2)}"),
                        Text(" x ${cartitems[index].quantity}")
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}
