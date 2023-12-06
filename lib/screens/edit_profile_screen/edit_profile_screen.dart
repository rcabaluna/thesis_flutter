// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/user/user.dart';
import 'package:local_marketplace/notifiers/app_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:local_marketplace/widget/input_field/input_field.dart';
import 'package:local_marketplace/services/user/user.service.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController fullname = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  String? dropDownProvinceValue;
  String? dropDownMunCityValue;
  String? dropDownBarangayValue;

  @override
  void initState() {
    super.initState();
    getIt<AppNotifier>().getProvince();
    getIt<AppNotifier>().fetchUserDetails().then((_) {
      fullname.text = getIt<AppNotifier>().currentUser.fullName ?? "";
      phoneNumber.text = getIt<AppNotifier>().currentUser.phoneNumber ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Full Name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              BuildInputField(
                obscureText: false,
                controller: fullname,
                hintText: "Full Name",
                icon: Icon(Icons.person_2),
                maxLines: 1,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Phone Number",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              BuildInputField(
                obscureText: false,
                maxLines: 1,
                controller: phoneNumber,
                hintText: "Phone Number",
                icon: Icon(Icons.phone),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Address",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              buildAddressContainer(),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * .9,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              print(getIt<AppNotifier>().province.length);
                              final String province = getIt<AppNotifier>()
                                  .province
                                  .firstWhere((element) =>
                                      element.code == dropDownProvinceValue)
                                  .name;
                              print(province);

                              final String munCity = getIt<AppNotifier>()
                                  .munCity
                                  .firstWhere((element) =>
                                      element.code == dropDownMunCityValue)
                                  .name;
                              print(munCity);

                              final String barangay = getIt<AppNotifier>()
                                  .barangay
                                  .firstWhere((element) =>
                                      element.code == dropDownBarangayValue)
                                  .name;
                              print(barangay);

                              final UserService _userService = UserService();
                              context.loaderOverlay.show();
                              Map<String, dynamic> data = {
                                "fullName": fullname.text,
                                "phoneNumber": phoneNumber.text,
                                "address":
                                    province + " " + munCity + " " + barangay,
                              };
                              await _userService.editProfile(data);
                              getIt<AppNotifier>().currentUser = User(
                                address: data["address"],
                                fullName: data["fullName"],
                                phoneNumber: data["phoneNumber"],
                              );
                              context.loaderOverlay.hide();
                              getIt<NavigationService>()
                                  .navigateTo(mainScreenRoute, arguments: {});
                            } catch (e) {
                              print(e);
                              context.loaderOverlay.hide();
                              //show error message
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: TextStyle(color: Colors.white),
                          ),
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddressContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Province"),
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                    onChanged: (String? value) async {
                      setState(() {
                        dropDownProvinceValue = value;
                      });
                      // call another api
                      context.loaderOverlay.show();
                      await appNotifier.getMunCityByProvince(value!);
                      context.loaderOverlay.hide();
                      print(dropDownProvinceValue);
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
                                  .getBarangayByCityOrMunicipality(value!);
                              print(appNotifier);
                            });
                      },
                    ))
                  ]),
            ),
          ],
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
                            });
                      },
                    ))
                  ]),
            ),
          ],
        )
      ],
    );
  }
}
