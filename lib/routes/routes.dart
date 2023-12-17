// ignore_for_file: constant_pattern_never_matches_value_type

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/notifiers/app_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/screens/add_product_screen/add_product_screen.dart';
import 'package:local_marketplace/screens/auth/login_screen.dart';
import 'package:local_marketplace/screens/auth/register_screen.dart';
import 'package:local_marketplace/screens/cart_screen/cart_screen.dart';
import 'package:local_marketplace/screens/checkout_screen/checkout_screen.dart';
import 'package:local_marketplace/screens/edit_profile_screen/edit_profile_screen.dart';
import 'package:local_marketplace/screens/main_screen/main_screen.dart';
import 'package:local_marketplace/screens/my_order_screen/my_order_screen.dart';
import 'package:local_marketplace/screens/my_ratings_screen/my_ratings_screen.dart';
import 'package:local_marketplace/screens/order_history_screen/order_history_screen.dart';
import 'package:local_marketplace/screens/product_detail_screen/product_detail_screen.dart';
import 'package:local_marketplace/screens/profile_screen/profile_screen.dart';
import 'package:local_marketplace/screens/rate_order_screen/rate_order_screen.dart';
import 'package:local_marketplace/screens/registration_fee_screen/registration_review.dart';
import 'package:local_marketplace/screens/registration_fee_screen/shop_registration_fee.dart';
import 'package:local_marketplace/screens/shop_order_details_screen/shop_order_details_screen.dart';
import 'package:local_marketplace/screens/shop_pending_orders_screen/shop_pending_orders_screen.dart';
import 'package:local_marketplace/screens/shop_product_screen/shop_product.dart';
import 'package:local_marketplace/screens/shop_profile/shop_profile.dart';
import 'package:local_marketplace/screens/shop_registration_screen/shop_registration.dart';
import 'package:local_marketplace/screens/shop_welcome_screen/shop_welcome_screen.dart';
import 'package:local_marketplace/screens/splash_screen.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case loginRoute:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case mainScreenRoute:
      return MaterialPageRoute(builder: (context) => MainScreen());
    case splashScreenRoute:
      return MaterialPageRoute(builder: (context) => SplashScreen());
    case productDetailRoute:
      return MaterialPageRoute(builder: (context) => ProductDetailsScreen("productId"));
    case shopWelcomeRoute:
      return MaterialPageRoute(builder: (context) => ShopWelcomeScreen());
    case shopRegistrationRoute:
      return MaterialPageRoute(builder: (context) => ShopRegistrationScreen());
    case registrationFeeRoute:
      return MaterialPageRoute(
          builder: (context) => ShopRegistrationFeeScreen());
    case registrationReviewRoute:
      return MaterialPageRoute(
          builder: (context) => RegistrationReviewScreen());
    case shopProfileRoute:
      return MaterialPageRoute(builder: (context) => ShopProfileScreen());
    case shopOrderDetailsRoute:
      return MaterialPageRoute(builder: (context) => ShopOrderDetailsScreen());
    case orderHistoryRoute:
      return MaterialPageRoute(builder: (context) => OrderHistortyScreen());
    case myOrderRoute:
      return MaterialPageRoute(builder: (context) => MyOrderScreen());
    case orderDetailsRoute:
      return MaterialPageRoute(builder: (context) => OrderDetailScreen());
    case editProfileRoute:
      return MaterialPageRoute(builder: (context) => EditProfileScreen());
    case myRatingRoute:
      return MaterialPageRoute(builder: (context) => MyRatingScreen());
    case rateOrderRoute:
      return MaterialPageRoute(builder: (context) => RateOrderScreen());
    case shopProductRoute:
      return MaterialPageRoute(builder: (context) => ShopProductScreen());
    case shopPendingOrderRoute:
      return MaterialPageRoute(builder: (context) => ShopPendingOrderScreen());
    case addProductRoute:
      return MaterialPageRoute(builder: (context) => AddProductScreen());
    case loginRoute:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case registerRoute:
      return MaterialPageRoute(builder: (context) => RegisterScreen());
    case cartRoute:
      return MaterialPageRoute(builder: (context) => CartScreen());
    case checkoutRoute:
      if (getIt<AppNotifier>().isLoggedIn) {
        return MaterialPageRoute(builder: (context) => CheckoutScreen());
      } else {
        return MaterialPageRoute(builder: (context) => LoginScreen());
      }

    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(
                  body: Center(
                child: Text(
                  "Invalid Route",
                  style: TextStyle(color: Colors.blue),
                ),
              )));
  }
}
