// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/models/orders/order_details_model.dart';
import 'package:local_marketplace/models/orders/orders_model.dart';
import 'package:local_marketplace/services/order/order.service.dart';

class ShopOrderDetailsScreen extends StatefulWidget {
  final String orderId;
  dynamic orderSummary;
  ShopOrderDetailsScreen(this.orderId);

  ShopOrderDetailsScreenState createState() => ShopOrderDetailsScreenState();
}

class ShopOrderDetailsScreenState extends State<ShopOrderDetailsScreen> {
  OrderDetails? orderDetails;
  OrderSummary? orderSummary;

  void initState() {
    super.initState();
    fetchProductDetails(widget.orderId);
    getOrderSummary(widget.orderId);
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

  void getOrderSummary(String orderId) {
    String orderIdx = orderId;
    OrderService orderService = OrderService();

    orderService.getOrderSummary(orderIdx);
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
              buildActionButtons(),
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
            'Order ID: ${widget.orderId}',
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

  // Widget to build the UI with accept and reject functionalities
  Widget buildActionButtons() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20), // Adding space between text and buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  AcceptOrder(widget.orderId);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Set the background color to green
                ),
                child: Text(
                  'Accept',
                  style:
                      TextStyle(color: Colors.white), // Set text color to white
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Show rejection dialog when the "Reject" button is pressed
                  showRejectionDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .red.shade700, // Set the background color to a red shade
                ),
                child: Text(
                  'Reject',
                  style:
                      TextStyle(color: Colors.white), // Set text color to white
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Function to show a dialog for entering the reason for rejection
  void showRejectionDialog(BuildContext context) {
    String rejectionReason = ''; // Variable to store the rejection reason

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reason for Rejection'),
          content: TextField(
            onChanged: (value) {
              rejectionReason = value; // Update the rejection reason
            },
            decoration: InputDecoration(
              hintText: 'Enter reason here',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform actions on reject with reason
                print('Order rejected for reason: $rejectionReason');
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  void AcceptOrder(String orderId) {
    OrderService orderService = OrderService();
    orderService.acceptOrder(orderId).then((_) {});
  }
}
