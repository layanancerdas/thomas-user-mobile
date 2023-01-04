import 'package:meta/meta.dart';

@immutable
class TransactionState {
  TransactionState(
      {this.selectedPaymentMethod,
      this.paymentMethod,
      this.balances,
      this.useBalance});

  final Map selectedPaymentMethod;
  final List paymentMethod;
  final int balances;
  final bool useBalance;

  factory TransactionState.initial() {
    return TransactionState(
      selectedPaymentMethod: {},
      paymentMethod: [],
      balances: 0,
      useBalance: false,
    );
  }

  TransactionState copyWith({
    Map selectedPaymentMethod,
    List paymentMethod,
    int balances,
    bool useBalance,
  }) {
    return TransactionState(
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      balances: balances ?? this.balances,
      useBalance: useBalance ?? this.useBalance,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionState &&
          runtimeType == other.runtimeType &&
          selectedPaymentMethod == other.selectedPaymentMethod &&
          paymentMethod == other.paymentMethod &&
          useBalance == other.useBalance &&
          balances == other.balances;

  @override
  int get hashCode =>
      selectedPaymentMethod.hashCode ^
      paymentMethod.hashCode ^
      useBalance.hashCode ^
      balances.hashCode;
}
