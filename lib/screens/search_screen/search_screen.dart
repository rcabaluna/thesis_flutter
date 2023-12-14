import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/services/product/product.service.dart';

class ProductWidget extends StatelessWidget {
  final Product product;

  ProductWidget(this.product);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          height: 250, // Adjusted height to prevent overflow
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(6.0)),
                child: Image.network(
                  product.imageUrl,
                  height: 120, // Reduced image height
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Slightly reduced font size
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),
              Text(
                '\₱${product.price.toStringAsFixed(2)}/${product.unit}',
                style: TextStyle(
                  fontSize: 14, // Slightly reduced font size
                  color: Color(0xff00AE11),
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

  void performSearch(String query) {
    setState(() {
      searchPending = true;
      
    });


    if (_searchTimer != null && _searchTimer!.isActive) {
      _searchTimer!.cancel();
    }

    _searchTimer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        searchPending = false;
        isLoading = true;
      });

      String searchInput = _searchController.text;
      productService.searchProducts(searchInput).then((products) {
        setState(() {
          isLoading = false;
          productWidgets = products.map((product) => ProductWidget(product)).toList();
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        print('Error searching products: $error');
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });
      });
    });
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
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * .17,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[200], // Background color for text field
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15), // Adjust padding
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
                  ? Container() // Show an empty container if no products
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


