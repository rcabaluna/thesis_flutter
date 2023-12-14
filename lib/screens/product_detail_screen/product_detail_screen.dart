import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/seller/seller.dart';
import 'package:local_marketplace/notifiers/cart/cart_notifier.dart';
import 'package:local_marketplace/notifiers/product/product_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          Consumer<CartNotifier>(builder: (_, cartNotifier, __) {
            return GestureDetector(
              onTap: () {
                getIt<NavigationService>().navigateTo(cartRoute, arguments: {});
              },
              child: cartNotifier.cartLength > 0
                  ? badges.Badge(
                      position: badges.BadgePosition.topEnd(top: -12, end: -10),
                      badgeContent: Text("${cartNotifier.cartLength}"),
                      child: const Icon(Icons.shopping_cart))
                  : const Icon(Icons.shopping_cart),
            );
          }),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Consumer<ProductNotifier>(
                builder: (_, snapShot, __) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 17, right: 17),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapShot.productBySeller!.product.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Text(
                                "Php ${snapShot.productBySeller!.price.toStringAsFixed(2)}/${snapShot.productBySeller!.product.unit}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: buildSellerContainer(Seller(
                              shopName:
                                  snapShot.productBySeller!.seller.shopName,
                              imageUrl:
                                  snapShot.productBySeller!.seller.imageUrl,
                              address:
                                  snapShot.productBySeller!.seller.address)),
                        )
                      ],
                    ),
                  );
                },
              )),
          // Positioned(
          //   bottom: 0,
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     decoration: BoxDecoration(
          //         border: Border(
          //             top: BorderSide(
          //                 width: 1,
          //                 color: const Color(0xff929292).withOpacity(0.5)))),
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: GestureDetector(
          //             onTap: () {
          //               final product =
          //                   getIt<ProductNotifier>().productBySeller!;
          //               getIt<CartNotifier>().addItemsToCart(product);
          //             },
          //             child: const Padding(
          //               padding: EdgeInsets.only(left: 13, right: 13),
          //               child: Column(
          //                 children: [
          //                   Icon(
          //                     Icons.shopping_cart_outlined,
          //                     size: 16,
          //                   ),
          //                   Text(
          //                     "Add to Cart",
          //                     style: TextStyle(fontSize: 10),
          //                   )
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //         Expanded(
          //           flex: 3,
          //           child: GestureDetector(
          //             onTap: () {},
          //             child: Container(
          //               color: Colors.green,
          //               padding: const EdgeInsets.only(top: 15, bottom: 15),
          //               child: const Center(
          //                 child: Text(
          //                   "Buy Now",
          //                   style: TextStyle(
          //                       color: Colors.white,
          //                       fontWeight: FontWeight.w700),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget buildSellerContainer(Seller seller) {
    return Row(
      // children: [
      //   Container(
      //     height: 50,
      //     width: 50,
      //     decoration: BoxDecoration(
      //         image: DecorationImage(image: NetworkImage(seller.imageUrl)),
      //         borderRadius: BorderRadius.circular(25)),
      //   ),
      //   const SizedBox(
      //     width: 10,
      //   ),
      //   Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [Text(seller.shopName), const Text("Seller")],
      //   )
      // ],
    );
  }
}
