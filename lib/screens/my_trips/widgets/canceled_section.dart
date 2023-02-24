import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/widgets/card_canceled.dart';
import 'package:tomas/widgets/card_trips.dart';
import 'package:tomas/widgets/no_trips.dart';
import 'package:tomas/localization/app_translations.dart';

class CanceledSection extends StatefulWidget {
  @override
  _CanceledSectionState createState() => _CanceledSectionState();
}

class _CanceledSectionState extends State<CanceledSection> {
  Store<AppState> store;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<void> onLoading() async {
    try {
      dynamic res = await Providers.getAllBooking(
          status: "CANCELED,MISSED",
          limit: store.state.userState.limitCanceledTrip + 10,
          offset: store.state.userState.canceledTrip.length);

      if (res.data['data'].length > 0 &&
          (res.data['code'] == '00' || res.data['code'] == 'SUCCESS')) {
        await store.dispatch(SetCanceledTrip(canceledTrip: [
          ...store.state.userState.canceledTrip,
          ...res.data['data']
        ], limitCanceledTrip: store.state.userState.limitCanceledTrip + 10));
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (e) {
      print("onLoading Canceled:");
      print(e);
    }
  }

  Future<void> onRefresh() async {
    try {
      dynamic res = await Providers.getAllBooking(
          status: "CANCELED,MISSED", limit: 10, offset: 0);

      if (res.data['data'].length > 0 &&
          (res.data['code'] == '00' || res.data['code'] == 'SUCCESS')) {
        await store.dispatch(SetCanceledTrip(
            canceledTrip: res.data['data'], limitCanceledTrip: 10));
        refreshController.refreshCompleted();
      } else {
        refreshController.refreshToIdle();
      }
    } catch (e) {
      print("onRefresh Canceled:");
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserState>(
        converter: (store) => store.state.userState,
        builder: (context, state) {
          return SmartRefresher(
              controller: refreshController,
              enablePullUp: state.canceledTrip.length > 0 ?? false,
              enablePullDown: true,
              onLoading: onLoading,
              onRefresh: onRefresh,
              header: ClassicHeader(),
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
              ),
              child:
                  // ListView(
                  //   padding: EdgeInsets.all(20),
                  //   children: [
                  //     CardCancelled(),
                  //   ],
                  // )
                  state.canceledTrip.length > 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 16, bottom: 16),
                          itemCount: state.canceledTrip.length,
                          itemBuilder: (ctx, i) {
                            return CardTrips(
                              dateA: state.canceledTrip[i]['trip']['type'] ==
                                      'RETURN'
                                  ? DateTime.fromMillisecondsSinceEpoch(
                                      state.canceledTrip[i]['trip']
                                          ['departure_time'])
                                  : DateTime.fromMillisecondsSinceEpoch(
                                      state.canceledTrip[i]['trip']
                                          ['departure_time']),
                              dateB: state.canceledTrip[i]['trip']['type'] == 'RETURN'
                                  ? DateTime.fromMillisecondsSinceEpoch(
                                          state.canceledTrip[i]['trip']
                                              ['departure_time'])
                                      .add(Duration(
                                          minutes: state.canceledTrip[i]
                                              ['pickup_point']['time_to_dest']))
                                  : DateTime.fromMillisecondsSinceEpoch(
                                          state.canceledTrip[i]['trip']['departure_time'])
                                      .add(Duration(minutes: state.canceledTrip[i]['pickup_point']['time_to_dest'])),
                              timeB: state.canceledTrip[i]['trip']['type'] == 'RETURN'
                                  ? DateTime.parse(state.canceledTrip[i]['trip']['trip_group']['start_date'] + " " + state.canceledTrip[i]['trip']['trip_group']['return_time'])
                                      .add(Duration(
                                          minutes: state.canceledTrip[i]
                                              ['pickup_point']['time_to_dest']))
                                  : DateTime.parse(state.canceledTrip[i]['trip']
                                              ['trip_group']['start_date'] +
                                          " " +
                                          state.canceledTrip[i]['trip']
                                              ['trip_group']['departure_time'])
                                      .add(Duration(minutes: state.canceledTrip[i]['pickup_point']['time_to_dest'])),
                              timeA: state.canceledTrip[i]['trip']['type'] ==
                                      'RETURN'
                                  ? DateTime.parse(state.canceledTrip[i]['trip']
                                          ['trip_group']['start_date'] +
                                      " " +
                                      state.canceledTrip[i]['trip']
                                          ['trip_group']['return_time'])
                                  : DateTime.parse(state.canceledTrip[i]['trip']
                                          ['trip_group']['start_date'] +
                                      " " +
                                      state.canceledTrip[i]['trip']
                                          ['trip_group']['departure_time']),
                              title: "AJK " +
                                  (state.canceledTrip[i]['trip']['type'] ==
                                          'RETURN'
                                      ? "Return"
                                      : "Departure"),
                              pointA: state.canceledTrip[i]['trip']['type'] ==
                                      'RETURN'
                                  ? state.canceledTrip[i]['trip']['trip_group']
                                      ['route']['destination_name']
                                  : state.canceledTrip[i]['pickup_point']
                                      ['name'],
                              pointB: state.canceledTrip[i]['trip']['type'] ==
                                      'RETURN'
                                  ? state.canceledTrip[i]['pickup_point']
                                      ['name']
                                  : state.canceledTrip[i]['trip']['trip_group']
                                      ['route']['destination_name'],
                              type:
                                  state.canceledTrip[i]['status'] == 'CANCELED'
                                      ? "Canceled"
                                      : "Missed Trip",
                              data: state.canceledTrip[i],
                              id: state.canceledTrip[i]['booking_id'],
                              differenceAB:
                                  "${state.canceledTrip[i]['pickup_point']['time_to_dest'] ~/ 60}h ${state.canceledTrip[i]['pickup_point']['time_to_dest'] % 60}m",
                            );
                          })
                      : NoTrips(
                          text:
                              "${AppTranslations.of(context).text("no_cancelled_trip")}",
                        ));
        });
  }
}
