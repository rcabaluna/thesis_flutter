// ignore_for_file: depend_on_referenced_packages

import 'package:local_marketplace/notifiers/app_notifier.dart';
import 'package:local_marketplace/notifiers/cart/cart_notifier.dart';
import 'package:local_marketplace/notifiers/category/category_notifier.dart';
import 'package:local_marketplace/notifiers/product/product_notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'common/dependency_locator.dart';

List<SingleChildWidget> appStateProviders = [
  ChangeNotifierProvider.value(value: getIt<AppNotifier>()),
  ChangeNotifierProvider.value(value: getIt<CartNotifier>())
];

List<SingleChildWidget> productProviders = [
  ChangeNotifierProvider.value(value: getIt<ProductNotifier>())
];

List<SingleChildWidget> categoryProviders = [
  ChangeNotifierProvider.value(value: getIt<CategoryNotifier>())
];
