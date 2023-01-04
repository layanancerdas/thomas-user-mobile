import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/redux/actions/general_action.dart';
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

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      List<Placemark> _placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);

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

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    listenForPermissionStatus();

    Timer.periodic(Duration(seconds: 1), (_) {
      checkNotif();
    });

    Timer.periodic(Duration(seconds: 10), (_) {
      getCurrentLocation();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      LifecycleManager.of(context).initData();
      Future.delayed(Duration(milliseconds: 200), () => widget.tab = null);

      store = StoreProvider.of<AppState>(context);
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
