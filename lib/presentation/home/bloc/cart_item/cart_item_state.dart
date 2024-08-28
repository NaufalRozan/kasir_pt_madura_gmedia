part of 'cart_item_bloc.dart';

@freezed
class CartItemState with _$CartItemState {
  const factory CartItemState.initial() = _Initial;
  const factory CartItemState.cartLoaded(List<CartItem> cartItems) = CartLoaded;
}
