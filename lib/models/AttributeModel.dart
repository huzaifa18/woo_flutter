import 'dart:core';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AttributeModel extends Equatable {
  final int id;
  final String name;
  final int position;
  final bool visible;
  final bool variation;

  const AttributeModel(
      {this.id, this.name, this.position, this.visible, this.variation});

  static AttributeModel fromJson(dynamic json) {
    return AttributeModel(
        id: json['id'],
        name: json['name'],
        position: json['position'],
        visible: json['visible'],
        variation: json['variation']);
  }

  @override
  // TODO: implement props
  List<Object> get props => [id, name, position, visible, variation];

  @override
  String toString() =>
      'AttributeModel { id: $id, name: $name, position: $position, visible: $visible, variation: $variation}';
}
