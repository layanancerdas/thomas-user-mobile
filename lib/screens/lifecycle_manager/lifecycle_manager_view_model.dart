import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/ajk_action.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/actions/transaction_action.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/detail_trip/detail_trip.dart';
import 'package:tomas/widgets/custom_text.dart';
import './lifecycle_manager.dart';

abstract class LifecycleManagerViewModel extends State<LifecycleManager> {
  Store<AppState> store;
  final Connectivity _connectivity = Connectivity();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool permissionLocation = false;
  bool maintenance = false;
  bool noInternet = false;

  void toggleIsLoading(bool value) {
    store.dispatch(SetIsLoading(isLoading: value));
  }

  void toggleNoInternet(bool value) {
    setState(() {
      noInternet = value;
    });
  }

  void toggleMaintenance(bool value) {
    setState(() {
      maintenance = value;
    });
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        toggleNoInternet(false);
        break;
      case ConnectivityResult.mobile:
        toggleNoInternet(false);
        break;
      case ConnectivityResult.none:
        toggleNoInternet(true);
        Utils.onErrorConnection("modal_connection", context: context);
        break;
      default:
        toggleNoInternet(false);
        break;
    }
  }

  Future<void> checkInternet(context) async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('connected');
        toggleNoInternet(false);
      }
    } on SocketException catch (e) {
      print(e);
      toggleNoInternet(true);
      Utils.onErrorConnection("fullpage_connection", context: context);
    } catch (e) {
      print(e);
    }
  }

  // Future<void> checkBE(context) async {
  //   try {
  //     final result = await InternetAddress.lookup('geekco.id');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       // print('connected');
  //       toggleMaintenance(false);
  //     }
  //   } on SocketException catch (e) {
  //     // print(e);
  //     toggleMaintenance(true);
  //     Utils.onErrorConnection("fullpage_maintenance", context: context);
  //   } catch (e) {
  //     // print(e);
  //   }
  // }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
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

  Future<List> getTripOrderId(Map data) async {
    // print(widget.data);
    if (data['details'] != null) {
      try {
        // print(widget.id);
        dynamic res = await Providers.getTripOrderById(
            tripOrderId: data['details']['trip_order_id']);
        List _temp = res.data['data']['trip_histories'];

        return _temp
            .where((element) =>
                element['pickup_point_id'] ==
                data['pickup_point']['pickup_point_id'])
            .toList();
      } catch (e) {
        print(e);
        return [];
      }
    } else {
      return [];
    }
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

  Future initialize() async {
    if (Platform.isIOS) {
      _fcm.requestPermission(badge: true, sound: true);
    }

    // store = StoreProvider.of(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // FirebaseMessaging.onMessage.listen(
      //   onMessage: (Map<String, dynamic> message) async {
      //     print("onMessage: $message");
      //     try {
      //       print("2");

      //       prefs.setBool("new_notifications", true);
      //       print("3");
      //       showSimpleNotification(
      //           CustomText(
      //             message['notification']['title'],
      //             fontSize: 14,
      //             fontWeight: FontWeight.w500,
      //             color: ColorsCustom.black,
      //           ),
      //           subtitle: CustomText(
      //             message['notification']['body'],
      //             fontSize: 12,
      //             fontWeight: FontWeight.w400,
      //             color: ColorsCustom.black,
      //           ),
      //           trailing: IconButton(
      //               icon: Icon(
      //                 Icons.close,
      //                 color: ColorsCustom.black,
      //               ),
      //               onPressed: () {
      //                 OverlaySupportEntry.of(context).dismiss();
      //               }),
      //           background: Colors.white,
      //           elevation: 4,
      //           duration: Duration(seconds: 4));

      //       await getNotifications();
      //       await getBookingData();
      //       await getUserDetail();
      //       await getUserBalance();
      //       if (store.state.userState.selectedMyTrip
      //           .containsKey("booking_id")) {
      //         await DetailTrip.of(context).onRefresh();
      //       }
      //     } catch (e) {
      //       print(e);
      //     } finally {
      //       toggleIsLoading(false);
      //     }
      //   },
      //   onBackgroundMessage: myBackgroundMessageHandler,
      //   onLaunch: (Map<String, dynamic> message) async {
      //     print("onLaunch: $message");
      //     prefs.setBool("new_notifications", true);
      //     // onHandlePage(
      //     //     message: message, navigatorKey: navigatorKey, store: store);
      //     // _navigateToItemDetail(message);
      //   },
      //   onResume: (Map<String, dynamic> message) async {
      //     print("onResume: $message");
      //     prefs.setBool("new_notifications", true);
      //     // onHandlePage(
      //     //     message: message, navigatorKey: navigatorKey, store: store);
      //     // _navigateToItemDetail(message);
      //   },
      // );
    } catch (e) {
      print("notifbro");
      print(e);
    }
  }

  static Future<void> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("new_notifications", true);
    if (message.containsKey('data')) {
      // Handle data message
      // final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      // final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  Future<void> initData() async {
    toggleIsLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jwtToken = prefs.getString("jwtToken");

      if (jwtToken != null && !noInternet && !maintenance) {
        // await getUserDetail();
        // await getResolveDate();
        // await getPaymentMethods();
        // await getBookingData();
        // await getVouchers();
        // await getUserBalance();
        // await getNotifications();
        // print('object');
        // automaticCanceled();
      } else {
        await getUserDetail();
      }
    } catch (e) {
      print(e.toString());
    } finally {
      toggleIsLoading(false);
    }
  }

  Future<void> initPeriodic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");
    // if (!maintenance) {
    //   checkBE(context);
    // }

    if (jwtToken != null && !noInternet && !maintenance) {
      // getUserDetail();
      // getBookingData();
      // getVouchers();
      // getUserBalance();
      // getPaymentMethods();
      // getNotifications();
      // print('object');
    } else {
      await getUserDetail();
    }
  }

  Future<void> initPerSecond() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");
    if (!maintenance) {
      // checkBE(context);
    }

    if (jwtToken != null && !noInternet && !maintenance) {
      getBookingData();
    }
  }

  @override
  void initState() {
    super.initState();
    // initConnectivity();
    // checkInternet(context);
    // // checkBE(context);
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    // // Timer.periodic(Duration(seconds: 3), (_) => automaticCanceled());
    // // Timer.periodic(Duration(seconds: 3), (_) => initPerSecond());
    // Timer.periodic(Duration(seconds: 1), (_) {
    //   checkInternet(context);
    //   // checkBE(context);
    // });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   store = StoreProvider.of<AppState>(context);
    //   initialize();
    //   // initData();
    // });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
