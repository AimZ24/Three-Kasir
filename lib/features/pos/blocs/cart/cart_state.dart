part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  
  const CartState({
    this.items = const [],
  });

  double get total => items.fold(
        0,
        (sum, item) => sum + item.totalPrice,
      );

  CartState copyWith({
    List<CartItem>? items,
  }) {
    return CartState(
      items: items ?? this.items,
    );
  }

  @override
  List<Object> get props => [items];
}