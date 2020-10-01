import 'package:flutter/material.dart';
import 'package:woo_flutter/Screens/Splash/components/background.dart';

class Body extends StatelessWidget {
  //ImageProvider logo = AssetImage("assets/icons/woo.gif");
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /*GifImage(
              controller: controller,
              image: AssetImage("assets/images/woo.gif"),
            ),*/
            Image.asset(
              "assets/gifs/woo.gif",
              gaplessPlayback: true,
              height: 300,
              width: 300,
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              margin: const EdgeInsets.only(top: 100.0),
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Text(
                  "Powered By Symtera Technologies pvt ltd.",
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
