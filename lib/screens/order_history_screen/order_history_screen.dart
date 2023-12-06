// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class OrderHistortyScreen extends StatefulWidget {
  OrderHistoryScreenState createState() => OrderHistoryScreenState();
}

class OrderHistoryScreenState extends State<OrderHistortyScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.store_outlined,
                    size: 35,
                  ),
                  Text("Store Name"),
                  Text(
                    "Completed",
                    style: TextStyle(fontSize: 10, color: Colors.green),
                  )
                ],
              ),
              buildOrderWidget(),
              SizedBox(
                height: 10,
              ),
              buildTotalOrder(),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Icon(
                    Icons.local_shipping,
                    size: 25,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Order has been delivered or meet up",
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order Date:",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text("10/12/2023",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderWidget() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://www.organics.ph/cdn/shop/products/chili-labuyo-100grams-fruits-vegetables-fresh-produce-126835_800x.jpg?v=1601484492'),
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
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  Text("X2")
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTotalOrder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total Order:",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          "\$38",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
