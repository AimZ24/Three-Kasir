import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasirsuper/features/pos/models/cart_item.dart';
import 'package:kasirsuper/features/product/models/product_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final existingItem = state.items.firstWhere(
      (item) => item.product.id == event.product.id,
      orElse: () => CartItem(product: event.product, quantity: 0),
    );

    if (existingItem.quantity == 0) {
      emit(state.copyWith(
        items: List.from(state.items)
          ..add(CartItem(product: event.product, quantity: 1)),
      ));
    } else {
      _onUpdateQuantity(
        UpdateQuantity(
          productId: event.product.id,
          quantity: existingItem.quantity + 1,
        ),
        emit,
      );
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    emit(state.copyWith(
      items: state.items
          .where((item) => item.product.id != event.productId)
          .toList(),
    ));
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    if (event.quantity <= 0) {
      _onRemoveFromCart(RemoveFromCart(event.productId), emit);
      return;
    }

    emit(state.copyWith(
      items: state.items.map((item) {
        if (item.product.id == event.productId) {
          return item.copyWith(quantity: event.quantity);
        }
        return item;
      }).toList(),
    ));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}