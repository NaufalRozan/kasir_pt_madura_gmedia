import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../../data/models/cart_item/cart_item.dart';

part 'cart_item_event.dart';
part 'cart_item_state.dart';
part 'cart_item_bloc.freezed.dart';

class CartItemBloc extends HydratedBloc<CartItemEvent, CartItemState> {
  CartItemBloc() : super(const CartItemState.initial()) {
    on<_AddToCart>((event, emit) {
      final currentState = state;
      if (currentState is CartLoaded) {
        final updatedCartItems = List<CartItem>.from(currentState.cartItems);
        final existingItemIndex = updatedCartItems.indexWhere(
          (item) => item.product.id == event.item.product.id,
        );

        if (existingItemIndex != -1) {
          updatedCartItems[existingItemIndex] =
              updatedCartItems[existingItemIndex].copyWith(
            quantity: updatedCartItems[existingItemIndex].quantity + 1,
          );
        } else {
          updatedCartItems.add(event.item);
        }

        emit(CartItemState.cartLoaded(updatedCartItems));
      } else {
        emit(CartItemState.cartLoaded([event.item]));
      }
    });

    on<_RemoveFromCart>((event, emit) {
      final currentState = state;
      if (currentState is CartLoaded) {
        final updatedCartItems = currentState.cartItems
            .where((item) => item.product.id != event.item.product.id)
            .toList();

        emit(CartItemState.cartLoaded(updatedCartItems));
      }
    });

    on<_ClearCart>((event, emit) {
      emit(const CartItemState.cartLoaded([]));
    });

    // Tambahkan handler untuk increase dan decrease quantity
    on<_IncreaseQuantity>((event, emit) {
      final currentState = state;
      if (currentState is CartLoaded) {
        final updatedCartItems = currentState.cartItems.map((item) {
          if (item.product.id == event.item.product.id) {
            return item.copyWith(quantity: item.quantity + 1);
          }
          return item;
        }).toList();
        emit(CartItemState.cartLoaded(updatedCartItems));
      }
    });

    on<_DecreaseQuantity>((event, emit) {
      final currentState = state;
      if (currentState is CartLoaded) {
        final updatedCartItems = currentState.cartItems.map((item) {
          if (item.product.id == event.item.product.id && item.quantity > 1) {
            return item.copyWith(quantity: item.quantity - 1);
          }
          return item;
        }).toList();
        emit(CartItemState.cartLoaded(updatedCartItems));
      }
    });
  }

  @override
  CartItemState? fromJson(Map<String, dynamic> json) {
    return CartItemState.cartLoaded(
      (json['cartItems'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic>? toJson(CartItemState state) {
    if (state is CartLoaded) {
      return {
        'cartItems': state.cartItems.map((item) => item.toJson()).toList(),
      };
    }
    return null;
  }
}
