import 'package:flutter/material.dart';
import 'package:woo_flutter/Screens/Splash/components/background.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Dashboard",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            /*GifImage(
              controller: controller,
              image: AssetImage("assets/images/woo_gif.gif"),
            ),*/
            Image.asset(
              "assets/icons/woo_logo.png",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05)
          ],
        ),
      ),
    );
  }
}
