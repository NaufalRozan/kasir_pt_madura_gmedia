part of 'get_product_bloc.dart';

@freezed
class GetProductEvent with _$GetProductEvent {
  const factory GetProductEvent.getProductsByCategory(String categoryId) =
      _GetProductsByCategory;
}
