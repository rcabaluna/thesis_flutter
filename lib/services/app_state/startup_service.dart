import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/notifiers/category/category_notifier.dart';
import 'package:local_marketplace/notifiers/product/product_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';

class StartUpService {
  init() async {
    await getIt<ProductNotifier>().init();
    await getIt<CategoryNotifier>().init();

    getIt<NavigationService>().navigateTo(mainScreenRoute, arguments: {});
  }
}
