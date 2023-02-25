import 'package:redux/redux.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/modules/general_state.dart';

final generalReducer = combineReducers<GeneralState>([
  TypedReducer<GeneralState, dynamic>(_setGeneralState),
]);

GeneralState _setGeneralState(GeneralState state, dynamic action) {
  if (action is SetVouchers) {
    return state.copyWith(
        vouchers: action.vouchers, limitVoucher: action.limitVoucher);
  } else if (action is SetSelectedVoucher) {
    return state.copyWith(selectedVouchers: action.selectedVoucher);
  } else if (action is SetSearchResult) {
    return state.copyWith(searchResult: action.searchResult);
  } else if (action is SetSearchOrigin) {
    return state.copyWith(searchOrigin: action.searchOrigin);
  } else if (action is SetSearchDestination) {
    return state.copyWith(searchDestination: action.searchDestination);
  } else if (action is ExchangeSearch) {
    return state.copyWith(
      searchDestination: state.searchOrigin,
      searchOrigin: state.searchDestination,
    );
  } else if (action is SetDisableNavbar) {
    return state.copyWith(disableNavbar: action.disableNavbar);
  } else if (action is SetSelectedNotification) {
    return state.copyWith(selectedNotification: action.selectedNotification);
  } else if (action is SetNotifications) {
    return state.copyWith(
        notifications: action.notifications, limitNotif: action.limitNotif);
  } else if (action is SetIsLoading) {
    return state.copyWith(isLoading: action.isLoading);
  }
  return state;
}
