
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/seller/seller.dart';
import 'package:local_marketplace/notifiers/app_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/screens/shop_welcome_screen/shop_welcome_screen.dart';
import 'package:local_marketplace/services/app_state/app_state_service.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
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
      croppedFile = await ImageCropper().cropImage(
        sourcePath: pickImageFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      );
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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getIt<AppStateService>().checkLoggedInAndRedirect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          _buildProfileHeader(),
          SizedBox(height: 30),
          _buildDirectory("My Orders", myOrderRoute),
          _buildDirectory("Order History", orderHistoryRoute),
          _buildDirectory("My Ratings", myRatingRoute),
          _buildDirectory(
              "My Shop",
              getIt<AppNotifier>().myShop != null
                  ? registrationFeeRoute
                  : shopProfileRoute),
          _buildDirectory("Edit Profile", editProfileRoute),
          _buildDirectory("Logout", logoutRoute),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Consumer<AppNotifier>(
      builder: (_, notifier, __) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.35,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 174, 17, 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(partialProfile),
                    ),
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
                const SizedBox(width: 15),
                Text("${notifier.currentUser.fullName}"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDirectory(String text, String route) {
    return GestureDetector(
      onTap: () {
        getIt<NavigationService>().navigateTo(route, arguments: {});
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
            Icon(Icons.keyboard_arrow_right),
          ],
        ),
      ),
    );
  }
}
