part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactions extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final TransactionModel transaction;

  const AddTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class UpdateTransactionStatus extends TransactionEvent {
  final String transactionId;
  final TransactionStatus status;

  const UpdateTransactionStatus({
    required this.transactionId,
    required this.status,
  });

  @override
  List<Object> get props => [transactionId, status];
}