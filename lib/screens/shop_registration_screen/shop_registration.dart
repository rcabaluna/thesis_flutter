// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_marketplace/notifiers/app_notifier.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:local_marketplace/services/shop/shop_service.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../widget/input_field/input_field.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class ShopRegistrationScreen extends StatefulWidget {
  ShopRegistrationScreenState createState() => ShopRegistrationScreenState();
}

class ShopRegistrationScreenState extends State<ShopRegistrationScreen> {
  final TextEditingController shopName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();

  String? dropDownProvinceValue;
  String? dropDownMunCityValue;
  String? dropDownBarangayValue;
  File? imagefile;
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
    getIt<AppNotifier>().getProvince();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Shop Registration"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Shop Logo"),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 223, 223, 223),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: imagefile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            imagefile!,
                            width: 100,
                            height: 100,
                          ),
                        )
                      : IconButton(
                          onPressed: _pickImage,
                          icon: Icon(Icons.add),
                          color: Colors.black,
                          iconSize: 50,
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Shop Name"),
              BuildInputField(
                controller: shopName,
                obscureText: false,
                maxLines: 1,
                hintText: "Shop Name",
              ),
              SizedBox(
                height: 10,
              ),
              Text("Email"),
              BuildInputField(
                controller: email,
                obscureText: false,
                hintText: "Email",
                maxLines: 1,
              ),
              SizedBox(
                height: 10,
              ),
              Text("Phone Number"),
              BuildInputField(
                hintText: "Phone Number",
                controller: phoneNumber,
                obscureText: false,
                maxLines: 1,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Address",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Province"),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Consumer<AppNotifier>(
                            builder: (_, appNotifier, __) {
                              return DropdownButton<String>(
                                  value: dropDownProvinceValue,
                                  isExpanded: true,
                                  underline: Container(),
                                  items: appNotifier.province
                                      .map((data) => DropdownMenuItem(
                                            child: Text(data.name),
                                            value: data.code,
                                          ))
                                      .toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropDownProvinceValue = value;
                                    });
                                    // call another api
                                    appNotifier.getMunCityByProvince(value!);
                                    print(appNotifier);
                                  });
                            },
                          ))
                        ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("City/Municipality"),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Consumer<AppNotifier>(
                                builder: (_, appNotifier, __) {
                                  return DropdownButton<String>(
                                      value: dropDownMunCityValue,
                                      isExpanded: true,
                                      underline: Container(),
                                      items: appNotifier.munCity
                                          .map((data) => DropdownMenuItem(
                                                child: Text(data.name),
                                                value: data.code,
                                              ))
                                          .toList(),
                                      onChanged: (
                                        String? value,
                                      ) {
                                        setState(() {
                                          dropDownMunCityValue = value;
                                        });
                                        //call another api
                                        appNotifier
                                            .getBarangayByCityOrMunicipality(
                                                value!);
                                        print(appNotifier);
                                      });
                                },
                              ))
                            ]),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Barangay"),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Consumer<AppNotifier>(
                                builder: (_, appNotifier, __) {
                                  return DropdownButton<String>(
                                      value: dropDownBarangayValue,
                                      isExpanded: true,
                                      underline: Container(),
                                      items: appNotifier.barangay
                                          .map((data) => DropdownMenuItem(
                                                child: Text(data.name),
                                                value: data.code,
                                              ))
                                          .toList(),
                                      onChanged: (
                                        String? value,
                                      ) {
                                        setState(() {
                                          dropDownBarangayValue = value;
                                        });
                                        //call another api
                                      });
                                },
                              ))
                            ]),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
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
                    final ShopService shopService = ShopService();
                    context.loaderOverlay.show();
                    final barangay = getIt<AppNotifier>()
                        .barangay
                        .where(
                            (element) => element.code == dropDownBarangayValue)
                        .first
                        .name;
                    final munCity = getIt<AppNotifier>()
                        .munCity
                        .where(
                            (element) => element.code == dropDownMunCityValue)
                        .first
                        .name;
                    final province = getIt<AppNotifier>()
                        .province
                        .where(
                            (element) => element.code == dropDownProvinceValue)
                        .first
                        .name;

                    final data = {
                      "shopName": shopName.text,
                      "email": email.text,
                      "phoneNumber": phoneNumber.text,
                      "address": "$barangay $munCity $province"
                    };

                    try {
                      await shopService.saveSeller(croppedFile, data);
                      await getIt<AppNotifier>().getMyShop();
                      if (context.mounted) {
                        context.loaderOverlay.hide();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(
                                "Successfully saved seller details")));
                        getIt<NavigationService>()
                            .navigateTo(mainScreenRoute, arguments: {});
                      }
                    } catch (e) {
                      if (context.mounted) {
                        context.loaderOverlay.hide();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: const Text("Error Saving")));
                      }
                    }
                    // getIt<NavigationService>()
                    //     .navigateTo(registrationFeeRoute, arguments: {});
                  },
                  child: Text(
                    'Register Shop',
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
}
