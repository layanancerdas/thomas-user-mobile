import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:tomas/helpers/utils.dart';
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
      dynamic res = await Providers.getPendingBooking(
          limit: store.state.userState.limitPendingTrip + 25,
          offset: store.state.userState.pendingTrip.length);
      if (res.data['data']['data'].length > 0 &&
          (res.data['code'] == '00' || res.data['code'] == 'SUCCESS')) {
        await store.dispatch(SetPendingTrip(pendingTrip: [
          ...store.state.userState.pendingTrip,
          ...res.data['data']['data']
        ], limitPendingTrip: store.state.userState.limitPendingTrip + 25));
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
      dynamic res = await Providers.getPendingBooking(
          limit: store.state.userState.limitPendingTrip + 25,
          offset: store.state.userState.pendingTrip.length);
      if (res.data['data']['data'].length > 0 &&
          (res.data['code'] == '00' || res.data['code'] == 'SUCCESS')) {
        await store.dispatch(SetPendingTrip(pendingTrip: [
          ...store.state.userState.pendingTrip,
          ...res.data['data']['data']
        ], limitPendingTrip: store.state.userState.limitPendingTrip + 25));
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
                        return
                            // Text('test');
                            CardTrips(
                          dataEasyRide: state.pendingTrip[i],
                          page: 'pending',
                          orderId: state.pendingTrip[i]['merchand_order_id'],
                          idEasyRide: state.pendingTrip[i]['id'],
                          linkPayment: state.pendingTrip[i]['payment_url'],
                          dateB: DateTime.fromMillisecondsSinceEpoch(int.parse(
                              state.pendingTrip[i]['departure_time'])),
                          dateA: DateTime.fromMillisecondsSinceEpoch(int.parse(
                                  state.pendingTrip[i]['departure_time']))
                              .add(Duration(
                                  minutes: int.parse(
                                      state.pendingTrip[i]['time_to_dest']))),
                          timeA: DateTime.fromMillisecondsSinceEpoch(int.parse(
                              state.pendingTrip[i]['departure_time'])),
                          timeB: DateTime.fromMillisecondsSinceEpoch(int.parse(
                                  state.pendingTrip[i]['departure_time']))
                              .add(Duration(
                                  minutes: int.parse(
                                      state.pendingTrip[i]['time_to_dest']))),
                          title: "AJK " +
                              (state.pendingTrip[i]['type'] == 'RETURN'
                                  ? "Return"
                                  : "Departure"),
                          pointA: state.pendingTrip[i]['type'] == 'RETURN'
                              ? state.pendingTrip[i]['destination_name']
                              : state.pendingTrip[i]['pickup_point_name'],
                          pointB: state.pendingTrip[i]['type'] == 'RETURN'
                              ? state.pendingTrip[i]['pickup_point_name']
                              : state.pendingTrip[i]['destination_name'],
                          type: "Waiting for Payment",
                          data: state.pendingTrip[i],
                          id: state.pendingTrip[i]['id'],
                          differenceAB:
                              "${int.parse(state.pendingTrip[i]['time_to_dest']) ~/ 60}h ${int.parse(state.pendingTrip[i]['time_to_dest']) % 60}m",
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
