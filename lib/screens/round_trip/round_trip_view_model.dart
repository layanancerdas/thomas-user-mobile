import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/ajk_action.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/home/home.dart';
import 'package:tomas/screens/shuttle_detail_easyride/shuttle_details_easyride.dart';

import 'package:tomas/screens/shuttle_details/shuttle_details.dart';
import 'package:tomas/screens/subscribe_trip/screen/subscribe_trip.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:uuid/uuid.dart';
import './round_trip.dart';

abstract class RoundTripViewModel extends State<RoundTrip> {
  Store<AppState> store;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List trips = [];
  List subscription = [];
  bool subscribe = false;
  bool isLoading = true;

  DateTime selectedDate = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  void toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> onBook(Map value) async {
    // print(value);
    if (!store.state.userState.userDetail['permitted_ajk']) {
      permitCheckAndRequest();
    }
    await store.dispatch(SetSelectedTrip(selectedTrip: value));
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ShuttleDetails()
            // SubscribeTrip()
            )
        // DetailOrder())
        );
  }

  void setOrderID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uuid = Uuid();
    var v4 = await uuid.v4();
    prefs.setString('ORDER_ID', v4);
  }

  void setIdTrip(idTrip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('ID_TRIP', idTrip);
  }

  Future<void> onBookEasyRide(Map value, Map val, String tripId) async {
    // print(value);
    await setOrderID();
    await setIdTrip(tripId);

    await store.dispatch(SetSelectedTrip(selectedTrip: value));
    await store.dispatch(SetSelectedEasyRide(selectedEasyRide: val));
    if (!store.state.userState.userDetail['permitted_ajk']) {
      permitCheckAndRequest();
    }

    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ShuttleDetailsEasyRide()
            // SubscribeTrip()
            )
        // DetailOrder())
        );
  }

  Future<void> getAllTripById(start_date, end_date) async {
    toggleLoading(true);
    try {
      dynamic res = await Providers.getTripByRouteId(
          id: store.state.ajkState.selectedRoute['route_id'],
          startDate: start_date,
          endDate: end_date);
      print(res.data['message']);
      if (res.data['message'] == 'SUCCESS') {
        List _data = res.data['data'] as List;
        List _temp = _data.where((element) => element['is_active']).toList();

        setState(() {
          trips = _temp;
        });
      } else {
        setState(() {
          trips = [];
        });
      }

      toggleLoading(false);
      refreshController.refreshCompleted();
    } catch (e) {
      print(e);
      refreshController.refreshFailed();
    } finally {
      toggleLoading(false);
    }
  }

  Future<void> getUserSubsById() async {
    toggleLoading(true);
    try {
      dynamic res = await Providers.getUserSubsByPickupId(
          routeId: store.state.ajkState.selectedRoute['route_id'],
          pickupPointId:
              store.state.ajkState.selectedPickUpPoint['pickup_point_id']);
      // print(res.data);
      List _data = res.data['data']['data'] as List;
      // List _temp = _data.where((element) => !element['deleted']).toList();
      print('refresh');
      await setState(() {
        subscription = _data;
      });
      toggleLoading(false);

      refreshController.refreshCompleted();
      return null;
    } catch (e) {
      print(e);
      refreshController.refreshFailed();
    } finally {
      toggleLoading(false);
    }
  }

  void getActiveSubs() async {
    for (int i = 0; i < subscription.length; i++) {
      if (subscription[i]['subs'][0]['pay'][0]['status'] == 'SUCCESS') {
        if (selectedDate.isAfter(DateTime.fromMicrosecondsSinceEpoch(
                    int.parse(subscription[i]['start_date']) * 1000)
                .subtract(Duration(seconds: 1))) &&
            selectedDate.isBefore(DateTime.fromMicrosecondsSinceEpoch(
                    int.parse(subscription[i]['end_date']) * 1000)
                .add(Duration(seconds: 1)))) {
          setState(() {
            subscribe = true;
            startDate = DateTime.fromMicrosecondsSinceEpoch(
                int.parse(subscription[i]['start_date']) * 1000);
            endDate = DateTime.fromMicrosecondsSinceEpoch(
                int.parse(subscription[i]['end_date']) * 1000);
          });
        } else {
          setState(() {
            subscribe = false;
          });
        }
      } else {
        setState(() {
          subscribe = false;
        });
      }
    }
  }

  Future<void> getResolveDate() async {
    try {
      dynamic res = await Providers.getResolveDate();
      store.dispatch(SetResolveDate(resolveDate: res.data['data']));
    } catch (e) {
      print(e);
    }
  }

  Future<void> onRefresh() async {
    // await getAllTripById();
    await getResolveDate();
  }

  Future<void> getUserDetail() async {
    try {
      dynamic res = await Providers.getUserDetail();
      store.dispatch(SetUserDetail(userDetail: res.data['data']));
    } catch (e) {
      print("user detail");
      print(e);
    }
  }

  Future<void> onRequestPermit() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dynamic res = await Providers.permitRequest();
      if (res.data['code'] == 'SUCCESS') {
        prefs.setInt('ajkPermitTime', DateTime.now().millisecondsSinceEpoch);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> permitCheckAndRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("ajkPermitTime") == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: CustomText('Booking Failed', color: ColorsCustom.black),
            content: CustomText(
              AppTranslations.of(context).currentLanguage == 'id'
                  ? 'Maaf, Anda tidak terdaftar sebagai pengguna AJK yang memenuhi syarat. Mohon minta persetujuan dari admin untuk menggunakan AJK.'
                  : 'Sorry, you are not registered as an eligible AJK user. Please request approval from admin to use AJK.',
              color: ColorsCustom.generalText,
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(),
                onPressed: () => onRequestPermit(),
                child: CustomText(
                  AppTranslations.of(context).currentLanguage == 'id'
                      ? "Kirim Permintaan"
                      : 'Send Request',
                  fontWeight: FontWeight.w600,
                  color: ColorsCustom.black,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(),
                onPressed: () => Navigator.pop(context),
                child: CustomText(
                  AppTranslations.of(context).currentLanguage == 'id'
                      ? "Batalkan"
                      : 'Cancel',
                  color: ColorsCustom.black,
                ),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: CustomText(
                AppTranslations.of(context).currentLanguage == 'id'
                    ? "Pesanan Gagal"
                    : 'Booking Failed',
                color: ColorsCustom.black),
            content: CustomText(
              AppTranslations.of(context).currentLanguage == 'id'
                  ? 'Sudah minta izin AJK, mohon tunggu 1x24 jam. Terima kasih.'
                  : 'You have requested an AJK permit, please wait 1x24 hours. Thank you.',
              color: ColorsCustom.generalText,
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(),
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => Home(index: 0)),
                    (Route<dynamic> route) => false),
                child: CustomText(
                  'OK',
                  color: ColorsCustom.blueSystem,
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      store = StoreProvider.of<AppState>(context);
      getAllTripById(DateTime.now(), DateTime.now().add(Duration(days: 365)));
      getResolveDate();
      getUserDetail();
      await getUserSubsById();
      getActiveSubs();
    });
  }
}
