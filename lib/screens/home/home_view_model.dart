import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/ajk_action.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/actions/transaction_action.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/lifecycle_manager/lifecycle_manager.dart';
import 'package:tomas/screens/my_trips/my_trips.dart';
import 'package:tomas/screens/notifications/notifications.dart';
import 'package:tomas/screens/profile/profile.dart';
import 'package:tomas/widgets/modal_coming_soon.dart';
import 'package:tomas/widgets/modal_no_location.dart';
import './home.dart';

abstract class HomeViewModel extends State<Home> {
  Store<AppState> store;
  StreamSubscription<Position> positionStream;
  List<Map> children = [
    {
      "name": "Home",
    },
    {
      "name": "Perjalanan Saya",
      "page": MyTrips(index: 1),
    },
    {
      "name": "Notifikasi",
      "page": Notifications(),
    },
    {
      "name": "Akun",
      "page": Profile(),
    },
  ];
  static List<Map> bottomNavIn = [
    {
      "name": "Home",
    },
    {
      "name": "Trip Saya",
      "page": MyTrips(index: 1),
    },
    {
      "name": "Notifikasi",
      "page": Notifications(),
    },
    {
      "name": "Akun",
      "page": Profile(),
    },
  ];

  static List<Map> bottomNavEn = [
    {
      "name": "Home",
    },
    {
      "name": "My Trips",
      "page": MyTrips(index: 1),
    },
    {
      "name": "Notification",
      "page": Notifications(),
    },
    {
      "name": "Account",
      "page": Profile(),
    },
  ];

  int currentIndex = 0;

  List<Placemark> placemark = List();

  bool isLoading = false;
  bool isHaveNewNotif = false;

  void toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void toggleNewNotif(bool value) {
    // print(value);
    setState(() {
      isHaveNewNotif = value;
    });
  }

  Future<void> onTabTapped(int index) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (index == 2) {
    //   prefs.setBool("new_notifications", false);
    // }
    setState(() {
      currentIndex = index;
    });
  }

  //location
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      List<Placemark> _placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      // print(Geolocator.distanceBetween(
      //     position.latitude, position.longitude, -6.894450, 107.640229));
      setState(() {
        placemark = _placemark;
      });
    } catch (e) {
      print(e);
    } finally {
      toggleLoading(false);
    }
  }

  void locationListener(Position position) {}

  Future listenForPermissionStatus() async {
    try {
      LocationPermission permission;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ModalNoLocation(
                mode: 'permission',
              );
            });
        //   return Future.error(
        //       'Location permissions are permantly denied, we cannot request permissions.');
      }
      print(permission.toString());
      if (permission == LocationPermission.denied) {
        // permission = await Geolocator.requestPermission();
        // if (permission != LocationPermission.whileInUse &&
        //     permission != LocationPermission.always) {
        //   }
        await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ModalNoLocation(
                mode: 'permission',
              );
            });
      }
    } catch (e) {
      print(e);
    } finally {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ModalNoLocation();
            });
      }
    }
    await getCurrentLocation();
  }

  void showDialogComingSoon() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ModalComingSoon();
        });
  }

  void clearVoucher() {
    store.dispatch(SetSelectedVoucher(selectedVoucher: {}));
  }

  Future<void> checkNotif() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("new_notifications");
    // print(prefs.getBool('new_notifications'));
    if (prefs.getBool('new_notifications') != null) {
      toggleNewNotif(prefs.getBool('new_notifications'));
    }
  }

  Future<void> getUserDetail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dynamic res = await Providers.getUserDetail();
      // print(res);
      print(res.data);
      if (res.data['code'].toString() == 'SUCCESS') {
        store.dispatch(SetUserDetail(userDetail: res.data['data']));
        if (res.data['data']['permitted_ajk'] &&
            prefs.containsKey('ajkPermitTime')) {
          prefs.remove('ajkPermitTime');
        }
      } else if (res.data['message'].contains('user') ||
          !res.data.containsKey('data')) {
        prefs.remove('jwtToken');

        // Navigator.pushNamedAndRemoveUntil(
        //     context, '/Landing', (route) => false);
      }
    } catch (e) {
      print("user detail");
      print(e);
    }
  }

  Future<void> getUserBalance() async {
    try {
      dynamic res = await Providers.getBalanceByUserId();
      store.dispatch(SetBalances(balances: res.data['data']['balance']));
    } catch (e) {
      print("user detail");
      print(e);
    }
  }

  Future<void> getNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dynamic res = await Providers.getNotifByUserId(
          limit: store.state.generalState.limitNotif, offset: 0);
      if (!store.state.generalState.disableNavbar) {
        List _temp = res.data['data']
            .where((e) => e['is_active'].toString() == 'true')
            .toList();
        List _tempRead = res.data['data']
            .where((e) => e['is_read'].toString() == 'false')
            .toList();

        print("getNotifications");

        print(_tempRead);
        print(_tempRead.length);

        if (_temp.length <= 0) {
          prefs.setBool("new_notifications", false);
        }

        if (_tempRead.length > 0) {
          prefs.setBool("new_notifications", true);
        } else {
          prefs.setBool("new_notifications", false);
        }
        store.dispatch(SetNotifications(notifications: _temp));
      }

      // if (res.data['data'].length >
      //     store.state.generalState.notifications.length) {
      //   prefs.setBool("new_notifications", true);
      // } else {
      //   prefs.setBool("new_notifications", false);
      // }
    } catch (e) {
      print("user detail");
      print(e);
    }
  }

  Future<void> getResolveDate() async {
    try {
      dynamic res = await Providers.getResolveDate();
      store.dispatch(SetResolveDate(resolveDate: res.data['data']));
    } catch (e) {
      print("date resolve");
      print(e);
    }
  }

  Future<void> getVouchers() async {
    try {
      dynamic res = await Providers.getVouchers(
          limit: store.state.generalState.limitVoucher, offset: 0);
      if (res.data['code'] == 'SUCCESS') {
        List resData = res.data['data'];

        resData.removeWhere((element) {
          final bool firstValid = DateTime.now().isAfter(
              DateTime.fromMillisecondsSinceEpoch(
                  int.parse(element['first_valid'])));
          final bool lastValid = DateTime.now().isBefore(
              DateTime.fromMillisecondsSinceEpoch(
                  int.parse(element['last_valid'])));
          return !element['is_active'] || !firstValid || !lastValid;
        });

        store.dispatch(SetVouchers(vouchers: resData));
      }
    } catch (e) {
      print("vouchers");
      print(e);
    }
    // print(store.state.generalState.vouchers);
  }

  Future<void> getPaymentMethods() async {
    try {
      if (store.state.transactionState.paymentMethod.length <= 0) {
        dynamic res = await Providers.getPaymentMethods();
        store.dispatch(SetPaymentMethod(paymentMethod: res.data['data']));
      }
    } catch (e) {
      print("vouchers");
      print(e);
    }
  }

  void automaticCanceled() {
    store.state.userState.pendingTrip.forEach((element) async {
      final bool expiredDate = DateTime.now().isAfter(
          DateTime.fromMillisecondsSinceEpoch(
              element['invoice']['expired_at']));
      if (expiredDate) {
        await Providers.cancelBooking(bookingId: element['booking_id']);
      }
    });
  }

  Future<void> getBookingData() async {
    try {
      dynamic resPending = await Providers.getAllBooking(
          status: "PENDING",
          limit: store.state.userState.limitPendingTrip,
          offset: 0);
      dynamic resActive = await Providers.getAllBooking(
          status: "ACTIVE",
          limit: store.state.userState.limitActiveTrip,
          offset: 0);
      dynamic resCompleted = await Providers.getAllBooking(
          status: "COMPLETED",
          limit: store.state.userState.limitCompletedTrip,
          offset: 0);
      dynamic resCanceled = await Providers.getAllBooking(
          status: "CANCELED,MISSED",
          limit: store.state.userState.limitCanceledTrip,
          offset: 0);

      store.dispatch(SetMyTrip(
        pendingTrip: resPending.data['data'],
        activeTrip: resActive.data['data'],
        completedTrip: resCompleted.data['data'],
        canceledTrip: resCanceled.data['data'],
      ));
    } catch (e) {
      print("booking data");
      print(e);
    }
  }

  void toggleIsLoading(bool value) {
    store.dispatch(SetIsLoading(isLoading: value));
  }

  Future<void> initData() async {
    // toggleIsLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jwtToken = prefs.getString("jwtToken");

      if (jwtToken != null) {
        await getUserDetail();
        await getResolveDate();
        await getPaymentMethods();
        await getBookingData();
        await getVouchers();
        await getUserBalance();
        await getNotifications();
        print('object');
        automaticCanceled();
      } else {
        await getUserDetail();
      }
    } catch (e) {
      print(e.toString());
    } finally {
      toggleIsLoading(false);
    }
  }

  _asyncMethod() async {
    initData();
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    listenForPermissionStatus();
    initData();
    Timer.periodic(Duration(seconds: 1), (_) {
      checkNotif();
    });
    Timer.periodic(Duration(seconds: 10), (_) {
      getCurrentLocation();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 200), () => widget.tab = null);

      store = StoreProvider.of<AppState>(context);
      _asyncMethod();
      clearVoucher();
      checkNotif();
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (positionStream != null) {
      positionStream.cancel();
      positionStream = null;
    }
  }
}
