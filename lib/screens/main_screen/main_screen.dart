import 'package:flutter/material.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/notifiers/cart/cart_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/screens/cart_screen/cart_screen.dart';
import 'package:local_marketplace/screens/home/home-screen.dart';
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
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              logoPng,
              height: 60,
            ),
          ],
        ),
      actions: [
        Consumer<CartNotifier>(
          builder: (_, cartNotifier, __) {
            return GestureDetector(
              onTap: () {
                getIt<NavigationService>().navigateTo(cartRoute, arguments: {});
              },
              child: cartNotifier.cartLength > 0
                  ? badges.Badge(
                      position: badges.BadgePosition.topEnd(top: -8, end: -5),
                      badgeContent: Text(
                        "${cartNotifier.cartLength}",
                        style: TextStyle(fontSize: 8), // Adjust the font size here
                      ),
                      child: const Icon(Icons.shopping_cart),
                    )
                  : const Icon(Icons.shopping_cart),
            );
          },
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    ),
      body: pages[pageIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color.fromARGB(255, 99, 99, 99), width: 0.2),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust padding here
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildBottomBarItem(Icons.home_outlined, "Home", 0),
            buildBottomBarItem(Icons.search_outlined, "Search", 1),
            buildBottomBarItemWithBadge(Icons.shopping_cart_outlined, "Cart", 2),
            buildBottomBarItem(Icons.person_outline, "Profile", 3),
          ],
        ),
      ),
    );
  }

  Widget buildBottomBarItem(IconData icon, String name, int index) {
    final Color color = pageIndex == index ? Colors.green : Color(0xFF2B2B2B);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            pageIndex = index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
            ),
            Text(
              name,
              style: TextStyle(
                color: color,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomBarItemWithBadge(IconData icon, String name, int index) {
  final Color color = pageIndex == index ? Colors.green : Color(0xFF2B2B2B);

  return Expanded(
    child: GestureDetector(
      onTap: () {
        setState(() {
          // pageIndex = index;
          getIt<NavigationService>().navigateTo(cartRoute, arguments: {});
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<CartNotifier>(
            builder: (_, cartNotifier, __) {
              return Stack(
                children: [
                  Icon(
                    icon,
                    color: color,
                  ),
                  if (cartNotifier.cartLength > 0)
                    Positioned(
                      top: 0, // Adjust this value to position the badge vertically
                      right: 0, // Adjust this value to position the badge horizontally
                      child: badges.Badge(
                        position: badges.BadgePosition.topEnd(top: -10, end: -8),
                        badgeContent: Text(
                          "-",
                          style: TextStyle(fontSize: 1), // Adjust badge font size here
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          Text(
            name,
            style: TextStyle(
              color: color,
              fontSize: 9,
            ),
          ),
        ],
      ),
    ),
  );
  }


}
