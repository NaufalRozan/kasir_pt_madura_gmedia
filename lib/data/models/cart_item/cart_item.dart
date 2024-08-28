import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/models/product_response_model.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart'; // Tambahkan part untuk serialization

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required Datum product,
    required int quantity,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
