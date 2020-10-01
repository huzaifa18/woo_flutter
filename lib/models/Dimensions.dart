import 'dart:core';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Dimensions extends Equatable {
  final String length;
  final String width;
  final String height;

  const Dimensions({
    this.length,
    this.width,
    this.height,
  });

  static Dimensions fromJson(dynamic json) {
    return Dimensions(
        length: json['length'], width: json['width'], height: json['height']);
  }

  @override
  // TODO: implement props
  List<Object> get props => [length, width, height];

  @override
  String toString() =>
      'Dimensions { length: $length, width: $width, height: $height}';
}
