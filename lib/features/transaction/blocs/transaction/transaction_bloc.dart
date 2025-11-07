import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/transaction/models/transaction_model.dart';
import 'package:kasirsuper/features/transaction/data/transaction_storage.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(const TransactionState()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransactionStatus>(_onUpdateTransactionStatus);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  void _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));
      final List<TransactionModel> transactions =
          await TransactionLocalStorage.getTransactions();
      emit(state.copyWith(
        status: Status.success,
        transactions: transactions,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        error: e.toString(),
      ));
    }
  }

  void _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedTransactions = List.of(state.transactions)
        ..add(event.transaction);
      await TransactionLocalStorage.saveTransactions(updatedTransactions);
      emit(state.copyWith(
        status: Status.success,
        transactions: updatedTransactions,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        error: e.toString(),
      ));
    }
  }

  void _onUpdateTransactionStatus(
    UpdateTransactionStatus event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedTransactions = state.transactions.map((transaction) {
        if (transaction.id == event.transactionId) {
          return transaction.copyWith(status: event.status);
        }
        return transaction;
      }).toList();

      await TransactionLocalStorage.saveTransactions(updatedTransactions);
      emit(state.copyWith(
        status: Status.success,
        transactions: updatedTransactions,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        error: e.toString(),
      ));
    }
  }

  void _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));
      
      final updatedTransactions = state.transactions
          .where((transaction) => transaction.id != event.transactionId)
          .toList();
      
      await TransactionLocalStorage.saveTransactions(updatedTransactions);
      emit(state.copyWith(
        status: Status.success,
        transactions: updatedTransactions,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        error: e.toString(),
      ));
    }
  }
}