// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_marketplace/common/constants.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:local_marketplace/services/user_auth/auth.service.dart';
import 'package:local_marketplace/widget/input_field/input_field.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController fullname = TextEditingController();
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
                    signUp,
                    height: 200,
                  ),
                  Text(
                    "Get on Board!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    "Create your profile to start a journey.",
                    style: TextStyle(fontSize: 11),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  BuildInputField(
                    maxLines: 1,
                    controller: email,
                    obscureText: false,
                    icon: Icon(Icons.email),
                    hintText: "E-mail",
                  ),
                  BuildInputField(
                    controller: fullname,
                    icon: Icon(Icons.person),
                    hintText: "Full Name",
                    obscureText: false,
                    maxLines: 1,
                  ),
                  BuildInputField(
                    controller: password,
                    icon: Icon(Icons.lock),
                    hintText: "Password",
                    maxLines: 1,
                    obscureText: true,
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
                            "fullName": fullname.text
                          };

                          try {
                            await authService.register(data);
                            if (context.mounted) {
                              context.loaderOverlay.hide();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: const Text(
                                          "Successfully Registered")));
                              getIt<NavigationService>()
                                  .navigateTo(loginRoute, arguments: {});
                            }
                          } catch (e) {
                            if (context.mounted) {
                              context.loaderOverlay.hide();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          const Text("Error Registering")));
                            }
                          }
                        },
                        child: Text(
                          'Sign Up',
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
                      Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            getIt<NavigationService>()
                                .navigateTo(loginRoute, arguments: {});
                          },
                          child: Text(
                            "Login",
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
