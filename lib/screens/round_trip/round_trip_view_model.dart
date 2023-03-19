import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/ajk_action.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/shuttle_detail_easyride/shuttle_details_easyride.dart';

import 'package:tomas/screens/shuttle_details/shuttle_details.dart';
import 'package:tomas/screens/subscribe_trip/screen/subscribe_trip.dart';
import 'package:uuid/uuid.dart';
import './round_trip.dart';

abstract class RoundTripViewModel extends State<RoundTrip> {
  Store<AppState> store;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List trips = [];
  bool subscribe = false;
  bool isLoading = true;

  DateTime selectedDate = DateTime.now();

  void toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> onBook(Map value) async {
    // print(value);
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

  Future<void> onBookEasyRide(Map value, Map val) async {
    // print(value);
    await setOrderID();
    await store.dispatch(SetSelectedTrip(selectedTrip: value));
    await store.dispatch(SetSelectedEasyRide(selectedEasyRide: val));
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

      List _data = res.data['data'] as List;
      List _temp = _data.where((element) => element['is_active']).toList();

      setState(() {
        trips = _temp;
      });
      toggleLoading(false);
      refreshController.refreshCompleted();
    } catch (e) {
      print(e);
      refreshController.refreshFailed();
    } finally {
      toggleLoading(false);
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
      getAllTripById(DateTime.now(), DateTime.now().add(Duration(days: 365)));
      getResolveDate();
      getUserDetail();
    });
  }
}
