// ignore_for_file: depend_on_referenced_packages, file_names, non_constant_identifier_names, unused_import

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/category/category.dart';
import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/models/productbyseller/product_by_seller.dart';
import 'package:local_marketplace/notifiers/category/category_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/screens/product_detail_screen/product_detail_screen.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:local_marketplace/services/product/product.service.dart';
import 'package:provider/provider.dart';

class ProductsListScreen extends StatefulWidget {
  ProductsListScreenState createState() => ProductsListScreenState();
}

class ProductsListScreenState extends State<ProductsListScreen> {
  bool isLoading = false;
  bool searchPending = false;
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
          // First Row
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Text(
              "Home",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Color(0xFF2B2B2B)),
            ),
          ),

          // Second Row
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
          // Third Row
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0), // Add padding as needed
              child: Center(
                child: showLoader
                    ? const CircularProgressIndicator()
                    : productWidgets.isEmpty
                        ? NoProductFound()
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
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
          isSelected ? const Color(0xff00AE11) : Colors.grey,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevation: MaterialStateProperty.all<double>(isSelected ? 3.0 : 0.0),
        shadowColor: MaterialStateProperty.all<Color>(
          isSelected
              ? const Color(0xff00AE11)
              : const Color.fromARGB(0, 228, 228, 228),
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
    } else {
      productService.searchProductsbyCategory(searchInput).then((products) {
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
}

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
                  productseller.imageUrls.first,
                  height: 90, // Reduced image height
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                productseller.product.name,
                style: const TextStyle(
                  color: Color(0xFF2B2B2B),
                  fontWeight: FontWeight.bold,
                  fontSize: 14, // Slightly reduced font size
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),
              Text(
                '\₱${productseller.price.toStringAsFixed(2)}/${productseller.product.unit}',
                style: const TextStyle(
                  fontSize: 12, // Slightly reduced font size
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
