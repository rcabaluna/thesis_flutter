// ignore_for_file: depend_on_referenced_packages

import 'package:get_it/get_it.dart';
import 'package:local_marketplace/common/core/network/app_interceptor.dart';
import 'package:local_marketplace/common/core/network/index.dart';
import 'package:local_marketplace/notifiers/app_notifier.dart';
import 'package:local_marketplace/notifiers/cart/cart_notifier.dart';
import 'package:local_marketplace/notifiers/category/category_notifier.dart';
import 'package:local_marketplace/notifiers/product/product_notifier.dart';
import 'package:local_marketplace/services/app_state/app_state_service.dart';
import 'package:local_marketplace/services/app_state/startup_service.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());
  getIt.registerLazySingleton<AppNotifier>(() => AppNotifier());
  getIt.registerLazySingleton<NetworkService>(() => NetworkService());
  getIt.registerLazySingleton<AppInterceptor>(() => AppInterceptor());
  getIt.registerLazySingleton<ProductNotifier>(() => ProductNotifier());
  getIt.registerLazySingleton<CategoryNotifier>(() => CategoryNotifier());
  getIt.registerLazySingleton<StartUpService>(() => StartUpService());
  getIt.registerLazySingleton<CartNotifier>(() => CartNotifier());
  getIt.registerLazySingleton<AppStateService>(() => AppStateService());
}
