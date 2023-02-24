import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/widgets/card_complete.dart';
import 'package:tomas/widgets/card_trips.dart';
import 'package:tomas/widgets/no_trips.dart';
import 'package:tomas/localization/app_translations.dart';

class CompletedSection extends StatefulWidget {
  @override
  _CompletedSectionState createState() => _CompletedSectionState();
}

class _CompletedSectionState extends State<CompletedSection> {
  Store<AppState> store;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<void> onLoading() async {
    try {
      dynamic res = await Providers.getAllBooking(
          status: "COMPLETED",
          limit: store.state.userState.limitCompletedTrip + 10,
          offset: store.state.userState.completedTrip.length);

      if (res.data['data'].length > 0 &&
          (res.data['code'] == '00' || res.data['code'] == 'SUCCESS')) {
        await store.dispatch(SetCompletedTrip(completedTrip: [
          ...store.state.userState.completedTrip,
          ...res.data['data']
        ], limitCompletedTrip: store.state.userState.limitCompletedTrip + 10));
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (e) {
      print("onLoading Completed:");
      print(e);
    }
  }

  Future<void> onRefresh() async {
    try {
      dynamic res = await Providers.getAllBooking(
          status: "COMPLETED", limit: 10, offset: 0);

      if (res.data['data'].length > 0 &&
          (res.data['code'] == '00' || res.data['code'] == 'SUCCESS')) {
        await store.dispatch(SetCompletedTrip(
            completedTrip: res.data['data'], limitCompletedTrip: 10));
        refreshController.refreshCompleted();
      } else {
        refreshController.refreshToIdle();
      }
    } catch (e) {
      print("onRefresh Completed:");
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
              enablePullUp: state.completedTrip.length > 0 ?? false,
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
                  //   children: [CardComplete(), CardComplete()],
                  // )
                  state.completedTrip.length > 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 16, bottom: 16),
                          itemCount: state.completedTrip.length,
                          itemBuilder: (ctx, i) {
                            return CardTrips(
                              dateA: state.completedTrip[i]['trip']['type'] ==
                                      'RETURN'
                                  ? DateTime.fromMillisecondsSinceEpoch(
                                      state.completedTrip[i]['trip']
                                          ['departure_time'])
                                  : DateTime.fromMillisecondsSinceEpoch(
                                      state.completedTrip[i]['trip']
                                          ['departure_time']),
                              dateB: state.completedTrip[i]['trip']['type'] == 'RETURN'
                                  ? DateTime.fromMillisecondsSinceEpoch(
                                          state.completedTrip[i]['trip']
                                              ['departure_time'])
                                      .add(Duration(
                                          minutes: state.completedTrip[i]
                                              ['pickup_point']['time_to_dest']))
                                  : DateTime.fromMillisecondsSinceEpoch(
                                          state.completedTrip[i]['trip']['departure_time'])
                                      .add(Duration(minutes: state.completedTrip[i]['pickup_point']['time_to_dest'])),
                              timeB: state.completedTrip[i]['trip']['type'] == 'RETURN'
                                  ? DateTime.parse(state.completedTrip[i]['trip']['trip_group']['start_date'] + " " + state.completedTrip[i]['trip']['trip_group']['return_time'])
                                      .add(Duration(
                                          minutes: state.completedTrip[i]
                                              ['pickup_point']['time_to_dest']))
                                  : DateTime.parse(state.completedTrip[i]['trip']
                                              ['trip_group']['start_date'] +
                                          " " +
                                          state.completedTrip[i]['trip']
                                              ['trip_group']['departure_time'])
                                      .add(Duration(minutes: state.completedTrip[i]['pickup_point']['time_to_dest'])),
                              timeA: state.completedTrip[i]['trip']['type'] ==
                                      'RETURN'
                                  ? DateTime.parse(state.completedTrip[i]
                                          ['trip']['trip_group']['start_date'] +
                                      " " +
                                      state.completedTrip[i]['trip']
                                          ['trip_group']['return_time'])
                                  : DateTime.parse(state.completedTrip[i]
                                          ['trip']['trip_group']['start_date'] +
                                      " " +
                                      state.completedTrip[i]['trip']
                                          ['trip_group']['departure_time']),
                              title: "AJK " +
                                  (state.completedTrip[i]['trip']['type'] ==
                                          'RETURN'
                                      ? "Return"
                                      : "Departure"),
                              pointA: state.completedTrip[i]['trip']['type'] ==
                                      'RETURN'
                                  ? state.completedTrip[i]['trip']['trip_group']
                                      ['route']['destination_name']
                                  : state.completedTrip[i]['pickup_point']
                                      ['name'],
                              pointB: state.completedTrip[i]['trip']['type'] ==
                                      'RETURN'
                                  ? state.completedTrip[i]['pickup_point']
                                      ['name']
                                  : state.completedTrip[i]['trip']['trip_group']
                                      ['route']['destination_name'],
                              type: "Completed",
                              data: state.completedTrip[i],
                              id: state.completedTrip[i]['booking_id'],
                              differenceAB:
                                  "${state.completedTrip[i]['pickup_point']['time_to_dest'] ~/ 60}h ${state.completedTrip[i]['pickup_point']['time_to_dest'] % 60}m",
                            );
                          })
                      : NoTrips(
                          text:
                              "${AppTranslations.of(context).text("no_completed_trip")}",
                        ));
        });
  }
}
