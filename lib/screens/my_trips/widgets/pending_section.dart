import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/widgets/card_trips.dart';
import 'package:tomas/widgets/no_trips.dart';
import 'package:tomas/localization/app_translations.dart';

class PendingSection extends StatefulWidget {
  @override
  _PendingSectionState createState() => _PendingSectionState();
}

class _PendingSectionState extends State<PendingSection> {
  Store<AppState> store;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

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
              enablePullUp: state.pendingTrip.length > 0 ?? false,
              enablePullDown: true,
              onLoading: onLoading,
              onRefresh: onRefresh,
              header: ClassicHeader(),
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
              ),
              child: state.pendingTrip.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      itemCount: state.pendingTrip.length,
                      itemBuilder: (ctx, i) {
                        return CardTrips(
                          dateB: DateTime.parse(state.pendingTrip[i]['trip']
                                  ['trip_group']['end_date'] +
                              " " +
                              state.pendingTrip[i]['trip']['trip_group']
                                  ['departure_time']),
                          dateA: DateTime.parse(state.pendingTrip[i]['trip']
                                      ['trip_group']['start_date'] +
                                  " " +
                                  state.pendingTrip[i]['trip']['trip_group']
                                      ['departure_time'])
                              .add(Duration(
                                  minutes: state.pendingTrip[i]['pickup_point']
                                      ['time_to_dest'])),
                          timeA: DateTime.parse(state.pendingTrip[i]['trip']
                                  ['trip_group']['start_date'] +
                              " " +
                              state.pendingTrip[i]['trip']['trip_group']
                                  ['departure_time']),
                          timeB: DateTime.parse(state.pendingTrip[i]['trip']
                                  ['trip_group']['end_date'] +
                              " " +
                              state.pendingTrip[i]['trip']['trip_group']
                                  ['return_time']),
                          title: "AJK " +
                              (state.pendingTrip[i]['trip']['type'] == 'RETURN'
                                  ? "Return"
                                  : "Departure"),
                          pointA: state.pendingTrip[i]['trip']['type'] ==
                                  'RETURN'
                              ? state.pendingTrip[i]['trip']['trip_group']
                                  ['route']['destination_name']
                              : state.pendingTrip[i]['pickup_point']['name'],
                          pointB:
                              state.pendingTrip[i]['trip']['type'] == 'RETURN'
                                  ? state.pendingTrip[i]['pickup_point']['name']
                                  : state.pendingTrip[i]['trip']['trip_group']
                                      ['route']['destination_name'],
                          type: "Waiting for Payment",
                          data: state.pendingTrip[i],
                          id: state.pendingTrip[i]['booking_id'],
                          differenceAB:
                              "${state.pendingTrip[i]['pickup_point']['time_to_dest'] ~/ 60}h ${state.pendingTrip[i]['pickup_point']['time_to_dest'] % 60}m",
                        );
                      },
                    )
                  : NoTrips(
                      text:
                          "${AppTranslations.of(context).text("no_pending_trip")}",
                    ));
        });
  }
}
