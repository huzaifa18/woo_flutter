import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woo_flutter/Screens/CategoriesPage/components/background.dart';
import 'package:woo_flutter/Screens/Dashboard/container_transition.dart';
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

class CartPage extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartPage> {
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
          Container(
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
          ),
        ],
      ),
    );
  }

  _buildProductsList(BuildContext context, List<ProductModelAPI> items) {
    Widget itemCards;
    if (items != null || items.length > 0) {
      itemCards = SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
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
                          return OpenContainerTransformDemo();
                        },
                      ),
                    );
                  },
                  child: Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 8,
                      child: IntrinsicWidth(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Image.network(image,
                                width: 100.0, height: 100.0, fit: BoxFit.cover),
                            Column(
                              children: [
                                Container(
                                  width: 180.0,
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    items[index].name,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _incrementButton(index),
                                    Container(
                                        padding: EdgeInsets.only(
                                            left: 4,
                                            right: 4,
                                            top: 1,
                                            bottom: 1),
                                        color: Colors.grey,
                                        child: Text('${numberOfItems[index]}',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center)),
                                    _decrementButton(index),
                                  ],
                                ),
                              ],
                            ),
                            Icon(Icons.delete_outline),
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

  Widget _incrementButton(int index) {
    return Container(
      width: 25,
      height: 25,
      child: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.black87),
        backgroundColor: Colors.white,
        onPressed: () {
          setState(() {
            numberOfItems[index]++;
          });
        },
      ),
    );
  }

  Widget _decrementButton(int index) {
    return Container(
      width: 25,
      height: 25,
      child: FloatingActionButton(
          onPressed: () {
            setState(() {
              numberOfItems[index]--;
            });
            //numberOfItems[index]--;
          },
          child: Icon(const IconData(0xe15b, fontFamily: 'MaterialIcons'),
              color: Colors.black),
          backgroundColor: Colors.white),
    );
  }
}
