// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/seller/seller.dart';
import 'package:local_marketplace/notifiers/app_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/screens/shop_welcome_screen/shop_welcome_screen.dart';
import 'package:local_marketplace/services/app_state/app_state_service.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late File imagefile;
  CroppedFile? croppedFile;
  Future _pickImage() async {
    final pickImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    File? pickImageFile = pickImage != null ? File(pickImage.path) : null;

    if (pickImageFile != null) {
      croppedFile = await ImageCropper()
          .cropImage(sourcePath: pickImageFile.path, aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ]);
      if (croppedFile != null) {
        setState(() {
          imagefile = File(croppedFile!.path);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<AppStateService>().checkLoggedInAndRedirect();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Consumer<AppNotifier>(
              builder: (_, notifier, __) {
                return Container(
                  child: Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set the width of the box based on screen width
                    height: MediaQuery.of(context).size.width *
                        0.35, // Set the height of the box based on screen width

                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 174, 17, 1),
                      border: Border.all(width: 0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      NetworkImage(partialProfile)),
                              Positioned(
                                right: -10,
                                bottom: -15,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    size: 25.0,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    _pickImage();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("${notifier.currentUser.fullName}"),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 30,
            ),
            buildDirectory("My Orders", () {
              getIt<NavigationService>()
                  .navigateTo(myOrderRoute, arguments: {});
            }),
            SizedBox(
              height: 10,
            ),
            buildDirectory("Order History", () {
              getIt<NavigationService>()
                  .navigateTo(orderHistoryRoute, arguments: {});
            }),
            SizedBox(
              height: 10,
            ),
            buildDirectory("My Ratings", () {
              getIt<NavigationService>()
                  .navigateTo(myRatingRoute, arguments: {});
            }),
            SizedBox(
              height: 10,
            ),
            buildDirectory("My Shop", () {
              Seller? seller = getIt<AppNotifier>().myShop;
              if (seller != null) {
                getIt<NavigationService>()
                    .navigateTo(shopProfileRoute, arguments: {});
              } else {
                getIt<NavigationService>()
                    .navigateTo(shopWelcomeRoute, arguments: {});
              }
            }),
            SizedBox(
              height: 10,
            ),
            buildDirectory("Edit Profile", () {
              getIt<NavigationService>()
                  .navigateTo(editProfileRoute, arguments: {});
            }),
          ],
        ),
      ),
    );
  }

  Widget buildDirectory(String text, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context)
            .size
            .width, // Set the width of the box based on screen width
        height: MediaQuery.of(context).size.width *
            0.15, // Set the height of the box based on screen width
        decoration: BoxDecoration(
          border: Border.all(width: 0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
            Icon(Icons.keyboard_arrow_right)
          ],
        ),
      ),
    );
  }
}
