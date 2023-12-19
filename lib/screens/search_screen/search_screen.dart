import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/models/productbyseller/product_by_seller.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/screens/product_detail_screen/product_detail_screen.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:local_marketplace/services/product/product.service.dart';

class ProductWidget extends StatelessWidget {
  final ProductBySeller productseller;

  ProductWidget(this.productseller);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailsScreen(productseller.product.id),
          ),
        );
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white, // Set the background color to white
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(11.0)),
                child: Image.network(
                  productseller.product.imageUrl,
                  height: 80, // Reduced image height
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 10),
              Text(
                productseller.product.name,
                style: const TextStyle(
                  color: Color(0xFF2B2B2B),
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Slightly reduced font size
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),
              Text(
                '\₱${productseller.price.toStringAsFixed(2)}/${productseller.product.unit}',
                style: const TextStyle(
                  fontSize: 14, // Slightly reduced font size
                  color: Color(0xFF2ECC40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  bool searchPending = false;
  Timer? _searchTimer;
  ProductService productService = ProductService();
  List<ProductWidget> productWidgets = [];
  bool isSearching = false;
  bool showLoader = false;

  void performSearch(String query) {
    setState(() {
      isSearching = true;
      showLoader = true;
    });
    String searchInput = query;

    if (searchInput == '') {
      productWidgets = [];
    } else {
      productService.searchProducts(searchInput).then((products) {
        setState(() {
          isSearching = false;
          showLoader = false;
          if (products.isEmpty) {
            productWidgets.clear();
          } else {
            productWidgets =
                products.map((product) => ProductWidget(product)).toList();
          }
        });
      }).catchError((error) {
        setState(() {
          isSearching = false;
          showLoader = false;
        });
        print('Error searching products: $error');
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * .17,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color:
                          Colors.grey[200], // Background color for text field
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    // Adjust padding
                    child: Center(
                      child: TextField(
                        controller: _searchController,
                        onChanged: performSearch,
                        decoration: InputDecoration(
                          hintText: "Search Product(s)",
                          border: InputBorder.none, // Remove default border
                          icon: Icon(Icons.search), // Optional search icon
                        ),
                        style: TextStyle(fontSize: 16), // Adjust font size
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Margin below the text field
                // Display product widgets in a 2x2 grid
                productWidgets.isEmpty
                    ? Container(
                        child: Center(
                          child: Text('No product(s) found'),
                        ),
                      ) // Show an empty container if no products
                    : GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        children: productWidgets.map((productWidget) {
                          return Center(child: productWidget);
                        }).toList(),
                      ),
              ],
            ),
          ),
        ),
        if (isLoading || searchPending)
          Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
