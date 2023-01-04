import 'package:redux/redux.dart';
import 'package:tomas/redux/actions/ajk_action.dart';
import 'package:tomas/redux/modules/ajk_state.dart';

final ajkReducer = combineReducers<AjkState>([
  TypedReducer<AjkState, dynamic>(_setAjkState),
]);

AjkState _setAjkState(AjkState state, dynamic action) {
  if (action is SetSelectedTrip) {
    return state.copyWith(selectedTrip: action.selectedTrip);
  } else if (action is SetSelectedRoute) {
    return state.copyWith(selectedRoute: action.selectedRoute);
  } else if (action is SetRoutes) {
    return state.copyWith(routes: action.routes);
  } else if (action is SetSelectedPickUpPoint) {
    return state.copyWith(selectedPickUpPoint: action.selectedPickUpPoint);
  } else if (action is SetResolveDate) {
    return state.copyWith(resolveDate: action.resolveDate);
  }
  return state;
}
