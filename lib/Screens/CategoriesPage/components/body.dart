import 'package:flutter/material.dart';
import 'package:woo_flutter/Screens/CategoriesPage/components/background.dart';
import 'package:woo_flutter/Screens/Dashboard/container_transition.dart';
import 'package:woo_flutter/Screens/Dashboard/dashboard.dart';
import 'package:woo_flutter/api/RestClient.dart';
import 'package:woo_flutter/api/ServerError.dart';
import 'package:woo_flutter/models/BaseModel.dart';
import 'package:woo_flutter/models/CategoryModelAPI.dart';
import 'package:woo_flutter/models/ProductModelAPI.dart';

class Body extends StatelessWidget {
  int categoryID = 239;

  final List products = [
    {
      'title': 'Women',
      'imageUrl':
          'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-04/bg23-768x406.png',
      'itemprice': 50,
      'itemcount': 1,
    },
    {
      'title': 'Necklaces',
      'imageUrl':
          'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-04/bg31-768x406.png',
      'itemprice': 25,
      'itemcount': 1,
    },
    {
      'title': 'Furniture',
      'imageUrl':
          'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-04/bg12-768x406.png',
      'itemprice': 40,
      'itemcount': 2,
    },
    {
      'title': 'Streetwear Skirt',
      'imageUrl':
          'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-01/1-600x405.jpg',
      'itemprice': 30,
      'itemcount': 3,
    },
    {
      'title': 'ABC XYZ',
      'imageUrl':
          'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-01/1-600x405.jpg',
      'itemprice': 50,
      'itemcount': 0,
    },
    {
      'title': 'ST',
      'imageUrl':
          'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-01/1-600x405.jpg',
      'itemprice': 50,
      'itemcount': 0,
    },
    {
      'title': 'PQR',
      'imageUrl':
          'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-01/1-600x405.jpg',
      'itemprice': 40,
      'itemcount': 0,
    },
    {
      'title': 'LMN',
      'imageUrl':
          'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-01/1-600x405.jpg',
      'itemprice': 30,
      'itemcount': 0,
    },
    {
      'title': 'ABC',
      'imageUrl':
          'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-01/1-600x405.jpg',
      'itemprice': 40,
      'itemcount': 0,
    },
    {
      'title': 'XYZ',
      'imageUrl':
          'https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-01/1-600x405.jpg',
      'itemprice': 30,
      'itemcount': 0,
    },
  ];

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

  Future<BaseModel<List<ProductModelAPI>>> getProductsByCatID(
      int categoryId) async {
    List<ProductModelAPI> response;
    try {
      response = await RestClient().getProductsbyCategoryId(categoryId);
      logger.e("Log Response: " + response.toString());
      print("Print Response: $response");
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 80.0,
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
          Container(
              width: MediaQuery.of(context).size.width - 82.0,
              child: FutureBuilder<BaseModel<List<ProductModelAPI>>>(
                future: getProductsByCatID(categoryID),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print("Error: " + snapshot.error);
                  }
                  return snapshot.hasData
                      ? _buildProductsList(snapshot.data.data)
                      : Center(child: CircularProgressIndicator());
                },
              )),
        ],
      ),
    );
  }

  _buildCategoriesList(List<CategoryModelAPI> items) {
    Widget itemCards;
    if (items != null || items.length > 0) {
      itemCards = SizedBox(
        //width: 100.0,
        child: ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  categoryID = items[index].id;
                  print("Category ID: $categoryID");
                  //productsWidget();
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.black26,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.category),
                      Text(items[index].name, textAlign: TextAlign.center)
                    ],
                  ),
                ),
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
      itemCards = GridView.count(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        //childAspectRatio: 1,
        crossAxisCount: 3,
        children: List.generate(items.length, (index) {
          String price = items[index].price;
          String image;
          if (items[index].images.length > 0) {
            image = items[index].images.asMap()[0].src;
          } else {
            image =
                "https://attraitbyaliroy.com/wp-content/uploads/woocommerce-placeholder-300x300.png";
          }
          return GestureDetector(
            child: Card(
              //margin: const EdgeInsets.all(8.0),
              elevation: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.network(image,
                      alignment: Alignment.center,
                      width: 80.0,
                      height: 60.0,
                      fit: BoxFit.cover),
                  Text(
                    items[index].name,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text("\$ $price",
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left),
                ],
              ),
            ),
            onTap: _productClick,
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

  void _productClick() {}
}
