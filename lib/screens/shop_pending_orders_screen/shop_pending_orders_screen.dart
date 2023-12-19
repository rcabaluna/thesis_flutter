import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/shop/shop_orders_model.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/screens/shop_order_details_screen/shop_order_details_screen.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:local_marketplace/services/order/order.service.dart';

class ShopPendingOrderScreen extends StatefulWidget {
  @override
  ShopPendingOrderScreenState createState() => ShopPendingOrderScreenState();
}

class ShopPendingOrderScreenState extends State<ShopPendingOrderScreen> {
  var isSearching = false;
  var showLoader = false;
  OrderService orderService = OrderService();
  List<ShopOrders> orders = [];

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
          "My Shop Orders",
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.green, // Green app bar color
        elevation: 2, // Adding elevation for a subtle shadow
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            if (orders
                .isNotEmpty) // Conditionally show the text if orders exist
              Text(
                "List of Orders: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            SizedBox(
              height: 10,
            ),
            showLoader
                ? CircularProgressIndicator() // Show a loader while fetching orders
                : Expanded(
                    child: orders.isEmpty
                        ? Center(child: Text("No order(s) found"))
                        : ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              return OrdersWidget(orders[index]);
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getOrdersList();
  }

  void getOrdersList() {
    setState(() {
      isSearching = true;
      showLoader = true;
    });

    orderService.getShopOrders().then((receivedOrders) {
      setState(() {
        isSearching = false;
        showLoader = false;
        orders = receivedOrders;
      });
    }).catchError((error) {
      setState(() {
        isSearching = false;
        showLoader = false;
      });
      print('Error searching products: $error');
    });
  }
}

class OrdersWidget extends StatelessWidget {
  final ShopOrders ordersummary;

  OrdersWidget(this.ordersummary);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image placeholder or widget goes here (ClipRRect, SizedBox)
            ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              // Add image widget here
            ),
            SizedBox(width: 10), // Spacer between image and order details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // OrderID
                  Text(
                    'OrderID : ${ordersummary.orderId}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        'test',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Payment Status or any additional information
                    ],
                  ),
                  SizedBox(
                      height: 10), // Spacer between Price and Delivery Type
                  // Delivery Type
                  Text('Delivery : ${ordersummary.deliveryType}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.right),
                  SizedBox(
                      height:
                          10), // Spacer between Delivery Type and View Details button
                  // View Details Button
                  ElevatedButton(
                    onPressed: () {
                      // getIt<NavigationService>().navigateTo(
                      //     shopOrderDetailsRoute,
                      //     arguments: {ordersummary.orderId});

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShopOrderDetailsScreen(ordersummary.orderId),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: Size(
                        double.infinity,
                        36,
                      ),
                    ),
                    child: Text(
                      "View Details",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
