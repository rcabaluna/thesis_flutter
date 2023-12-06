import 'package:flutter/material.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';

class RegistrationReviewScreen extends StatefulWidget {
  RegistrationReviewScreenState createState() =>
      RegistrationReviewScreenState();
}

class RegistrationReviewScreenState extends State<RegistrationReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            complete,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Thank you for registering. Please wait for the confirmation. ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.15,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  getIt<NavigationService>()
                      .navigateTo(shopProfileRoute, arguments: {});
                },
                child: Text(
                  'Redirect to Home',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
