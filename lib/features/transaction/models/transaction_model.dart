import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kasirsuper/features/pos/models/cart_item.dart';

part 'transaction_model.g.dart';

enum TransactionStatus {
  pending,
  completed,
  cancelled
}

@JsonSerializable()
class TransactionModel extends Equatable {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double total;
  final TransactionStatus status;
  final String? customerNote;

  const TransactionModel({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    this.status = TransactionStatus.completed,
    this.customerNote,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  TransactionModel copyWith({
    String? id,
    DateTime? date,
    List<CartItem>? items,
    double? total,
    TransactionStatus? status,
    String? customerNote,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      date: date ?? this.date,
      items: items ?? this.items,
      total: total ?? this.total,
      status: status ?? this.status,
      customerNote: customerNote ?? this.customerNote,
    );
  }

  @override
  List<Object?> get props => [id, date, items, total, status, customerNote];
}