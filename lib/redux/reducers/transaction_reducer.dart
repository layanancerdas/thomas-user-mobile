import 'package:redux/redux.dart';
import 'package:tomas/redux/actions/transaction_action.dart';
import 'package:tomas/redux/modules/transaction_state.dart';

final transactionReducer = combineReducers<TransactionState>([
  TypedReducer<TransactionState, dynamic>(_setTransactionState),
]);

TransactionState _setTransactionState(TransactionState state, dynamic action) {
  if (action is SetPaymentMethod) {
    return state.copyWith(paymentMethod: action.paymentMethod);
  } else if (action is SetSelectedPaymentMethod) {
    return state.copyWith(selectedPaymentMethod: action.selectedPaymentMethod);
  } else if (action is SetBalances) {
    return state.copyWith(balances: action.balances);
  } else if (action is UseBalance) {
    state.copyWith(useBalance: !state.useBalance);
  }
  return state;
}
