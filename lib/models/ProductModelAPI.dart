import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:woo_flutter/models/AttributeModel.dart';
import 'package:woo_flutter/models/CategoryModelAPI.dart';
import 'package:woo_flutter/models/Dimensions.dart';
import 'package:woo_flutter/models/ImageModel.dart';
import 'package:woo_flutter/models/LinksModel.dart';

@JsonSerializable()
class ProductModelAPI extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String permalink;
  final String date_created;
  final String date_created_gmt;
  final String date_modified;
  final String date_modified_gmt;
  final String type;
  final String status;
  final bool featured;
  final String catalog_visibility;
  final String description;
  final String short_description;
  final String sku;
  final String price;
  final String regular_price;
  final String sale_price;
  final String date_on_sale_from;
  final String date_on_sale_from_gmt;
  final String date_on_sale_to;
  final String date_on_sale_to_gmt;
  final String price_html;
  final bool on_sale;
  final bool purchasable;
  final int total_sales;
  final bool virtual;
  final bool downloadable;
  final List<String> downloads;
  final int download_limit;
  final int download_expiry;
  final String external_url;
  final String button_text;
  final String tax_status;
  final String tax_class;
  final bool manage_stock;
  final int stock_quantity;
  final String stock_status;
  final String backorders;
  final bool backorders_allowed;
  final bool backordered;
  final bool sold_individually;
  final String weight;

  //final Dimensions dimensions;
  final bool shipping_required;
  final bool shipping_taxable;
  final String shipping_class;
  final int shipping_class_id;
  final bool reviews_allowed;
  final String average_rating;
  final int rating_count;
  final List<int> related_ids;
  final List<int> upsell_ids;
  final List<int> cross_sell_ids;
  final int parent_id;
  final String purchase_note;
  final List<CategoryModelAPI> categories;

  //final List<String> tags;
  final List<ImageModel> images;

  final List<AttributeModel> attributes;
  final List<AttributeModel> default_attributes;
  final List<int> variations;
  final List<int> grouped_products;
  final int menu_order;

  /*var meta_data: Array<MetaData>,*/
  //final LinksModel links;

  const ProductModelAPI({
    this.id,
    this.name,
    this.slug,
    this.permalink,
    this.date_created,
    this.date_created_gmt,
    this.date_modified,
    this.date_modified_gmt,
    this.type,
    this.status,
    this.featured,
    this.catalog_visibility,
    this.description,
    this.short_description,
    this.sku,
    this.price,
    this.regular_price,
    this.sale_price,
    this.date_on_sale_from,
    this.date_on_sale_from_gmt,
    this.date_on_sale_to,
    this.date_on_sale_to_gmt,
    this.price_html,
    this.on_sale,
    this.purchasable,
    this.total_sales,
    this.virtual,
    this.downloadable,
    this.downloads,
    this.download_limit,
    this.download_expiry,
    this.external_url,
    this.button_text,
    this.tax_status,
    this.tax_class,
    this.manage_stock,
    this.stock_quantity,
    this.stock_status,
    this.backorders,
    this.backorders_allowed,
    this.backordered,
    this.sold_individually,
    this.weight,
    //this.dimensions,
    this.shipping_required,
    this.shipping_taxable,
    this.shipping_class,
    this.shipping_class_id,
    this.reviews_allowed,
    this.average_rating,
    this.rating_count,
    this.related_ids,
    this.upsell_ids,
    this.cross_sell_ids,
    this.parent_id,
    this.purchase_note,
    this.categories,
    this.images,
    this.attributes,
    this.default_attributes,
    this.variations,
    this.grouped_products,
    this.menu_order,
    //this.links
  });

  static ProductModelAPI fromJson(Map<String, dynamic> json) {
    var listCat = json['categories'] as List;
    List<CategoryModelAPI> categoryList =
        listCat.map((i) => CategoryModelAPI.fromJson(i)).toList();
    var listImage = json['images'] as List;
    List<ImageModel> imagesList =
        listImage.map((i) => ImageModel.fromJson(i)).toList();
    var listAttribute = json['attributes'] as List;
    List<AttributeModel> attributesList =
        listAttribute.map((i) => AttributeModel.fromJson(i)).toList();
    var listDefaultAttr = json['default_attributes'] as List;
    List<AttributeModel> defaultAttrList =
        listDefaultAttr.map((i) => AttributeModel.fromJson(i)).toList();
    return ProductModelAPI(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      permalink: json['permalink'],
      date_created: json['date_created'],
      date_created_gmt: json['date_created_gmt'],
      date_modified: json['date_modified'],
      date_modified_gmt: json['date_modified_gmt'],
      type: json['type'],
      status: json['status'],
      featured: json['featured'],
      catalog_visibility: json['catalog_visibility'],
      description: json['description'],
      short_description: json['short_description'],
      sku: json['sku'],
      price: json['price'],
      regular_price: json['regular_price'],
      sale_price: json['sale_price'],
      date_on_sale_from: json['date_on_sale_from'],
      date_on_sale_from_gmt: json['date_on_sale_from_gmt'],
      date_on_sale_to: json['date_on_sale_to'],
      date_on_sale_to_gmt: json['date_on_sale_to_gmt'],
      price_html: json['price_html'],
      on_sale: json['on_sale'],
      purchasable: json['purchasable'],
      total_sales: json['total_sales'],
      virtual: json['virtual'],
      downloadable: json['downloadable'],
      downloads: json['downloads'].cast<String>(),
      download_limit: json['download_limit'],
      download_expiry: json['download_expiry'],
      external_url: json['external_url'],
      button_text: json['button_text'],
      tax_status: json['tax_status'],
      tax_class: json['tax_class'],
      manage_stock: json['manage_stock'],
      stock_quantity: json['stock_quantity'],
      stock_status: json['stock_status'],
      backorders: json['backorders'],
      backorders_allowed: json['backorders_allowed'],
      backordered: json['backordered'],
      sold_individually: json['sold_individually'],
      weight: json['weight'],
      //dimensions: json['dimensions'],
      shipping_required: json['shipping_required'],
      shipping_taxable: json['shipping_taxable'],
      shipping_class: json['shipping_class'],
      shipping_class_id: json['shipping_class_id'],
      reviews_allowed: json['reviews_allowed'],
      average_rating: json['average_rating'],
      rating_count: json['rating_count'],
      related_ids: json['related_ids'].cast<int>(),
      upsell_ids: json['upsell_ids'].cast<int>(),
      cross_sell_ids: json['cross_sell_ids'].cast<int>(),
      parent_id: json['parent_id'],
      purchase_note: json['purchase_note'],
      categories: categoryList,
      images: imagesList,
      attributes: attributesList,
      default_attributes: defaultAttrList,
      variations: json['variations'].cast<int>(),
      grouped_products: json['grouped_products'].cast<int>(),
      menu_order: json['menu_order'],
      /*links: json['links']*/
    );
  }

  @override
  String toString() {
    return 'ProductModelAPI{id: $id, name: $name, slug: $slug, permalink: $permalink, date_created: $date_created, date_created_gmt: $date_created_gmt, date_modified: $date_modified, date_modified_gmt: $date_modified_gmt, type: $type, status: $status, featured: $featured, catalog_visibility: $catalog_visibility, description: $description, short_description: $short_description, sku: $sku, price: $price, regular_price: $regular_price, sale_price: $sale_price, date_on_sale_from: $date_on_sale_from, date_on_sale_from_gmt: $date_on_sale_from_gmt, date_on_sale_to: $date_on_sale_to, date_on_sale_to_gmt: $date_on_sale_to_gmt, price_html: $price_html, on_sale: $on_sale, purchasable: $purchasable, total_sales: $total_sales, virtual: $virtual, downloadable: $downloadable, downloads: $downloads, download_limit: $download_limit, download_expiry: $download_expiry, external_url: $external_url, button_text: $button_text, tax_status: $tax_status, tax_class: $tax_class, manage_stock: $manage_stock, stock_quantity: $stock_quantity, stock_status: $stock_status, backorders: $backorders, backorders_allowed: $backorders_allowed, backordered: $backordered, sold_individually: $sold_individually, weight: $weight, shipping_required: $shipping_required, shipping_taxable: $shipping_taxable, shipping_class: $shipping_class, shipping_class_id: $shipping_class_id, reviews_allowed: $reviews_allowed, average_rating: $average_rating, rating_count: $rating_count, related_ids: $related_ids, upsell_ids: $upsell_ids, cross_sell_ids: $cross_sell_ids, parent_id: $parent_id, purchase_note: $purchase_note, variations: $variations, grouped_products: $grouped_products, menu_order: $menu_order}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'permalink': permalink,
      'date_created': date_created,
      'date_created_gmt': date_created_gmt,
      'date_modified': date_modified,
      'date_modified_gmt': date_modified_gmt,
      'type': type,
      'status': status,
      'featured': featured,
      'catalog_visibility': catalog_visibility,
      'description': description,
      'short_description': short_description,
      'sku': sku,
      'price': price,
      'regular_price': regular_price,
      'sale_price': sale_price,
      'date_on_sale_from': date_on_sale_from,
      'date_on_sale_from_gmt': date_on_sale_from_gmt,
      'date_on_sale_to': date_on_sale_to,
      'date_on_sale_to_gmt': date_on_sale_to_gmt,
      'price_html': price_html,
      'on_sale': on_sale,
      'purchasable': purchasable,
      'total_sales': total_sales,
      'virtual': virtual,
      'downloadable': downloadable,

      'download_limit': download_limit,
      'download_expiry': download_expiry,
      'external_url': external_url,
      'button_text': button_text,
      'tax_status': tax_status,
      'tax_class': tax_class,
      'manage_stock': manage_stock,
      'stock_quantity': stock_quantity,
      'stock_status': stock_status,
      'backorders': backorders,
      'backorders_allowed': backorders_allowed,
      'backordered': backordered,
      'sold_individually': sold_individually,
      'weight': weight,
      'shipping_required': shipping_required,
      'shipping_taxable': shipping_taxable,
      'shipping_class': shipping_class,
      'shipping_class_id': shipping_class_id,
      'reviews_allowed': reviews_allowed,
      'average_rating': average_rating,
      'rating_count': rating_count,

      'parent_id': parent_id,
      'purchase_note': purchase_note
    };
  }

  @override
  List<Object> get props => [
        id,
        name,
        slug,
        permalink,
        date_created,
        date_created_gmt,
        date_modified,
        date_modified_gmt,
        type,
        status,
        featured,
        catalog_visibility,
        description,
        short_description,
        sku,
        price,
        regular_price,
        sale_price,
        date_on_sale_from,
        date_on_sale_from_gmt,
        date_on_sale_to,
        date_on_sale_to_gmt,
        price_html,
        on_sale,
        purchasable,
        total_sales,
        virtual,
        downloadable,
        downloads,
        download_limit,
        download_expiry,
        external_url,
        button_text,
        tax_status,
        tax_class,
        manage_stock,
        stock_quantity,
        stock_status,
        backorders,
        backorders_allowed,
        backordered,
        sold_individually,
        weight,
        //dimensions,
        shipping_required,
        shipping_taxable,
        shipping_class,
        shipping_class_id,
        reviews_allowed,
        average_rating,
        rating_count,
        related_ids,
        upsell_ids,
        cross_sell_ids,
        parent_id,
        purchase_note,
        /*categories,
        images,
        attributes,
        default_attributes,*/
        variations,
        grouped_products,
        menu_order,
        /*links*/
      ];
}
