import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woo_flutter/Screens/Home/Home.dart';
import 'package:woo_flutter/Screens/ProductDetails/details_screen.dart';
import 'package:woo_flutter/Screens/ProductDetails/product_detail.dart';
import 'package:woo_flutter/api/RestClient.dart';
import 'package:woo_flutter/api/ServerError.dart';
import 'package:woo_flutter/models/BaseModel.dart';
import 'package:woo_flutter/models/CategoryModelAPI.dart';
import 'package:woo_flutter/models/ProductModelAPI.dart';

const String _loremIpsumParagraph =
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

const double _fabDimension = 56.0;

Future<BaseModel<List<ProductModelAPI>>> getProductsByCategory(int id) async {
  List<ProductModelAPI> response;
  try {
    response = await RestClient().getProductsbyCategoryId(id);
    logger.e("Log Response: " + response.toString());
    print("Print Response: $response");
  } catch (error, stacktrace) {
    print("Exception occured: $error stackTrace: $stacktrace");
    return BaseModel()..setException(ServerError.withError(error: error));
  }
  return BaseModel()..data = response;
}

ContainerTransitionType _transitionType = ContainerTransitionType.fade;
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

void _showMarkedAsDoneSnackbar(bool isMarkedAsDone) {
  if (isMarkedAsDone ?? false)
    scaffoldKey.currentState.showSnackBar(const SnackBar(
      content: Text('Marked as done!'),
    ));
}

class ProductByCategory extends StatefulWidget {
  @override
  _ProductByCategoryState createState() {
    return _ProductByCategoryState();
  }
}

class _ProductByCategoryState extends State<ProductByCategory> {
  void _showSettingsBottomModalSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 125,
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Fade mode',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 12),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(2.0),
                    selectedBorderColor: Theme.of(context).colorScheme.primary,
                    onPressed: (int index) {
                      setModalState(() {
                        setState(() {
                          _transitionType = index == 0
                              ? ContainerTransitionType.fade
                              : ContainerTransitionType.fadeThrough;
                        });
                      });
                    },
                    isSelected: <bool>[
                      _transitionType == ContainerTransitionType.fade,
                      _transitionType == ContainerTransitionType.fadeThrough,
                    ],
                    children: const <Widget>[
                      Text('FADE'),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('FADE THROUGH'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsBottomModalSheet(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          const SizedBox(height: 16.0),
          /*Row(
            children: <Widget>[
              Expanded(
                child: _OpenContainerWrapper(
                  transitionType: _transitionType,
                  closedBuilder: (BuildContext _, VoidCallback openContainer) {
                    return _SmallerCard(
                      openContainer: openContainer,
                      subtitle: 'Secondary text',
                    );
                  },
                  onClosed: _showMarkedAsDoneSnackbar,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _OpenContainerWrapper(
                  transitionType: _transitionType,
                  closedBuilder: (BuildContext _, VoidCallback openContainer) {
                    return _SmallerCard(
                      openContainer: openContainer,
                      subtitle: 'Secondary text',
                    );
                  },
                  onClosed: _showMarkedAsDoneSnackbar,
                ),
              ),
            ],
          ),*/
          Column(children: <Widget>[
            Container(
              child: FutureBuilder<BaseModel<List<ProductModelAPI>>>(
                future: getProductsByCategory(239),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print("Error: " + snapshot.error);
                  }
                  return snapshot.hasData
                      ? _buildProductsList(snapshot.data.data, context)
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ]),
        ],
      ),
      floatingActionButton: OpenContainer(
        transitionType: _transitionType,
        openBuilder: (BuildContext context, VoidCallback _) {
          return const _DetailsPage(
            includeMarkAsDoneButton: false,
          );
        },
        closedElevation: 8.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_fabDimension / 2),
          ),
        ),
        closedColor: Theme.of(context).colorScheme.secondary,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return SizedBox(
            height: _fabDimension,
            width: _fabDimension,
            child: Center(
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildProductsList(List<ProductModelAPI> items, BuildContext context) {
  Widget itemCards;
  if (items != null || items.length > 0) {
    itemCards = GridView.count(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      childAspectRatio: 0.75,
      crossAxisCount: 2,
      children: List.generate(items.length, (index) {
        return GestureDetector(
          child: Row(children: [
            const SizedBox(width: 8.0),
            Expanded(
              child: _OpenContainerWrapper(
                transitionType: _transitionType,
                closedBuilder: (BuildContext _, VoidCallback openContainer) {
                  return _SmallerCard(
                    product: items[index],
                    openContainer: openContainer,
                  );
                },
                onClosed: _showMarkedAsDoneSnackbar,
                id: items[index],
              ),
            )
          ]),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return ProductByCategory();
                },
              ),
            );
          },
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

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    this.closedBuilder,
    this.transitionType,
    this.onClosed,
    this.id,
  });

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool> onClosed;
  final ProductModelAPI id;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return Details(id);
      },
      onClosed: onClosed,
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}

class _InkWellOverlay extends StatelessWidget {
  const _InkWellOverlay({
    this.openContainer,
    this.width,
    this.height,
    this.child,
  });

  final VoidCallback openContainer;
  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: InkWell(
        onTap: openContainer,
        child: child,
      ),
    );
  }
}

class _SmallerCard extends StatelessWidget {
  const _SmallerCard({
    this.product,
    this.openContainer,
  });

  final VoidCallback openContainer;
  final ProductModelAPI product;

  @override
  Widget build(BuildContext context) {
    String image;
    if (product.images.length > 0) {
      image = product.images.asMap()[0].src;
    } else {
      image =
          "https://attraitbyaliroy.com/wp-content/uploads/woocommerce-placeholder-300x300.png";
    }
    return _InkWellOverlay(
      openContainer: openContainer,
      height: 225,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 160,
            child: Center(
              child: Image.network(image,
                  width: 160.0, height: 160.0, fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.name,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.price,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsPage extends StatelessWidget {
  const _DetailsPage({this.includeMarkAsDoneButton = true});

  final bool includeMarkAsDoneButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details page'),
        actions: <Widget>[
          if (includeMarkAsDoneButton)
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () => Navigator.pop(context, true),
              tooltip: 'Mark as done',
            )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.black38,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(70.0),
              child: Image.asset(
                'assets/placeholder_image.png',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Title',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.black54,
                        fontSize: 30.0,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  _loremIpsumParagraph,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.black54,
                        height: 1.5,
                        fontSize: 16.0,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
