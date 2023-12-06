// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_marketplace/widget/input_field/input_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class RateOrderScreen extends StatefulWidget {
  RateOrderScreenState createState() => RateOrderScreenState();
}

class RateOrderScreenState extends State<RateOrderScreen> {
  late double _productRating;
  late double _shopRating;
  TextEditingController statement = TextEditingController();
  @override
  void initState() {
    super.initState();
    _productRating = 0;
    _shopRating = 0;
  }

  void _handleProductTap(double selectedRating) {
    setState(() {
      _productRating = selectedRating;
    });
    print('Selected Rating: $_productRating');
  }

  void _handleShopTap(double selectedRating) {
    setState(() {
      _shopRating = selectedRating;
    });
    print('Selected Rating: $_shopRating');
  }

  List<File> imageFiles = [];
  List<CroppedFile?> croppedFiles = [];

  Future _pickImage() async {
    if (imageFiles.length >= 3) {
      return;
    }
    final pickImage = await ImagePicker().pickImage(source: ImageSource.camera);

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
        title: Text("Rate Order"),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Submit",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              buildOrderContainer(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Product Rating:",
                    style: TextStyle(fontSize: 12),
                  ),
                  buildProductStarRating()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Shop Rating:",
                    style: TextStyle(fontSize: 12),
                  ),
                  buildShopStarRating()
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Add a statement or attach a photo to for sellers improvements",
                style: TextStyle(fontSize: 10),
              ),
              BuildInputField(
                controller: statement,
                hintText: "Enter here.......",
                obscureText: false,
                maxLines: 2,
              ),
              GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Add Photo",
                      style:
                          TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.photo_camera)
                  ],
                ),
              ),
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageFiles.length + 1,
                  itemBuilder: (context, index) {
                    if (index == imageFiles.length) {
                      // Add more images button
                      return SizedBox.shrink();
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderContainer() {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://www.organics.ph/cdn/shop/products/chili-labuyo-100grams-fruits-vegetables-fresh-produce-126835_800x.jpg?v=1601484492"),
                fit: BoxFit.cover),
          ),
        ),
        Text("Product Name")
      ],
    );
  }

  Widget buildProductStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        double rating = index + 1.0;
        return GestureDetector(
          onTap: () => _handleProductTap(rating),
          child: Icon(
            index < _productRating.floor()
                ? Icons.star
                : index < _productRating
                    ? Icons.star_half
                    : Icons.star_border,
            size: 30.0,
            color: _productRating >= rating ? Colors.amber : Colors.grey,
          ),
        );
      }),
    );
  }

  Widget buildShopStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        double rating = index + 1.0;
        return GestureDetector(
          onTap: () => _handleShopTap(rating),
          child: Icon(
            index < _shopRating.floor()
                ? Icons.star
                : index < _shopRating
                    ? Icons.star_half
                    : Icons.star_border,
            size: 30.0,
            color: _shopRating >= rating ? Colors.amber : Colors.grey,
          ),
        );
      }),
    );
  }
}
