import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/services/product/product.service.dart';

class SearchScreen extends StatefulWidget {
  SearchScreenState createState() => SearchScreenState();
}



class SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  bool searchPending = false;
  Timer? _searchTimer;
  ProductService productService = ProductService();
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

              // Access the text input using _searchController.text
        String searchInput = _searchController.text;

        productService.searchProducts(searchInput).then((products) {

        // You can update the UI or perform other operations with the search results
        }).catchError((error) {
          setState(() {
            isLoading = false;
          });
          print('Error searching products: $error');
        });


      // Simulate a loading process (Replace this with your actual search logic)
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });


        // Perform search operations using the searchInput...
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * .17,
                  child: TextField(
                    controller: _searchController,
                    onChanged: performSearch,
                    decoration: InputDecoration(
                      hintText: "Search Product(s)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Other widgets related to search results can be added here
              ],
            ),
          ),
        ),
        // Loading screen widget
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
