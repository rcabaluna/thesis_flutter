// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/notifiers/app_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:local_marketplace/services/user_auth/auth.service.dart';
import 'package:local_marketplace/widget/input_field/input_field.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    login,
                    height: 200,
                  ),
                  Text(
                    "Perfect!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    "Please enter your correct e-mail and password.",
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  BuildInputField(
                    controller: email,
                    icon: Icon(Icons.email),
                    hintText: "E-mail",
                    maxLines: 1,
                    obscureText: false,
                  ),
                  BuildInputField(
                    controller: password,
                    icon: Icon(Icons.password),
                    hintText: "Password",
                    obscureText: true!,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .6,
                      height: MediaQuery.of(context).size.width * 0.15,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          final AuthService authService = AuthService();
                          context.loaderOverlay.show();
                          final Map<String, dynamic> data = {
                            "email": email.text,
                            "password": password.text,
                          };

                          try {
                            final response = await authService.login(data);
                            print(response["accessToken"]);
                            await getIt<AppNotifier>()
                                .saveAccessToken(response["accessToken"]);
                            print("saved access token");
                            await getIt<AppNotifier>().fetchUserDetails();
                            await getIt<AppNotifier>().getMyShop();
                            if (context.mounted) {
                              context.loaderOverlay.hide();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: const Text(
                                          "Successfully Logged In")));

                              getIt<NavigationService>()
                                  .navigatorKey
                                  .currentState
                                  ?.pushNamedAndRemoveUntil(
                                      mainScreenRoute, (route) => false);
                            }
                          } catch (e) {
                            print(e);
                            if (context.mounted) {
                              context.loaderOverlay.hide();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: const Text("Error Loggin In")));
                            }
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Create an account."),
                      TextButton(
                          onPressed: () {
                            getIt<NavigationService>()
                                .navigateTo(registerRoute, arguments: {});
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600),
                          ))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
