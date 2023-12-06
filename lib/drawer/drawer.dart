// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[100],
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
                child: Text(
              "C A T E G O R I E S",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ),
          ListTile(
            leading: Icon(
              Icons.egg,
              size: 30,
              color: Colors.purple,
            ),
            title: Text("CATEGORY 1"),
          ),
          ListTile(
            leading: IconButton(
              icon: Icon(
                Icons.face,
                size: 30,
                color: Colors.purple,
              ),
              onPressed: () {},
            ),
            title: Text("CATEGORY 1"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
