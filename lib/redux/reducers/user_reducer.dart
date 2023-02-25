import 'package:redux/redux.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/modules/user_state.dart';

final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, dynamic>(_setUserState),
]);

UserState _setUserState(UserState state, dynamic action) {
  if (action is SetUserDetail) {
    return state.copyWith(userDetail: action.userDetail);
  } else if (action is SetMyTrip) {
    return state.copyWith(
        pendingTrip: action.pendingTrip,
        activeTrip: action.activeTrip,
        canceledTrip: action.canceledTrip,
        completedTrip: action.completedTrip);
  } else if (action is SetSelectedMyTrip) {
    return state.copyWith(
        selectedMyTrip: action.selectedMyTrip,
        getSelectedTrip: action.getSelectedTrip);
  } else if (action is SetActiveTrip) {
    return state.copyWith(
        activeTrip: action.activeTrip, limitActiveTrip: action.limitActiveTrip);
  } else if (action is SetCanceledTrip) {
    return state.copyWith(
        canceledTrip: action.canceledTrip,
        limitCanceledTrip: action.limitCanceledTrip);
  } else if (action is SetCompletedTrip) {
    return state.copyWith(
        completedTrip: action.completedTrip,
        limitCompletedTrip: action.limitCompletedTrip);
  } else if (action is SetPendingTrip) {
    return state.copyWith(
        pendingTrip: action.pendingTrip,
        limitPendingTrip: action.limitPendingTrip);
  }
  return state;
}
