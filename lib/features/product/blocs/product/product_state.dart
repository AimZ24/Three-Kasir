part of 'product_bloc.dart';

class ProductState extends Equatable {
  final List<ProductModel> products;
  final Status status;
  final String? error;

  const ProductState({
    this.products = const [],
    this.status = Status.initial,
    this.error,
  });

  ProductState copyWith({
    List<ProductModel>? products,
    Status? status,
    String? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [products, status, error];
}