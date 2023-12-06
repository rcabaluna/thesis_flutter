// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ShopRegistrationFeeScreen extends StatefulWidget {
  ShopRegistrationFeeScreenState createState() =>
      ShopRegistrationFeeScreenState();
}

class ShopRegistrationFeeScreenState extends State<ShopRegistrationFeeScreen> {
  List<File> imageFiles = [];
  List<CroppedFile?> croppedFiles = [];

  Future _pickImage() async {
    if (imageFiles.length >= 2) {
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
        title: Text(
          "Registration Fee",
        ),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            payment,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "An annual registration fee grants year-long access to exclusive benefits and services.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
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
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.15,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  getIt<NavigationService>()
                      .navigateTo(registrationReviewRoute, arguments: {});
                },
                child: Text(
                  'Register Shop',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
