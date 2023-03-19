import 'package:meta/meta.dart';

@immutable
class AjkState {
  AjkState({
    this.resolveDate,
    this.selectedTrip,
    this.easyRide,
    this.selectedRoute,
    this.selectedPickUpPoint,
    this.routes,
  });

  final Map selectedTrip,
      selectedRoute,
      selectedPickUpPoint,
      resolveDate,
      easyRide;
  final List routes;

  factory AjkState.initial() {
    return AjkState(
        selectedTrip: {},
        easyRide: {},
        selectedRoute: {},
        selectedPickUpPoint: {},
        resolveDate: {},
        routes: []);
  }

  AjkState copyWith({
    Map selectedTrip,
    Map easyRide,
    Map selectedRoute,
    Map selectedPickUpPoint,
    Map resolveDate,
    List routes,
  }) {
    return AjkState(
      selectedTrip: selectedTrip ?? this.selectedTrip,
      easyRide: easyRide ?? this.easyRide,
      selectedRoute: selectedRoute ?? this.selectedRoute,
      selectedPickUpPoint: selectedPickUpPoint ?? this.selectedPickUpPoint,
      resolveDate: resolveDate ?? this.resolveDate,
      routes: routes ?? this.routes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AjkState &&
          runtimeType == other.runtimeType &&
          selectedTrip == other.selectedTrip &&
          easyRide == other.easyRide &&
          selectedRoute == other.selectedRoute &&
          selectedPickUpPoint == other.selectedPickUpPoint &&
          resolveDate == other.resolveDate &&
          routes == other.routes;

  @override
  int get hashCode =>
      selectedRoute.hashCode ^
      selectedTrip.hashCode ^
      easyRide.hashCode ^
      selectedPickUpPoint.hashCode ^
      resolveDate.hashCode ^
      routes.hashCode;
}
