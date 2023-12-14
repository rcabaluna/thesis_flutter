import 'package:flutter/material.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/notifiers/cart/cart_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/screens/cart_screen/cart_screen.dart';
import 'package:local_marketplace/screens/products_list_screen/products_list_screen.dart';
// import 'package:local_marketplace/screens/products_list_screen/products_list_screen%20orig.dart';
import 'package:local_marketplace/screens/profile_screen/profile_screen.dart';
import 'package:local_marketplace/screens/search_screen/search_screen.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class MainScreen extends StatefulWidget {
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  final pages = [
    ProductsListScreen(),
    SearchScreen(),
    CartScreen(),
    ProfileScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
              ),
              Image.asset(
                logoPng,
                height: 85,
              )
            ],
          )),
      body: pages[pageIndex],
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(43, 18, 43, 24),
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 0.8))),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    pageIndex = 0;
                  });
                },
                child: buildBottomBarItem(Icons.home_outlined, "Home", 0),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    pageIndex = 1;
                  });
                },
                child: buildBottomBarItem(Icons.search_outlined, "Browse", 1),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    pageIndex = 2;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<CartNotifier>(builder: (_, cartNotifier, __) {
                      return GestureDetector(
                        onTap: () {
                          getIt<NavigationService>()
                              .navigateTo(cartRoute, arguments: {});
                        },
                        child: Container(
                          height: 25,
                          width: 25,
                          child: cartNotifier.cartLength > 0
                              ? badges.Badge(
                                  position: badges.BadgePosition.topEnd(
                                      top: -12, end: -10),
                                  badgeContent:
                                      Text("${cartNotifier.cartLength}"),
                                  child:
                                      const Icon(Icons.shopping_cart_outlined))
                              : const Icon(Icons.shopping_cart_outlined),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    pageIndex = 3;
                  });
                },
                child: buildBottomBarItem(Icons.person_outline, "Profile", 3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomBarItem(IconData icon, String name, int index) {
    final Color color =
        pageIndex == index ? Colors.green : Colors.black;

    return Container(
      height: 25,
      width: 25,
      child: Icon(
        icon,
        color: color,
      ),
    );
  }
}
