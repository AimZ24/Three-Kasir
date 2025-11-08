// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      barcode: json['barcode'] as String?,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      trackStock: json['trackStock'] as bool? ?? false,
      status: $enumDecodeNullable(_$ProductStatusEnumMap, json['status']) ??
          ProductStatus.active,
      minStock: (json['minStock'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'barcode': instance.barcode,
      'stock': instance.stock,
      'trackStock': instance.trackStock,
      'status': _$ProductStatusEnumMap[instance.status]!,
      'minStock': instance.minStock,
    };

const _$ProductStatusEnumMap = {
  ProductStatus.active: 'active',
  ProductStatus.inactive: 'inactive',
  ProductStatus.outOfStock: 'outOfStock',
};
