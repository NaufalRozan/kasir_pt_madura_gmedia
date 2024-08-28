part of 'add_product_bloc.dart';

@freezed
class AddProductEvent with _$AddProductEvent {
  const factory AddProductEvent.addProduct({
    required String categoryId,
    required String name,
    required String price,
    required String picturePath,
  }) = _AddProduct;
}
