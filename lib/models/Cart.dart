import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Cart extends Equatable {
  final int id;
  final int quantity;
  final int productId;
  final int attributeId;

  const Cart({
    this.id,
    this.quantity,
    this.productId,
    this.attributeId,
  });

  static Cart fromJson(Map<String, dynamic> json) {
    return Cart(
        id: json['id'],
        quantity: json['quantity'],
        productId: json['productId'],
        attributeId: json['attributeId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'productId': productId,
      'attributeId': attributeId
    };
  }

  @override
  String toString() {
    return 'Cart{id: $id, quantity: $quantity ,productId: $productId, attributeId: $attributeId}';
  }

  @override
  // TODO: implement props
  List<Object> get props => [id, quantity, productId, attributeId];
}
