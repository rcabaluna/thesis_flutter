// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';

class ShopPendingOrderScreen extends StatefulWidget {
  ShopPendingOrderScreenState createState() => ShopPendingOrderScreenState();
}

class ShopPendingOrderScreenState extends State<ShopPendingOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pending Orders",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "View Order History",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
              GestureDetector(
                  onTap: () {
                    getIt<NavigationService>()
                        .navigateTo(shopOrderDetailsRoute, arguments: {});
                  },
                  child: buildOrderContainer())
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://www.organics.ph/cdn/shop/products/chili-labuyo-100grams-fruits-vegetables-fresh-produce-126835_800x.jpg?v=1601484492'), // Replace with your actual image path
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product Name",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$19.99",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.w600),
                      ),
                      Text("X2"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Text("To Delivery"),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: TextButton(
                onPressed: () {
                  // Handle Accept logic
                },
                child: Text(
                  "Accept",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: TextButton(
                onPressed: () {
                  // Handle Decline logic
                },
                child: Text(
                  "Decline",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
