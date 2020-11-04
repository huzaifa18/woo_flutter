import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:woo_flutter/models/Cart.dart';
import 'package:woo_flutter/models/ProductModelAPI.dart';

class DatabaseHelper {
  String tableProducts = 'Products';
  String tableCart = 'Cart';

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "WooFlutter.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    await batch.execute('''
              CREATE TABLE if not exists $tableProducts (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                slug TEXT NOT NULL,
                permalink TEXT NOT NULL,
                date_created TEXT NOT NULL,
        date_created_gmt TEXT NOT NULL,
        date_modified TEXT NOT NULL,
        date_modified_gmt TEXT NOT NULL,
        type TEXT NOT NULL,
        status TEXT NOT NULL,
        featured INTEGER NOT NULL,
        catalog_visibility TEXT NOT NULL,
        description TEXT NOT NULL,
        short_description TEXT NOT NULL,
        sku TEXT NOT NULL,
        price TEXT NOT NULL,
        regular_price TEXT NOT NULL,
        sale_price TEXT NOT NULL,
        date_on_sale_from TEXT,
        date_on_sale_from_gmt TEXT,
        date_on_sale_to TEXT,
        date_on_sale_to_gmt TEXT,
        price_html TEXT NOT NULL,
        on_sale INTEGER,
        purchasable INTEGER NOT NULL,
        total_sales INTEGER NOT NULL,
        virtual INTEGER NOT NULL,
        downloadable INTEGER NOT NULL,
        
        download_limit INTEGER NOT NULL,
        download_expiry INTEGER NOT NULL,
        external_url TEXT NOT NULL,
        button_text TEXT NOT NULL,
        tax_status TEXT NOT NULL,
        tax_class TEXT NOT NULL,
        manage_stock INTEGER NOT NULL,
        stock_quantity INTEGER NOT NULL,
        stock_status TEXT NOT NULL,
        backorders TEXT NOT NULL,
        backorders_allowed INTEGER NOT NULL,
        backordered INTEGER NOT NULL,
        sold_individually INTEGER NOT NULL,
        weight TEXT NOT NULL,
        
        shipping_required INTEGER NOT NULL,
        shipping_taxable INTEGER NOT NULL,
        shipping_class TEXT NOT NULL,
        shipping_class_id INTEGER NOT NULL,
        reviews_allowed INTEGER NOT NULL,
        average_rating TEXT NOT NULL,
        rating_count INTEGER NOT NULL,
        
        parent_id INTEGER NOT NULL,
        purchase_note TEXT NOT NULL
              )
              ''');

    await batch.execute('''CREATE TABLE if not exists $tableCart (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                quantity INTEGER NOT NULL,
                productId INTEGER NOT NULL,
                attributeId INTEGER NOT NULL)''');

    List<dynamic> res = await batch.commit();
    //await batch.commit();
  }

  //Database helper methods:
  Future<int> insert(ProductModelAPI product) async {
    Database db = await database;
    int id = await db.insert(tableProducts, product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> addtoCart(Cart cart) async {
    Database db = await database;
    int id = await db.insert(tableCart, cart.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<ProductModelAPI> queryProduct(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableProducts,
        columns: ['id', 'name', 'slug', 'permalink'],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return ProductModelAPI(
        id: maps[0]['id'],
        name: maps[0]['name'],
        slug: maps[0]['slug'],
        permalink: maps[0]['permalink'],
      );
    }
    return null;
  }

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}
