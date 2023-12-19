// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/productbyseller/product_by_seller.dart';
import 'package:local_marketplace/notifiers/cart/cart_notifier.dart';
import 'package:local_marketplace/notifiers/product/product_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:local_marketplace/services/product/product.service.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  ProductDetailsScreen(this.productId);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductBySeller? productDetails;

  @override
  void initState() {
    super.initState();
    fetchProductDetails(widget.productId);
  }

  void fetchProductDetails(String productId) {
    ProductService productService = ProductService();

    productService
        .getProductDetails(productId)
        .then((List<ProductBySeller> productList) {
      if (productList.isNotEmpty) {
        setState(() {
          productDetails = productList.first;
        });
      } else {
        print("No product details found for the given ID.");
      }
    }).catchError((error) {
      print("Error fetching product details: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Product Details",
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.green, // Green app bar color
        elevation: 2, // Adding elevation for a subtle shadow

        actions: [
          Consumer<CartNotifier>(
            builder: (_, cartNotifier, __) {
              return GestureDetector(
                onTap: () {
                  getIt<NavigationService>()
                      .navigateTo(cartRoute, arguments: {});
                },
                child: cartNotifier.cartLength > 0
                    ? badges.Badge(
                        position: badges.BadgePosition.topEnd(top: -8, end: -5),
                        badgeContent: Text(
                          "${cartNotifier.cartLength}",
                          style: TextStyle(
                              fontSize: 8), // Adjust the font size here
                        ),
                        child: const Icon(Icons.shopping_cart),
                      )
                    : const Icon(Icons.shopping_cart),
              );
            },
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: productDetails != null
          ? ProductDetailsWidget(productDetails!)
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class ProductDetailsWidget extends StatelessWidget {
  final ProductBySeller productDetails;

  ProductDetailsWidget(this.productDetails);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                height: 250.0,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
              ),
              items: productDetails.imageUrls.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Text(
              productDetails.product.name,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Price: \₱${productDetails.product.price.toStringAsFixed(2)}/${productDetails.product.unit}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(
                  Icons.store,
                  size: 16.0,
                  color: Colors.grey,
                ),
                SizedBox(width: 5.0),
                Text(
                  productDetails.seller.shopName,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16.0,
                  color: Colors.grey,
                ),
                SizedBox(width: 5.0),
                Text(
                  productDetails.seller.address,
                  style: TextStyle(
                    fontSize: 11.0,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final product = getIt<ProductNotifier>().productBySeller;
                      getIt<CartNotifier>().addItemsToCart(productDetails);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('"${productDetails.product.name}"' +
                              ' has been added to cart.'),
                          duration:
                              Duration(seconds: 2), // Adjust duration as needed
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      getIt<CartNotifier>().addItemsToCart(productDetails);
                      getIt<NavigationService>()
                          .navigateTo(cartRoute, arguments: {});
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text(
                      'Buy Now',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
