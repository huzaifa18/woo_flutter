import 'dart:async';

import 'package:flutter/material.dart';
import 'package:woo_flutter/Screens/CategoriesPage/components/body.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<Categories> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*Timer(
        Duration(seconds: 3),
            () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DashBoardScreen();
            },
          ),
        ));*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
