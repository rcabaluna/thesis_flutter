// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';

class ShopWelcomeScreen extends StatefulWidget {
  ShopWelcomeScreenState createState() => ShopWelcomeScreenState();
}

class ShopWelcomeScreenState extends State<ShopWelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            shop,
            height: 250,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Text(
              "Don't be afraid to follow your dreams and create the shop you've always imagined. Success often starts with taking that first step.",
              style: TextStyle(
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * .15,
              child: ElevatedButton(
                onPressed: () {
                  getIt<NavigationService>()
                      .navigateTo(shopRegistrationRoute, arguments: {});
                },
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Text(
                  "Get Started",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
