import 'dart:io';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:woo_flutter/models/CategoryModelAPI.dart';
import 'dart:convert';
import 'package:woo_flutter/models/ProductModelAPI.dart';

part 'RestClient.g.dart';

@RestApi(baseUrl: "https://attraitbyaliroy.com/wp-json/wc/v3/")
abstract class RestClient {
  factory RestClient() {
    final baseUrl = "https://attraitbyaliroy.com/wp-json/wc/v3/";
    final dio = Dio();
    final username = "ck_98b6eab814a899b40dc1f053d78c078fd6eaca56";
    final password = 'cs_780fc1177627485e46c6383d14b49ab422a06a32';
    dio.options = BaseOptions(receiveTimeout: 5000, connectTimeout: 5000);
    dio.options.headers[HttpHeaders.contentTypeHeader] = "application/json";
    dio.options.headers[HttpHeaders.acceptHeader] = "application/json";
    dio.options.headers[HttpHeaders.authorizationHeader] =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return _RestClient(dio, baseUrl: baseUrl);
  }

  @GET("products/categories?per_page=100")
  Future<List<CategoryModelAPI>> getCategories();

  @GET("products?per_page=100")
  Future<List<ProductModelAPI>> getProducts();

  @GET("products?")
  Future<List<ProductModelAPI>> getProductByID(@Query("id") int productId);

  @GET("products?")
  Future<List<ProductModelAPI>> getProductsbyCategoryId(
      @Query("category") int categoryId);
}
