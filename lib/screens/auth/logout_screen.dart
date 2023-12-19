import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:local_marketplace/services/user_auth/auth.service.dart';

class LogoutScreen extends StatefulWidget {
  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  final AuthService _authService = AuthService(); // Assuming AuthService is registered with dependency injection

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    performLogout();
  }

  void performLogout() async {
    try {
      var xStatus = await _authService.logout();
      print(xStatus);
      if (xStatus == 'lg') {
        getIt<NavigationService>().navigateTo(loginRoute, arguments: {});
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error logging out';
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Logout failed: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : errorMessage.isNotEmpty
                ? Text(errorMessage)
                : SizedBox(), // Adjust this to show an error message widget as needed
      ),
    );
  }
}
