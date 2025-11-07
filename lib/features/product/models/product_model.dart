import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

enum ProductStatus {
  active,
  inactive,
  outOfStock
}

@JsonSerializable()
class ProductModel extends Equatable {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final String? description;
  final String? barcode; // Barcode for product
  final int stock; // Stock quantity
  final bool trackStock; // Whether to track stock for this product
  final ProductStatus status; // Product status
  final int? minStock; // Minimum stock threshold for alerts

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.description,
    this.barcode,
    this.stock = 0,
    this.trackStock = false,
    this.status = ProductStatus.active,
    this.minStock,
  });

  // Check if product is available for sale
  bool get isAvailable {
    if (status == ProductStatus.inactive) return false;
    if (trackStock && stock <= 0) return false;
    return true;
  }

  // Check if stock is low
  bool get isLowStock {
    if (!trackStock || minStock == null) return false;
    return stock <= minStock! && stock > 0;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    String? description,
    String? barcode,
    int? stock,
    bool? trackStock,
    ProductStatus? status,
    int? minStock,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      barcode: barcode ?? this.barcode,
      stock: stock ?? this.stock,
      trackStock: trackStock ?? this.trackStock,
      status: status ?? this.status,
      minStock: minStock ?? this.minStock,
    );
  }

  @override
  List<Object?> get props => [id, name, price, imageUrl, description, barcode, stock, trackStock, status, minStock];
}