// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/orders/order_details_model.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:local_marketplace/services/order/order.service.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  OrderDetailScreen(this.orderId);

  OrderDetailScreenState createState() => OrderDetailScreenState();
}

class OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderDetails? orderDetails;
  String xstatus = "Accepted";
  void initState() {
    super.initState();
    fetchProductDetails(widget.orderId);
  }

  void fetchProductDetails(String orderId) {
    String orderIdx = orderId;
    OrderService orderService = OrderService();

    orderService
        .getShopOrderDetails(orderIdx)
        .then((List<OrderDetails> orderDetailsList) {
      orderDetails = orderDetailsList.first;
    }).catchError((error) {
      print("Error fetching product details: $error");
    });
  }

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Order Details",
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.green, // Green app bar color
        elevation: 2, // Adding elevation for a subtle shadow
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              buildBuyerContainer(),
              SizedBox(
                height: 10,
              ),
              buildMeetUpContainerDate(),
              SizedBox(
                height: 10,
              ),
              buildItemsContainer(),
              SizedBox(
                height: 10,
              ),
              buildActionButtons(xstatus),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBuyerContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Text(
            'Order ID: 34T3T2456YW246',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          )),
          Center(
            child: Text('Ordered on 2023-12-18 08:23:12',
                style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
          SizedBox(
            height: 18,
          ),
          Text(
            "Meet Up to or Delivery to",
            style: TextStyle(
              fontSize: 13,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      "Misamis Oriental, Opol Poblacion",
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(0),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  size: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Jay Kim Lusing",
                  style: TextStyle(fontSize: 13),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(0),
            child: Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "09662964893",
                  style: TextStyle(fontSize: 13),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(0),
            child: Row(
              children: [
                Icon(
                  Icons.notes_outlined,
                  size: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Notes",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(0),
            child: Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                Text(
                  "Atbang sa Gram",
                  style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMeetUpContainerDate() {
    return Container(
      child: Divider(
        color: Colors.black, // Change the color of the divider line
        thickness: 0.1, // Set the thickness of the divider line
        height: 20, // Set the vertical space above the divider
      ),
    );
  }

  Widget buildItemsContainer() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(partialProduct),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Coconut"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("P 25.00"),
                        Text(
                          "X 3",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sub Total",
                style: TextStyle(fontSize: 11),
              ),
              Text("P 165.00", style: TextStyle(fontSize: 11))
            ],
          )
        ],
      ),
    );
  }

  Widget buildActionButtons(String xstatus) {
    bool isAccepted = xstatus == "Accepted";

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: isAccepted
                ? () {
                    ReceivedOrder(widget.orderId);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              primary: isAccepted
                  ? Colors.green
                  : Colors
                      .grey, // Set the background color to green if accepted, grey if not
            ),
            child: Text(
              'Order Received',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void ReceivedOrder(String orderId) {
    OrderService orderService = OrderService();
    orderService.receiveOrder(orderId).then((_) {});
  }
}
