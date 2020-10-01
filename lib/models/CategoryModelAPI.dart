import 'dart:core';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import 'ImageModel.dart';

@JsonSerializable()
class CategoryModelAPI extends Equatable {
  final int id;
  final String name;
  final String slug;
  final int parent;
  final String description;
  final String display;
  final ImageModel image;
  final int menu_order;
  final int count;
  //final LinksModel links;

  const CategoryModelAPI(
      {this.id,
      this.name,
      this.slug,
      this.parent,
      this.description,
      this.display,
      this.image,
      this.menu_order,
      this.count /*,
      this.links*/
      });

  @override
  // TODO: implement props
  List<Object> get props => [
        id,
        name,
        slug,
        parent,
        description,
        display,
        image,
        menu_order,
        count /*,
        links*/
      ];

  static CategoryModelAPI fromJson(Map<String, dynamic> json) {
    return CategoryModelAPI(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      parent: json['parent'],
      description: json['description'],
      //image: ImageModel.fromJson(json['image']),
      menu_order: json['menu_order'],
      count: json['count'],
      //links: json['links'],
    );
  }

  @override
  String toString() =>
      'CategoryModelAPI { id: $id, name: $name, slug: $slug, parent: $parent, description: $description, display: $display, menu_order: $menu_order, count: $count,  }';
}
