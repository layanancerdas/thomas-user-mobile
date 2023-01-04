import 'package:tomas/redux/reducers/general_reducer.dart';

import 'app_state.dart';
import 'reducers/ajk_reducer.dart';
import 'reducers/transaction_reducer.dart';
import 'reducers/user_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    ajkState: ajkReducer(state.ajkState, action),
    userState: userReducer(state.userState, action),
    transactionState: transactionReducer(state.transactionState, action), 
    generalState: generalReducer(state.generalState, action)
  );
}
