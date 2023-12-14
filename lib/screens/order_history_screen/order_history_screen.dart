// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/productbyseller/product_by_seller.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderDetailScreenState createState() => OrderDetailScreenState();
}

class OrderDetailScreenState extends State<OrderDetailScreen> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        leading: IconButton(
            onPressed: () {
              getIt<NavigationService>()
                  .navigateTo(orderHistoryRoute, arguments: {});
            },
            icon: Icon(Icons.arrow_back)),
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
              buildNoteContainer(),
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
          Text(
            "Meet Up to or Delivery to",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 25,
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
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  size: 25,
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
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 25,
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
          )
        ],
      ),
    );
  }

  Widget buildMeetUpContainerDate() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Meet Up Time",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          ),
          Text(
            "10:30 AM",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          ),
          Text(
            "Oct 5, 2023",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          )
        ],
      ),
    );
  }

  Widget buildItemsContainer() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.store,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Store Name")
            ],
          ),
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

  Widget buildNoteContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Note:",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s ",
              maxLines: isExpanded ? null : 3,
              overflow:
                  isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order Date:",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              Text("Oct 5, 2023",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total:",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                    fontSize: 18),
              ),
              Text(
                "P 1023.00",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                    fontSize: 18),
              )
            ],
          )
        ],
      ),
    );
  }
}

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
        leading: IconButton(
            onPressed: () {
              getIt<NavigationService>()
                  .navigateTo(mainScreenRoute, arguments: {});
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              GestureDetector(
                  onTap: () {
                    getIt<NavigationService>()
                        .navigateTo(orderDetailsRoute, arguments: {});
                  },
                  child: buildOrderContainer())
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderContainer() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shop Name",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  getIt<NavigationService>()
                      .navigateTo(orderDetailsRoute, arguments: {});
                },
                child: Text(
                  "See Details",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(partialShop),
                radius: 40,
              ),
              SizedBox(
                width: 30,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Id Number ",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "6 Items",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "P 780.00",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Oct. 12, 2023",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
