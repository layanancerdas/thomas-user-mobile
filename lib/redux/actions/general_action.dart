class SetVouchers {
  final List vouchers;
  final int limitVoucher;

  SetVouchers({this.vouchers, this.limitVoucher});
}

class SetSelectedVoucher {
  final Map selectedVoucher;

  SetSelectedVoucher({this.selectedVoucher});
}

class SetSearchOrigin {
  final Map searchOrigin;

  SetSearchOrigin({this.searchOrigin});
}

class SetSearchDestination {
  final Map searchDestination;

  SetSearchDestination({this.searchDestination});
}

class SetSearchResult {
  final List searchResult;

  SetSearchResult({this.searchResult});
}

class SetDisableNavbar {
  final bool disableNavbar;

  SetDisableNavbar({this.disableNavbar});
}

class SetNotifications {
  final List notifications;
  final int limitNotif;

  SetNotifications({this.notifications, this.limitNotif});
}

class SetSelectedNotification {
  final Map selectedNotification;

  SetSelectedNotification({this.selectedNotification});
}

class SetIsLoading {
  final bool isLoading;

  SetIsLoading({this.isLoading});
}

class ExchangeSearch {}
