import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/category/category.dart';
import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/models/productbyseller/product_by_seller.dart';
import 'package:local_marketplace/notifiers/category/category_notifier.dart';
import 'package:local_marketplace/notifiers/product/product_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/screens/product_detail_screen/product_detail_screen.dart';
import 'package:local_marketplace/screens/search_screen/search_screen.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:local_marketplace/services/product/product.service.dart';
import 'package:provider/provider.dart';

class ProductsListScreen extends StatefulWidget {
  ProductsListScreenState createState() => ProductsListScreenState();
}

class ProductsListScreenState extends State<ProductsListScreen> {
  
  TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  bool searchPending = false;
  Timer? _searchTimer;
  ProductService productService = ProductService();
  List<ProductWidget> productWidgets = [];
  bool isSearching = false;
  bool showLoader = false;
  String selectedCategoryId = "0";


  @override
  void initState() {
    super.initState();
    performSearch(selectedCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Explore",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Consumer<CategoryNotifier>(
            builder: (_, data, __) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: buildCategoryList(
                    [Category(name: "All", id: "0"), ...data.categories]),
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0), // Add padding as needed
              child: Center(
                child:
                  showLoader
                    ? CircularProgressIndicator()
                    : productWidgets.isEmpty
                    ? NoProductFound()
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 columns
                          crossAxisSpacing: 3.0,
                          mainAxisSpacing: 3.0,
                        ),
                        itemCount: productWidgets.length,
                        itemBuilder: (_, index) => productWidgets[index],
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryList(List<Category> categories) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemBuilder: (_, index) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: buildCategoryButton(
                categories[index].name,
                categories[index].id,
                categories[index].id == selectedCategoryId,
              ),
            )
          ],
        );
      },
    );
  }

  Widget buildCategoryButton(String name, String categoryId, bool isSelected) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategoryId = categoryId;
          performSearch(categoryId);
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isSelected ? Color(0xff00AE11) : Colors.grey,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevation: MaterialStateProperty.all<double>(isSelected ? 5.0 : 0.0),
        shadowColor: MaterialStateProperty.all<Color>(
          isSelected ? Color(0xff00AE11) : const Color.fromARGB(0, 228, 228, 228),
        ),
      ),
      child: Text(
        name,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white,
        ),
      ),
    );
  }


  Widget NoProductFound() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          'No Product(s) Found',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void performSearch(String query) {
    setState(() {
      isSearching = true;
      showLoader = true;
    });
    String searchInput = query;

    if (searchInput == "0") {
      productService.getProducts().then((products) {
      setState(() {
        isSearching = false;
        showLoader = false;  
        if (products.isEmpty) {
          productWidgets.clear();
        } else {
          productWidgets = products.map((product) => ProductWidget(product)).toList();
        }
      });
    }).catchError((error) {
      setState(() {
          isSearching = false;
          showLoader = false;
        });
      print('Error searching products: $error');
    });
    }else{
      productService.searchProductsbyCategory(searchInput).then((products) {
        setState(() {
          isSearching = false;
          showLoader = false;  
          if (products.isEmpty) {
            productWidgets.clear();
          } else {
            productWidgets = products.map((product) => ProductWidget(product)).toList();
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
}


class ProductWidget extends StatelessWidget {
  final Product product;

  ProductWidget(this.product);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
    
        getIt<NavigationService>().navigateTo(productDetailRoute, arguments: {});
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          height: 240,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(11.0)),
                child: Image.network(
                  product.imageUrl,
                  height: 130, // Reduced image height
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


