part of 'get_product_bloc.dart';

@freezed
class GetProductState with _$GetProductState {
  const factory GetProductState.initial() = _Initial;
  const factory GetProductState.loading() = _Loading;
  const factory GetProductState.success(ProductResponseModel data) = _Success;
  const factory GetProductState.error(String message) = _Error;
}
