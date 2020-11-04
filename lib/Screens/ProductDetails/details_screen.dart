import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:woo_flutter/Screens/Account/Account.dart';
import 'package:woo_flutter/Screens/Cart/Cart.dart';
import 'package:woo_flutter/Screens/Favourites/Favourites.dart';
import 'package:woo_flutter/Screens/Home/Home.dart';
import 'package:woo_flutter/api/RestClient.dart';
import 'package:woo_flutter/api/ServerError.dart';
import 'package:woo_flutter/models/BaseModel.dart';
import 'package:woo_flutter/models/Cart.dart';
import 'package:woo_flutter/models/ImageModel.dart';
import 'package:woo_flutter/models/ProductModelAPI.dart';

import '../../constants.dart';

const String _loremIpsumLong =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod '
    'tempor incididunt ut labore et dolore magna aliqua. Vulputate dignissim '
    'suspendisse in est. Ut ornare lectus sit amet. Eget nunc lobortis mattis '
    'aliquam faucibus purus in. Hendrerit gravida rutrum quisque non tellus '
    'orci ac auctor. Mattis aliquam faucibus purus in massa. Tellus rutrum '
    'tellus pellentesque eu tincidunt tortor. Nunc eget lorem dolor sed. Nulla '
    'at volutpat diam ut venenatis tellus in metus. Tellus cras adipiscing enim '
    'eu turpis. Pretium fusce id velit ut tortor. Adipiscing enim eu turpis '
    'egestas pretium. Quis varius quam quisque id. Blandit aliquam etiam erat '
    'velit scelerisque. In nisl nisi scelerisque eu. Semper risus in hendrerit '
    'gravida rutrum quisque. Suspendisse in est ante in nibh mauris cursus '
    'mattis molestie. Adipiscing elit duis tristique sollicitudin nibh sit '
    'amet commodo nulla. Pretium viverra suspendisse potenti nullam ac tortor '
    'vitae.\n'
    '\n'
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod ';

const String _loremIpsumShort =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod '
    'tempor incididunt ut labore et dolore magna aliqua. Vulputate dignissim '
    'vitae.\n'
    '\n'
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod ';

ProductModelAPI product = null;
int _cartItems = 0;
int _selectedIndex = 0;
int _currentIndex = 0;
int review_count = 0;

List<String> imagesList = [];

final List carousalImages = map<Widget>(
  imagesList,
  (index, i) {
    print('Image URL Carousal: ${imagesList[index]}');
    _currentIndex = index;
    return Container(
      margin: EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
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
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
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

Future<BaseModel<List<ProductModelAPI>>> getProductByID(int productId) async {
  List<ProductModelAPI> response;
  try {
    response = await RestClient().getProductByID(productId);
    logger.e("Log Response: " + response.toString());
    print("Print Response: $response");
  } catch (error, stacktrace) {
    print("Exception occured: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

class Details extends StatefulWidget {
  const Details(this.product, {Key key, this.title}) : super(key: key);

  final String title;
  final ProductModelAPI product;

  @override
  _DetailsState createState() => _DetailsState(product);
}

class _DetailsState extends State<Details> {
  String title = "Product Details";

  _DetailsState(this.pid);

  final ProductModelAPI pid;

  String _saleprice;
  String _regularprice;

  @override
  Widget build(BuildContext context) {
    product = pid;
    imagesList.clear();
    for (ImageModel img in product.images) {
      print('Image URL: ${img.src}');
      imagesList.add(img.src);
    }

    if (product.on_sale){
      _saleprice = product.sale_price;
      _regularprice = "";
    } else {
      _regularprice = product.regular_price;
      _saleprice = product.regular_price;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title + ": $product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          ),
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.0, top: 6.0),
            child: Badge(
              position: BadgePosition.topEnd(),
              badgeColor: kPrimaryLightColor,
              badgeContent: Text('$_cartItems'),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: Stack(children: [
        Container(
            //alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
              CarouselSlider.builder(
                itemCount: imagesList.length,
                  itemBuilder: (BuildContext context, int index) =>
                      Container(
                        child: Image.network(imagesList[index]),
                      ),
                  options: CarouselOptions(
                      autoPlay: false,
                      aspectRatio: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      })),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(
                  imagesList,
                  (index, url) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4)),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.0),
                  color: Theme.of(context).canvasColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        "${product.name}",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        "\$ $_saleprice",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    _saleWidget(),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(8),
                      child: RatingBarIndicator(
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 20.0,
                        rating: 3.5,
                        //items[index].rating_count.toDouble(),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(8),
                      child: Html(
                        data: "${product.short_description}",
                        /*style: Theme.of(context).textTheme.bodyText2,*/
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.0),
                  color: Theme.of(context).canvasColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Variations",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18.0,
                            )),
                        const SizedBox(width: 10.0),
                        Text("Color, Size"),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    /*Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Categories();
                            },
                          ));*/
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.0,
                                    color: kPrimaryColor,
                                  )),
                            ]),
                      ],
                    ),
                    Row(
                      children: [
                        Image.network(
                            "https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-04/bg23-768x406.png",
                            fit: BoxFit.cover,
                            width: 60.0),
                        const SizedBox(width: 8),
                        Image.network(
                            "https://attraitbyaliroy.com/wp-content/uploads/revslider/kuteshop-opt-04/bg31-768x406.png",
                            fit: BoxFit.cover,
                            width: 60.0),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.0),
                  color: Theme.of(context).canvasColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Specifications",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18.0,
                            )),
                        const SizedBox(width: 10.0),
                        Text(
                          "Brand, Quality, Type...",
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    /*Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Categories();
                            },
                          ));*/
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.0,
                                    color: kPrimaryColor,
                                  )),
                            ]),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.0),
                  color: Theme.of(context).canvasColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Ratings & Reviews ($review_count)",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18.0,
                            )),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    /*Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Categories();
                            },
                          ));*/
                                  },
                                  child: Text(
                                    'View All',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: kPrimaryLightColor,
                                    ),
                                  )),
                            ]),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.0),
                  color: Theme.of(context).canvasColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Questions about products ($review_count)",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18.0,
                            )),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    /*Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Categories();
                            },
                          ));*/
                                  },
                                  child: Text(
                                    'View All',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: kPrimaryLightColor,
                                    ),
                                  )),
                            ]),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.0),
                  color: Theme.of(context).canvasColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Description: ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                        )),
                    const SizedBox(height: 8),
                    Html(data: '${product.description}'),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.0),
                  color: Theme.of(context).canvasColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Recommended Products",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                        )),
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
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.0),
                  color: Theme.of(context).canvasColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("People who viewed this item also viewed",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                        )),
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
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.0),
                  color: Theme.of(context).canvasColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Best Sellers",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                        )),
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
                  ],
                ),
              ),
            ]))),
        Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              height: 50,
              width: double.maxFinite,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  color: kGreyColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0))),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton.icon(
                      splashColor: kPrimaryLightColor,
                      color: kPrimaryColor,
                      onPressed: () {
                        print('Add to Cart Button Clicked.');
                        var attrId = 0;
                        if (product.attributes.length > 0) {
                          attrId = product.attributes[0].id;
                        }
                        _addtoCart(Cart(
                            quantity: 1, productId: product.id, attributeId: attrId));
                      },
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white),
                      )),
                  RaisedButton.icon(
                      splashColor: kPrimaryLightColor,
                      color: kPrimaryDarkColor,
                      onPressed: () {
                        //_addToCart(cart);
                        print('Buy Now Button Clicked.');
                      },
                      icon: Icon(
                        Icons.business_center,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Buy Now',
                        style: TextStyle(color: Colors.white),
                      )),
                  /*Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 8,
                  child: Container(
                    child: Row(
                      children: [

                      ],
                    ),
                  )),*/
                  /*IconButton(
                icon: Icon(Icons.arrow_downward),
                onPressed: () {},
              ),*/
                ],
              ),
            ))
      ]),
      /*drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/icons/user.png",
                    height: 35,
                    width: 35,
                  ),
                  SizedBox(height: 10),
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.white))
                ],
              ),
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite_border),
              title: Text('Favourites'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Cart'),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.star_border),
              title: Text('My Orders'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categories'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About Us'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.import_contacts),
              title: Text('Terms and Conditions'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.phone_android),
              title: Text('Contact Us'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: GlobalKey(),
        index: _selectedIndex,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.favorite_border, color: Colors.white, size: 30),
          Icon(Icons.shopping_cart, color: Colors.white, size: 30),
          Icon(Icons.person_outline, color: Colors.white, size: 30),
        ],
        backgroundColor: Theme.of(context).bottomAppBarColor,
        color: Theme.of(context).primaryColor,
        animationCurve: Curves.easeOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),*/
    );
  }

  _saleWidget() {
    if (product.on_sale) {
      return Row(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(8),
            child: Text(
              "\$ $_regularprice",
              style: TextStyle(
                  decoration: TextDecoration.lineThrough),
            ),
          ),
          const SizedBox(width: 24),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(8),
            child: Text(
              "\- \% 5",
            ),
          ),
        ],
      );
    } else {
      return Row(children: [],);
    }
  }
}

_buildProductsList(List<ProductModelAPI> items) {
  Widget itemCards;
  if (items != null || items.length > 0) {
    itemCards = SizedBox(
      //width: 210.0,
      height: 150.0,
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
                        return Details(items[index]);
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
                          width: 80.0, height: 80.0, fit: BoxFit.cover),
                      Container(
                        width: 80.0,
                        padding: EdgeInsets.all(2),
                        child: Text(
                          items[index].name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 80.0,
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

void _addtoCart(Cart cart) async {
  print('cart item id: ${cart.productId}');
  final id = await dbHelper.addtoCart(cart);
  print('item added to cart: $id');
}
