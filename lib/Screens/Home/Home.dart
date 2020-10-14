import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:woo_flutter/Screens/Account/Account.dart';
import 'package:woo_flutter/Screens/Cart/Cart.dart';
import 'package:woo_flutter/Screens/CategoriesPage/Categories.dart';
import 'package:woo_flutter/Screens/Dashboard/container_transition.dart';
import 'package:woo_flutter/Screens/Favourites/Favourites.dart';
import 'package:woo_flutter/api/RestClient.dart';
import 'package:woo_flutter/api/ServerError.dart';
import 'package:woo_flutter/models/BaseModel.dart';
import 'package:woo_flutter/models/CategoryModelAPI.dart';
import 'package:woo_flutter/models/ProductModelAPI.dart';

import '../../constants.dart';

void main() => runApp(Home());

int _currentIndex = 0;

int itemcount = 1;
int totalprice = 1;

var logger = Logger();

final List<String> imgList = [
  'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-04/bg23-768x406.png',
  'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-04/bg31-768x406.png',
  'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-04/bg12-768x406.png',
  /*'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-01/1-600x405.jpg',
  'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-01/1.1-600x405.jpg',
  'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-02/21.jpg'*/
];

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

final List child = map<Widget>(
  imgList,
  (index, i) {
    _currentIndex = index;
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(children: <Widget>[
          Image.network(i, fit: BoxFit.cover, width: 1000.0),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(200, 0, 0, 0),
                    Color.fromARGB(0, 0, 0, 0)
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  },
).toList();

Future<BaseModel<List<CategoryModelAPI>>> getCategories() async {
  List<CategoryModelAPI> response;
  try {
    response = await RestClient().getCategories();
    logger.e("Log Response: " + response.toString());
    print("Print Response: $response");
  } catch (error, stacktrace) {
    print("Exception occured: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

Future<BaseModel<List<ProductModelAPI>>> getProducts() async {
  List<ProductModelAPI> response;
  try {
    response = await RestClient().getProducts();
    logger.e("Log Response: " + response.toString());
    print("Print Response: $response");
  } catch (error, stacktrace) {
    print("Exception occured: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
      CarouselSlider(
          items: child,
          options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                /*setState(() {
                  _currentIndex = index;
                });*/
              })),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(
          imgList,
          (index, url) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4)),
            );
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Categories",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Categories();
                      },
                    ));
                  },
                  child: Text(
                    'View More',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: kPrimaryLightColor,
                    ),
                  )),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.0,
                color: kPrimaryColor,
              )
            ]),
          ],
        ),
      ),
      Container(
        height: 200.0,
        child: FutureBuilder<BaseModel<List<CategoryModelAPI>>>(
          future: getCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("Error: " + snapshot.error);
            }
            return snapshot.hasData
                ? _buildCategoriesList(snapshot.data.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Best Selling Products",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              InkWell(
                  onTap: () {},
                  child: Text(
                    'View More',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: kPrimaryLightColor,
                    ),
                  )),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.0,
                color: kPrimaryColor,
              )
            ]),
          ],
        ),
      ),
      Container(
        child: FutureBuilder<BaseModel<List<ProductModelAPI>>>(
          future: getProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("Error: " + snapshot.error);
            }
            return snapshot.hasData
                ? _buildProductsList(snapshot.data.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
      /*SizedBox(
          height: 210.0,
          child: ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: _itemBuilder),
        ),*/
      Container(
          height: 180.0,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                  "https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-14/bg241.png"),
              Text("Super Deals \n Just for You!",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold))
            ],
          )
          /*decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(200, 0, 0, 0),
                Color.fromARGB(0, 0, 0, 0)
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),*/
          )
    ]));
  }

  //use stack for overlapping
  Widget _buildCategoriesList(List<CategoryModelAPI> items) {
    /*getCategories().then((it) {
      logger.e(it);
      if (it != null || it.data.length > 0) {
        cats = it.data;
      }
      print("Print Func Response: " + it.data.toString());
    }).catchError((Object obj) {
      // non-200 error goes here.
      print("Get Categories Error: " + obj.toString());
      switch (obj.runtimeType) {
        case ServerError:
          // Here's the sample to get the failed response error code and message
          final res = (obj as ServerError);
          logger.e(
              "Got error : ${res.getErrorCode()} -> ${res.getErrorMessage()}");
          break;
        default:
      }
    });*/
    Widget itemCards;
    if (items != null || items.length > 0) {
      itemCards = GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: 2,
        crossAxisCount: 2,
        children: List.generate(items.length, (index) {
          String image =
              "https://attraitbyaliroy.com/wp-content/uploads/woocommerce-placeholder-300x300.png";
          /*if (items[index].image != null) {
            image = items[index].image.src;
          } else {
            image =
                "https://attraitbyaliroy.com/wp-content/uploads/woocommerce-placeholder-300x300.png";
          }*/
          return GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  FadeInImage(
                    height: 180.0,
                    width: 180.0,
                    fit: BoxFit.cover,
                    image: NetworkImage(image),
                    placeholder: AssetImage(
                        "assets/images/woocommerce_placeholder_300x300.png"),
                  ),
                  Container(
                    height: 20.0,
                    width: 180.0,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 8.0, right: 8.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.black.withAlpha(95),
                          Colors.black12.withAlpha(95),
                          Colors.black45.withAlpha(95)
                        ],
                      ),
                    ),
                    child: Text(items[index].name,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center),
                  )
                ],
              ),
            ),
            onTap: _categoryClick,
          );
        }),
      );
    } else {
      itemCards = Container(
        child: Text('No items'),
      );
    }
    return itemCards;
  }

  _buildProductsList(List<ProductModelAPI> items) {
    Widget itemCards;
    if (items != null || items.length > 0) {
      itemCards = SizedBox(
        //width: 210.0,
        height: 220.0,
        child: ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              String price = items[index].price;
              String image;
              if (items[index].images.length > 0) {
                image = items[index].images.asMap()[0].src;
              } else {
                image =
                    "https://attraitbyaliroy.com/wp-content/uploads/woocommerce-placeholder-300x300.png";
              }
              return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return OpenContainerTransformDemo();
                        },
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.network(image,
                            width: 140.0, height: 160.0, fit: BoxFit.cover),
                        Container(
                          width: 140.0,
                          padding: EdgeInsets.all(2),
                          child: Text(
                            items[index].name,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: 140.0,
                          padding: EdgeInsets.all(2),
                          child: Text("\$ $price",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                  ));
            }),
      );
    } else {
      itemCards = Container(
        child: Text('No items'),
      );
    }
    return itemCards;
  }

  void _categoryClick() {}
}
