import 'package:flutter/material.dart';

class BuildInputField extends StatelessWidget {
  final TextEditingController controller;
  String hintText;
  Icon? icon;
  bool obscureText;
  int maxLines;
  VoidCallback? onEditingComplete;
  TextInputType? keyboardType;

  BuildInputField(
      {required this.controller,
      required this.hintText,
      this.onEditingComplete,
      this.icon,
      required this.obscureText,
      required this.maxLines,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        onEditingComplete: onEditingComplete,
        obscureText: obscureText,
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
