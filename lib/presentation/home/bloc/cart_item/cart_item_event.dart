part of 'cart_item_bloc.dart';

@freezed
class CartItemEvent with _$CartItemEvent {
  const factory CartItemEvent.addToCart(CartItem item) = _AddToCart;
  const factory CartItemEvent.removeFromCart(CartItem item) = _RemoveFromCart;
  const factory CartItemEvent.clearCart() = _ClearCart;
  const factory CartItemEvent.increaseQuantity(CartItem item) =
      _IncreaseQuantity; // Tambahkan ini
  const factory CartItemEvent.decreaseQuantity(CartItem item) =
      _DecreaseQuantity; // Tambahkan ini
}
