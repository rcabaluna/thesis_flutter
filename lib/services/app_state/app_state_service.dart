import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/notifiers/app_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';

class AppStateService {
  Future checkLoggedInAndRedirect() async {
    bool isLoggedIn = getIt<AppNotifier>().currentToken.isNotEmpty;
    if (!isLoggedIn) {
      getIt<NavigationService>().navigateTo(loginRoute, arguments: {});
    }
  }
}
