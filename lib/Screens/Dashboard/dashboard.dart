import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:woo_flutter/Screens/Account/Account.dart';
import 'package:woo_flutter/Screens/Cart/Cart.dart';
import 'package:woo_flutter/Screens/CategoriesPage/Categories.dart';
import 'package:woo_flutter/Screens/Favourites/Favourites.dart';
import 'package:woo_flutter/Screens/Home/Home.dart';
import 'package:woo_flutter/api/RestClient.dart';
import 'package:woo_flutter/api/ServerError.dart';
import 'package:woo_flutter/constants.dart';
import 'package:woo_flutter/models/BaseModel.dart';
import 'package:woo_flutter/models/CategoryModelAPI.dart';
import 'package:woo_flutter/models/ProductModelAPI.dart';
import '../ProductDetails/product_detail.dart';

void main() => runApp(dashboard());

int _cartItems = 0;
int _selectedIndex = 0;

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

class dashboard extends StatefulWidget {
  const dashboard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyDashBoardState createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<dashboard> {
  String title = "Woocommerce";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
      body: _body(_selectedIndex),
      drawer: Drawer(
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
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text('Favourite'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Cart'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text('Account'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: kGreyColor,
        onTap: _onItemTapped,
      ),*/
    );
  }

  Widget _body(int index) {
    if (index == 0) {
      return Home();
    } else if (index == 1) {
      return Favourites();
    } else if (index == 2) {
      return CartPage();
    } else if (index == 3) {
      return Account();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _itemBuilder(BuildContext context, int index) {
    String price = products[index]['itemprice'].toString();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.network(products[index]['imageUrl'],
                  width: 140.0, height: 160.0, fit: BoxFit.cover),
              Text(products[index]['title'], textAlign: TextAlign.left),
              Text("\$ $price",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left),
            ],
          ),
        ));
  }

  Widget _buildSearchItem() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      margin: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
            hintText: 'Search for Item', icon: Icon(Icons.search)),
      ),
    );
  }
}
