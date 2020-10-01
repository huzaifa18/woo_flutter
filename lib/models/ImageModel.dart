import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ImageModel extends Equatable {
  final int imageId;
  final int id;
  final String date_created;
  final String date_created_gmt;
  final String date_modified;
  final String date_modified_gmt;
  final String src;
  final String name;
  final String alt;

  const ImageModel(
      {this.imageId,
      this.id,
      this.date_created,
      this.date_created_gmt,
      this.date_modified,
      this.date_modified_gmt,
      this.src,
      this.name,
      this.alt});

  @override
  List<Object> get props => [
        imageId,
        id,
        date_created,
        date_created_gmt,
        date_modified,
        date_modified_gmt,
        src,
        name,
        alt
      ];

  static ImageModel fromJson(dynamic json) {
    return ImageModel(
      id: json['id'],
      date_created: json['date_created'],
      date_created_gmt: json['date_created_gmt'],
      date_modified: json['date_modified'],
      date_modified_gmt: json['date_modified_gmt'],
      src: json['src'],
      name: json['name'],
      alt: json['alt'],
    );
  }

  @override
  String toString() {
    return 'ImageModel{imageId: $imageId, id: $id, date_created: $date_created, date_created_gmt: $date_created_gmt, date_modified: $date_modified, date_modified_gmt: $date_modified_gmt, src: $src, name: $name, alt: $alt}';
  }
}
