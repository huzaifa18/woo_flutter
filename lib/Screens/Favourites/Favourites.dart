import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:woo_flutter/Screens/CategoriesPage/components/background.dart';
import 'file:///D:/Huzaifa%20Asif/FlutterProjects/woo_flutter/lib/Screens/ProductDetails/product_detail.dart';
import 'package:woo_flutter/api/RestClient.dart';
import 'package:woo_flutter/api/ServerError.dart';
import 'package:woo_flutter/constants.dart';
import 'package:woo_flutter/models/BaseModel.dart';
import 'package:woo_flutter/models/ProductModelAPI.dart';

List numberOfItems = List<int>();

Future<BaseModel<List<ProductModelAPI>>> getProducts() async {
  List<ProductModelAPI> response;
  try {
    response = await RestClient().getProducts();
    print("Print Response: $response");
  } catch (error, stacktrace) {
    print("Exception occured: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: FutureBuilder<BaseModel<List<ProductModelAPI>>>(
              future: getProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print("Error: " + snapshot.error);
                }
                return snapshot.hasData
                    ? _buildProductsList(context, snapshot.data.data)
                    : Center(child: CircularProgressIndicator());
              },
            ),
          ),
          /*Container(
            height: 60.0,
            color: Theme.of(context).cardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Total: 100",
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textSelectionColor),
                    textAlign: TextAlign.left),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Icon(Icons.shopping_cart), Text("Checkout")],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  _buildProductsList(BuildContext context, List<ProductModelAPI> items) {
    Widget itemCards;
    if (items != null || items.length > 0) {
      itemCards = SizedBox(
        height: MediaQuery.of(context).size.height * 0.80,
        child: ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: items.length,
            itemBuilder: (context, index) {
              String price = items[index].price;
              int stock = items[index].stock_quantity;
              int item_count = 1;
              String image;
              if (items[index].images.length > 0) {
                image = items[index].images.asMap()[0].src;
              } else {
                image =
                    "https://attraitbyaliroy.com/wp-content/uploads/woocommerce-placeholder-300x300.png";
              }
              numberOfItems.add(item_count);
              return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return ProductDetail();
                        },
                      ),
                    );
                  },
                  child: Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 8,
                      child: IntrinsicWidth(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image.network(image,
                                width: 100.0, height: 100.0, fit: BoxFit.cover),
                            Column(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.60,
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    items[index].name,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  child: RatingBarIndicator(
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    rating:
                                        items[index].rating_count.toDouble(),
                                    /*itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),*/
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                                Container(
                                  //width: 140.0,
                                  padding: EdgeInsets.all(2),
                                  child: Text("\$ $price",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )));
            }),
      );
    } else {
      itemCards = Container(
        child: Text('No items'),
      );
    }
    return itemCards;
  }
}
