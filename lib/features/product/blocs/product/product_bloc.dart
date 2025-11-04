import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/product/data/product_storage.dart';
import 'package:kasirsuper/features/product/models/product_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(const ProductState()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(status: Status.loading));
      
      final List<ProductModel> products = await ProductLocalStorage.getProducts();
      
      emit(state.copyWith(
        status: Status.success,
        products: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        error: e.toString(),
      ));
    }
  }

  void _onAddProduct(AddProduct event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(status: Status.loading));
      
      final List<ProductModel> updatedProducts = List.from(state.products)
        ..add(event.product);
      
      await ProductLocalStorage.saveProducts(updatedProducts);
      
      emit(state.copyWith(
        status: Status.success,
        products: updatedProducts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        error: e.toString(),
      ));
    }
  }

  void _onUpdateProduct(UpdateProduct event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(status: Status.loading));
      
      final List<ProductModel> updatedProducts = state.products.map((product) {
        return product.id == event.product.id ? event.product : product;
      }).toList();
      
      await ProductLocalStorage.saveProducts(updatedProducts);
      
      emit(state.copyWith(
        status: Status.success,
        products: updatedProducts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        error: e.toString(),
      ));
    }
  }

  void _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(status: Status.loading));
      
      final List<ProductModel> updatedProducts = state.products
          .where((product) => product.id != event.productId)
          .toList();
      
      await ProductLocalStorage.saveProducts(updatedProducts);
      
      emit(state.copyWith(
        status: Status.success,
        products: updatedProducts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        error: e.toString(),
      ));
    }
  }
}