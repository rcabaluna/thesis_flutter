// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';

class MeetUpScreen extends StatefulWidget {
  MeetUpScreenState createState() => MeetUpScreenState();
}

class MeetUpScreenState extends State<MeetUpScreen> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
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
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    child: Text(
                      "Received",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
