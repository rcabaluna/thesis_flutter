// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:local_marketplace/models/productbyseller/product_by_seller.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:local_marketplace/services/shop/shop_service.dart';
import 'package:provider/provider.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/notifiers/product/product_notifier.dart';
import 'package:local_marketplace/widget/input_field/input_field.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productName = TextEditingController();
  final TextEditingController productDescription = TextEditingController();
  final TextEditingController productPrice = TextEditingController();
  final TextEditingController productStocks = TextEditingController();
  final TextEditingController productTags = TextEditingController();
  List<String> _tag = [];
  Product? selectedProduct;

  List<File> imageFiles = [];
  List<CroppedFile> croppedFiles = [];
  String getSuggestivePrice(Product selectedProduct) {
    if (selectedProduct != null) {
      double suggestivePrice = selectedProduct!.price * 1;
      return suggestivePrice.toStringAsFixed(2);
    }
    return "";
  }

  Future _pickImage() async {
    if (imageFiles.length >= 5) {
      return;
    }
    final pickImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    File? pickImageFile = pickImage != null ? File(pickImage.path) : null;

    if (pickImageFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickImageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      );

      if (croppedFile != null) {
        setState(() {
          imageFiles.add(File(croppedFile.path));
          croppedFiles.add(croppedFile);
        });
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      imageFiles.removeAt(index);
      croppedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        leading: IconButton(
            onPressed: () {
              getIt<NavigationService>()
                  .navigateTo(shopProductRoute, arguments: {});
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageFiles.length + 1,
                  itemBuilder: (context, index) {
                    if (index == imageFiles.length) {
                      // Add more images button
                      return GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 223, 223, 223),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.add, size: 50, color: Colors.black),
                        ),
                      );
                    } else {
                      // Display selected images
                      return Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 223, 223, 223),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                imageFiles[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 10,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: EdgeInsets.all(4),
                                color: Colors.red,
                                child: Icon(Icons.close,
                                    color: Colors.white, size: 14),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Note that you can only add up to 5 pictures",
                style: TextStyle(fontSize: 8),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Product Price"),
              BuildInputField(
                controller: productPrice,
                hintText: "Set Price",
                obscureText: false,
                maxLines: 1,
              ),
              if (selectedProduct != null)
                Text(
                  "Suggestive Price: ${getSuggestivePrice(selectedProduct!)}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.green),
                ),
              SizedBox(
                height: 5,
              ),
              Text("Quantity"),
              BuildInputField(
                obscureText: false,
                maxLines: 1,
                controller: productStocks,
                hintText: "Enter Quantity",
              ),
              SizedBox(
                height: 10,
              ),
              Text("Product Tags(Separate by comma)"),
              BuildInputField(
                maxLines: 1,
                obscureText: false,
                controller: productTags,
                onEditingComplete: () {
                  addTag(productTags.text);
                  productTags.clear();
                },
                hintText: "Enter Tags",
              ),
              SizedBox(
                height: 10,
              ),
              Text("Products"),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: DropdownButton<Product>(
                  value: selectedProduct,
                  onChanged: (Product? newValue) {
                    setState(() {
                      selectedProduct = newValue!;
                    });
                  },
                  items: buildDropdownItems(),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.15,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () async {
                    context.loaderOverlay.show();
                    final ShopService shopService = ShopService();
                    List<String> tags = productTags.text.split(",");
                    var formData = FormData.fromMap({
                      "productId": selectedProduct!.id,
                      "quantity": productStocks.text,
                      "tags": tags,
                      "price": productPrice.text
                    });

                    for (var croppedFile in croppedFiles) {
                      String fileName = basename(croppedFile.path);
                      List<int> bytes = await croppedFile.readAsBytes();
                      formData.files.addAll([
                        MapEntry("image",
                            MultipartFile.fromBytes(bytes, filename: fileName))
                      ]);
                    }

                    try {
                      await shopService.addProducts(formData);
                      if (context.mounted) {
                        context.loaderOverlay.hide();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                const Text("Successfully added products")));
                        getIt<NavigationService>()
                            .navigateTo(shopProductRoute, arguments: {});
                      }
                    } catch (e) {
                      if (context.mounted) {
                        context.loaderOverlay.hide();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: const Text("Error Saving")));
                      }
                    }
                  },
                  child: Text(
                    'Create Product',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTag(String tag) {
    if (tag.isNotEmpty && !_tag.contains(tag)) {
      setState(() {
        _tag.add(tag);
      });
    }
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8.0,
      children: _tag.map((tag) {
        return Chip(
          label: Text(tag),
          onDeleted: () {
            _removeTag(tag);
          },
        );
      }).toList(),
    );
  }

  void _removeTag(String tag) {
    setState(() {
      _tag.remove(tag);
    });
  }

  List<DropdownMenuItem<Product>> buildDropdownItems() {
    final List<Product> products = getIt<ProductNotifier>().products;
    List<DropdownMenuItem<Product>> items = [];

    for (var product in products) {
      items.add(DropdownMenuItem<Product>(
        value: product,
        child: Text(product.name),
      ));
    }
    print(items.length);
    return items;
  }
}
