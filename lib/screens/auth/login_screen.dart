// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/notifiers/app_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:local_marketplace/services/user_auth/auth.service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    final AuthService authService = AuthService();

    try {
      final response = await authService.login({
        "email": emailController.text,
        "password": passwordController.text,
      });

      await getIt<AppNotifier>().saveAccessToken(response["accessToken"]);
      await getIt<AppNotifier>().fetchUserDetails();
      await getIt<AppNotifier>().getMyShop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Successfully Logged In")),
      );

      getIt<NavigationService>()
          .navigatorKey
          .currentState
          ?.pushNamedAndRemoveUntil(
            mainScreenRoute,
            (route) => false,
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Error Logging In")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Image.asset(
              login,
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              "Login",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 5),
            Text(
              "Enter your username and password.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            BuildInputField(
              controller: emailController,
              icon: Icon(Icons.email),
              hintText: "E-mail",
              maxLines: 1,
              obscureText: false,
            ),
            const SizedBox(height: 10),
            BuildInputField(
              controller: passwordController,
              icon: Icon(Icons.lock),
              hintText: "Password",
              obscureText: true,
              maxLines: 1,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : Text('Login', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    getIt<NavigationService>()
                        .navigateTo(registerRoute, arguments: {});
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BuildInputField extends StatelessWidget {
  final TextEditingController controller;
  final Icon icon;
  final String hintText;
  final int maxLines;
  final bool obscureText;

  const BuildInputField({
    required this.controller,
    required this.icon,
    required this.hintText,
    this.maxLines = 1,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Darkened background color
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        obscureText: obscureText,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none, // Remove text field border
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          icon: icon,
        ),
      ),
    );
  }
}
