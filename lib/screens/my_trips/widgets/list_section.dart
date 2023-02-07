import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/widgets/card_list.dart';
import 'package:tomas/widgets/card_trips.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/no_trips.dart';
import 'package:tomas/localization/app_translations.dart';

class ListSection extends StatefulWidget {
  @override
  _ListSectionState createState() => _ListSectionState();
}

class _ListSectionState extends State<ListSection> {
  Store<AppState> store;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isLoading = false;
  var dataList = [];
  Future<void> onLoading() async {
    try {
      dynamic res = await Providers.getAllBooking(
          status: "PENDING",
          limit: store.state.userState.limitPendingTrip + 10,
          offset: store.state.userState.pendingTrip.length);

      if (res.data['data'].length > 0 &&
          (res.data['code'] == '00' || res.data['code'] == 'SUCCESS')) {
        await store.dispatch(SetPendingTrip(pendingTrip: [
          ...store.state.userState.pendingTrip,
          ...res.data['data']
        ], limitPendingTrip: store.state.userState.limitPendingTrip + 10));
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (e) {
      print("onLoading Pending:");
      print(e);
    }
  }

  void toggleLoading(bool value) {
    if (mounted)
      setState(() {
        isLoading = value;
      });
  }

  void listSubs() async {
    var offset = 0;
    toggleLoading(true);
    Dio dio = Dio();
    var url = BASE_API + "/ajk/user/subscription";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");
    var params = {
      "offset": offset * 10,
      "limit": 10,
    };
    final response = await dio.get(
      url,
      queryParameters: params,
      options: Options(
        headers: {'authorization': Providers.basicAuth, 'token': jwtToken},
        followRedirects: false,
        validateStatus: (status) {
          return status <= 500;
        },
      ),
    );
    if (response.data['code'] == "SUCCESS") {
      toggleLoading(false);
      setState(() {
        dataList = response.data['data']['data'];
      });
    } else {
      toggleLoading(false);
    }
  }

  Future<void> onRefresh() async {
    try {
      dynamic res = await Providers.getAllBooking(
          status: "PENDING", limit: 10, offset: 0);

      if (res.data['data'].length > 0 &&
          (res.data['code'] == '00' || res.data['code'] == 'SUCCESS')) {
        await store.dispatch(SetPendingTrip(
            pendingTrip: res.data['data'], limitPendingTrip: 10));
        refreshController.refreshCompleted();
      } else {
        refreshController.refreshToIdle();
      }
    } catch (e) {
      print("onRefresh Pending:");
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    listSubs();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SmartRefresher(
        controller: refreshController,
        // enablePullUp: state.pendingTrip.length > 0 ?? false,
        enablePullDown: true,
        onLoading: onLoading,
        onRefresh: onRefresh,
        header: ClassicHeader(),
        footer: ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        child: isLoading == false
            ? dataList.length != 0
                ? ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: dataList.length,
                    itemBuilder: (ctx, i) {
                      return CardList(
                        name: dataList[i]['subs'][0]['name'],
                        statusPayment: dataList[i]['subs'] != null
                            ? dataList[i]['subs'][0]['pay']['status']
                            : '-',
                        urlPayment: dataList[i]['subs'][0]['pay']
                            ['payment_url'],
                        orderIdPayment: dataList[i]['subs'][0]['pay']
                            ['merchand_order_id'],
                        pointA: dataList[i]['subs'][0]['route']['pickup_points']
                            [0]['name'],
                        pointB: dataList[i]['subs'][0]['route']
                            ['destination_name'],
                        addressA: dataList[i]['subs'][0]['route']
                            ['pickup_points'][0]['address'],
                        addressB: dataList[i]['subs'][0]['route']
                            ['destination_address'],
                        differenceAB:
                            "${dataList[i]['subs'][0]['route']['pickup_points'][0]['time_to_dest'] ~/ 60}h ${dataList[i]['subs'][0]['route']['pickup_points'][0]['time_to_dest'] % 60}m",
                      );
                    },
                  )
                : NoTrips(
                    text:
                        "${AppTranslations.of(context).text("no_active_trip")}",
                    button: CustomButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/SearchAjkShuttle'),
                      bgColor: ColorsCustom.primary,
                      textColor: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      text:
                          "${AppTranslations.of(context).text("create_trip")}",
                      width: screenSize.width / 2,
                      borderRadius: BorderRadius.circular(30),
                      padding:
                          EdgeInsets.symmetric(vertical: 13, horizontal: 30),
                    ),
                  )
            : Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white70,
                alignment: Alignment.center,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Loading(
                    color: ColorsCustom.primary,
                    indicator: BallSpinFadeLoaderIndicator(),
                  ),
                ),
              ));
  }
}
