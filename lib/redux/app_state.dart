import 'package:meta/meta.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/redux/modules/transaction_state.dart';
import 'package:tomas/redux/modules/user_state.dart';

import 'modules/ajk_state.dart';

@immutable
class AppState {
  final AjkState ajkState;
  final UserState userState;
  final TransactionState transactionState;
  final GeneralState generalState;

  AppState(
      {this.ajkState,
      this.userState,
      this.transactionState,
      this.generalState});

  factory AppState.initial() {
    return AppState(
      ajkState: AjkState.initial(),
      userState: UserState.initial(),
      transactionState: TransactionState.initial(),
      generalState: GeneralState.initial(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          ajkState == other.ajkState &&
          userState == other.userState &&
          transactionState == other.transactionState &&
          generalState == other.generalState;

  @override
  int get hashCode =>
      ajkState.hashCode ^
      userState.hashCode ^
      transactionState.hashCode ^
      generalState.hashCode;
}
