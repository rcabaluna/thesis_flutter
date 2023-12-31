// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/provider_setup.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/routes/routes.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...appStateProviders,
        ...productProviders,
        ...categoryProviders,
      ],
      child: GlobalLoaderOverlay(
        overlayColor: Colors.green!.withOpacity(0.6),
        child: MaterialApp(
          onGenerateRoute: generateRoute,
          initialRoute: splashScreenRoute,
          navigatorKey: getIt<NavigationService>().navigatorKey,
          title: 'Online Marketplace',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: true,
            // textTheme: GoogleFonts.montserratTextTheme(),
          ),
        ),
      ),
    );
  }
}
