class SetUserDetail {
  final Map userDetail;

  SetUserDetail({this.userDetail});
}

class SetPendingTrip {
  final List pendingTrip;
  final int limitPendingTrip;

  SetPendingTrip({this.pendingTrip, this.limitPendingTrip});
}

class SetActiveTrip {
  final List activeTrip;
  final int limitActiveTrip;

  SetActiveTrip({this.activeTrip, this.limitActiveTrip});
}

class SetCompletedTrip {
  final List completedTrip;
  final int limitCompletedTrip;

  SetCompletedTrip({this.completedTrip, this.limitCompletedTrip});
}

class SetCanceledTrip {
  final List canceledTrip;
  final int limitCanceledTrip;

  SetCanceledTrip({this.canceledTrip, this.limitCanceledTrip});
}

class SetMyTrip {
  final List pendingTrip, activeTrip, completedTrip, canceledTrip;

  SetMyTrip({
    this.pendingTrip,
    this.activeTrip,
    this.completedTrip,
    this.canceledTrip,
  });
}

class SetSelectedMyTrip {
  final Map selectedMyTrip;
  final List getSelectedTrip;

  SetSelectedMyTrip({this.getSelectedTrip, this.selectedMyTrip});
}
