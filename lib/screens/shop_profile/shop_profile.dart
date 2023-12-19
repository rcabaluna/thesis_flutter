// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/notifiers/app_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:provider/provider.dart';

class ShopProfileScreen extends StatefulWidget {
  ShopProfileScreenState createState() => ShopProfileScreenState();
}

class ShopProfileScreenState extends State<ShopProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                getIt<NavigationService>()
                    .navigateTo(mainScreenRoute, arguments: {});
              },
              icon: Icon(Icons.arrow_back))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Consumer<AppNotifier>(
                builder: (_, appNotifier, __) {
                  final String imageUrl = appNotifier.myShop != null
                      ? appNotifier.myShop!.imageUrl
                      : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcU50X1UOeDaphmUyD6T8ROKs-HjeirpOoapiWbC9cLAqewFy1gthrgUTB9E7nKjRwOVk&usqp=CAU";
                  return Container(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.35,
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
                                  backgroundImage: NetworkImage(imageUrl),
                                ),
                                Positioned(
                                  right: 1,
                                  bottom: 0,
                                  child: Icon(
                                    Icons.add,
                                    size: 20.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${appNotifier.myShop?.shopName}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  // Text("${appNotifier.myShop.phoneNumber}",
                                  //     style: TextStyle(fontSize: 10)),
                                  Text(
                                    "${appNotifier.myShop?.address}",
                                    style: TextStyle(
                                        fontSize: 8,
                                        overflow: TextOverflow.ellipsis),
                                  )
                                ],
                              ),
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
              buildDirectory("My Products", () {
                getIt<NavigationService>()
                    .navigateTo(shopProductRoute, arguments: {});
              }),
              SizedBox(
                height: 10,
              ),
              buildDirectory("My Orders", () {
                getIt<NavigationService>()
                    .navigateTo(shopPendingOrderRoute, arguments: {});
              }),
              SizedBox(
                height: 10,
              ),
              buildDirectory("Shop Performance", () {}),
            ],
          ),
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
