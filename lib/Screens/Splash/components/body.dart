import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:woo_flutter/Screens/Splash/components/background.dart';
import 'package:flutter_svg/svg.dart';

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
            /*GifImage(
              controller: controller,
              image: AssetImage("assets/images/woo_gif.gif"),
            ),*/
            SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.45,
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
