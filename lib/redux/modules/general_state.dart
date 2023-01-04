import 'package:meta/meta.dart';

@immutable
class GeneralState {
  GeneralState(
      {this.selectedVouchers,
      this.limitVoucher,
      this.vouchers,
      this.searchDestination,
      this.searchOrigin,
      this.searchResult,
      this.disableNavbar,
      this.isLoading,
      this.selectedNotification,
      this.notifications,
      this.limitNotif});

  final Map selectedVouchers,
      searchDestination,
      searchOrigin,
      selectedNotification;
  final List vouchers, searchResult, notifications;
  final bool disableNavbar, isLoading;
  final int limitVoucher, limitNotif;

  factory GeneralState.initial() {
    return GeneralState(
        selectedVouchers: {},
        searchDestination: {},
        searchOrigin: {},
        searchResult: [],
        vouchers: [],
        limitVoucher: 10,
        limitNotif: 10,
        disableNavbar: false,
        isLoading: false,
        notifications: [],
        selectedNotification: {});
  }

  GeneralState copyWith(
      {Map selectedVouchers,
      Map searchDestination,
      Map searchOrigin,
      Map selectedNotification,
      List vouchers,
      List searchResult,
      List notifications,
      bool disableNavbar,
      bool isLoading,
      int limitVoucher,
      int limitNotif}) {
    return GeneralState(
        selectedVouchers: selectedVouchers ?? this.selectedVouchers,
        vouchers: vouchers ?? this.vouchers,
        searchDestination: searchDestination ?? this.searchDestination,
        searchOrigin: searchOrigin ?? this.searchOrigin,
        searchResult: searchResult ?? this.searchResult,
        disableNavbar: disableNavbar ?? this.disableNavbar,
        isLoading: isLoading ?? this.isLoading,
        limitVoucher: limitVoucher ?? this.limitVoucher,
        limitNotif: limitNotif ?? this.limitNotif,
        selectedNotification: selectedNotification ?? this.selectedNotification,
        notifications: notifications ?? this.notifications);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralState &&
          runtimeType == other.runtimeType &&
          selectedVouchers == other.selectedVouchers &&
          vouchers == other.vouchers &&
          searchDestination == other.searchDestination &&
          searchOrigin == other.searchOrigin &&
          searchResult == other.searchResult &&
          disableNavbar == other.disableNavbar &&
          isLoading == other.isLoading &&
          limitVoucher == other.limitVoucher &&
          limitNotif == other.limitNotif &&
          notifications == other.notifications &&
          selectedNotification == other.selectedNotification;

  @override
  int get hashCode =>
      selectedVouchers.hashCode ^
      vouchers.hashCode ^
      searchDestination.hashCode ^
      searchOrigin.hashCode ^
      searchResult.hashCode ^
      disableNavbar.hashCode ^
      isLoading.hashCode ^
      limitNotif.hashCode ^
      limitVoucher.hashCode ^
      notifications.hashCode ^
      selectedNotification.hashCode;
}
