// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:local_marketplace/screens/my_order_screen/delivery_screen.dart';
import 'package:local_marketplace/screens/my_order_screen/meet_up.dart';

class MyOrderScreen extends StatefulWidget {
  MyOrderScreenState createState() => MyOrderScreenState();
}

class MyOrderScreenState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Orders"),
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back),
          ),
          bottom: TabBar(tabs: [Text("Delivery"), Text("Meet Up")]),
        ),
        body: TabBarView(children: [DeliveryScreen(), MeetUpScreen()]),
      ),
    );
  }
}
