part of 'transaction_bloc.dart';

class TransactionState extends Equatable {
  final List<TransactionModel> transactions;
  final Status status;
  final String? error;

  const TransactionState({
    this.transactions = const [],
    this.status = Status.initial,
    this.error,
  });

  TransactionState copyWith({
    List<TransactionModel>? transactions,
    Status? status,
    String? error,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [transactions, status, error];
}