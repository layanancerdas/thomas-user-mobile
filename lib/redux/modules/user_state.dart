import 'package:meta/meta.dart';

@immutable
class UserState {
  UserState({
    this.limitPendingTrip,
    this.limitActiveTrip,
    this.limitCanceledTrip,
    this.limitCompletedTrip,
    this.userDetail,
    this.selectedMyTrip,
    this.getSelectedTrip,
    this.pendingTrip,
    this.activeTrip,
    this.completedTrip,
    this.canceledTrip,
  });

  final Map userDetail, selectedMyTrip;
  final List pendingTrip,
      activeTrip,
      completedTrip,
      canceledTrip,
      getSelectedTrip;
  final int limitPendingTrip,
      limitActiveTrip,
      limitCanceledTrip,
      limitCompletedTrip;

  factory UserState.initial() {
    return UserState(
        userDetail: {},
        selectedMyTrip: {},
        getSelectedTrip: [],
        pendingTrip: [],
        activeTrip: [],
        completedTrip: [],
        canceledTrip: [],
        limitActiveTrip: 50,
        limitCanceledTrip: 25,
        limitCompletedTrip: 25,
        limitPendingTrip: 25);
  }

  UserState copyWith({
    Map userDetail,
    Map selectedMyTrip,
    List getSelectedTrip,
    List pendingTrip,
    List activeTrip,
    List completedTrip,
    List canceledTrip,
    int limitActiveTrip,
    int limitCanceledTrip,
    int limitCompletedTrip,
    int limitPendingTrip,
  }) {
    return UserState(
      userDetail: userDetail ?? this.userDetail,
      selectedMyTrip: selectedMyTrip ?? this.selectedMyTrip,
      getSelectedTrip: getSelectedTrip ?? this.getSelectedTrip,
      pendingTrip: pendingTrip ?? this.pendingTrip,
      activeTrip: activeTrip ?? this.activeTrip,
      completedTrip: completedTrip ?? this.completedTrip,
      canceledTrip: canceledTrip ?? this.canceledTrip,
      limitActiveTrip: limitActiveTrip ?? this.limitActiveTrip,
      limitCanceledTrip: limitCanceledTrip ?? this.limitCanceledTrip,
      limitCompletedTrip: limitCompletedTrip ?? this.limitCompletedTrip,
      limitPendingTrip: limitPendingTrip ?? this.limitPendingTrip,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserState &&
          runtimeType == other.runtimeType &&
          userDetail == other.userDetail &&
          selectedMyTrip == other.selectedMyTrip &&
          getSelectedTrip == other.getSelectedTrip &&
          pendingTrip == other.pendingTrip &&
          activeTrip == other.activeTrip &&
          completedTrip == other.completedTrip &&
          canceledTrip == other.canceledTrip &&
          limitActiveTrip == other.limitActiveTrip &&
          limitCanceledTrip == other.limitCanceledTrip &&
          limitCompletedTrip == other.limitCompletedTrip &&
          limitPendingTrip == other.limitPendingTrip;

  @override
  int get hashCode =>
      userDetail.hashCode ^
      pendingTrip.hashCode ^
      activeTrip.hashCode ^
      completedTrip.hashCode ^
      canceledTrip.hashCode ^
      selectedMyTrip.hashCode ^
      getSelectedTrip.hashCode ^
      limitActiveTrip.hashCode ^
      limitCanceledTrip.hashCode ^
      limitCompletedTrip.hashCode ^
      limitPendingTrip.hashCode;
}
