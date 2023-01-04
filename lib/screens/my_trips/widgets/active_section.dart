import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/widgets/card_trips.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/no_trips.dart';
import 'package:tomas/localization/app_translations.dart';
class ActiveSection extends StatefulWidget {
  @override
  _ActiveSectionState createState() => _ActiveSectionState();
}

class _ActiveSectionState extends State<ActiveSection> {
  Store<AppState> store;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<void> onLoading() async {
    try {
      dynamic res = await Providers.getAllBooking(
          status: "ACTIVE",
          limit: store.state.userState.limitActiveTrip + 10,
          offset: store.state.userState.activeTrip.length);

      if (res.data['data'].length > 0 &&
          (res.data['code'] == '00' || res.data['code'] == 'SUCCESS')) {
        await store.dispatch(SetActiveTrip(activeTrip: [
          ...store.state.userState.activeTrip,
          ...res.data['data']
        ], limitActiveTrip: store.state.userState.limitActiveTrip + 10));
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (e) {
      print("onLoading Active:");
      print(e);
    }
  }

  Future<void> onRefresh() async {
    try {
      dynamic res =
          await Providers.getAllBooking(status: "ACTIVE", limit: 10, offset: 0);

      if (res.data['data'].length > 0 &&
          (res.data['code'] == '00' || res.data['code'] == 'SUCCESS')) {
        await store.dispatch(
            SetActiveTrip(activeTrip: res.data['data'], limitActiveTrip: 10));
        refreshController.refreshCompleted();
      } else {
        refreshController.refreshToIdle();
      }
    } catch (e) {
      print("onRefresh Active:");
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
    final screenSize = MediaQuery.of(context).size;
    return StoreConnector<AppState, UserState>(
        converter: (store) => store.state.userState,
        builder: (context, state) {
          return SmartRefresher(
              controller: refreshController,
              enablePullUp: state.activeTrip.length > 0 ?? false,
              enablePullDown: true,
              onLoading: onLoading,
              onRefresh: onRefresh,
              header: ClassicHeader(),
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
              ),
              child: state.activeTrip.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      itemCount: state.activeTrip.length,
                      itemBuilder: (ctx, i) {
                        return CardTrips(
                          dateA: state.activeTrip[i]['trip']['type'] == 'RETURN'
                              ? DateTime.fromMillisecondsSinceEpoch(
                                  state.activeTrip[i]['trip']['departure_time'])
                              : DateTime.fromMillisecondsSinceEpoch(state
                                  .activeTrip[i]['trip']['departure_time']),
                          dateB: state.activeTrip[i]['trip']['type'] == 'RETURN'
                              ? DateTime.fromMillisecondsSinceEpoch(state
                                      .activeTrip[i]['trip']['departure_time'])
                                  .add(Duration(
                                      minutes: state.activeTrip[i]
                                          ['pickup_point']['time_to_dest']))
                              : DateTime.fromMillisecondsSinceEpoch(
                                      state.activeTrip[i]['trip']['departure_time'])
                                  .add(Duration(minutes: state.activeTrip[i]['pickup_point']['time_to_dest'])),
                          timeB: state.activeTrip[i]['trip']['type'] == 'RETURN'
                              ? DateTime.parse(state.activeTrip[i]['trip']['trip_group']['start_date'] + " " + state.activeTrip[i]['trip']['trip_group']['return_time'])
                                  .add(Duration(
                                      minutes: state.activeTrip[i]
                                          ['pickup_point']['time_to_dest']))
                              : DateTime.parse(state.activeTrip[i]['trip']
                                          ['trip_group']['start_date'] +
                                      " " +
                                      state.activeTrip[i]['trip']['trip_group']
                                          ['departure_time'])
                                  .add(Duration(minutes: state.activeTrip[i]['pickup_point']['time_to_dest'])),
                          timeA: state.activeTrip[i]['trip']['type'] == 'RETURN'
                              ? DateTime.parse(state.activeTrip[i]['trip']
                                      ['trip_group']['start_date'] +
                                  " " +
                                  state.activeTrip[i]['trip']['trip_group']
                                      ['return_time'])
                              : DateTime.parse(state.activeTrip[i]['trip']
                                      ['trip_group']['start_date'] +
                                  " " +
                                  state.activeTrip[i]['trip']['trip_group']
                                      ['departure_time']),
                          title: "AJK " +
                              (state.activeTrip[i]['trip']['type'] == 'RETURN'
                                  ? "Return"
                                  : "Departure"),
                          pointA:
                              state.activeTrip[i]['trip']['type'] == 'RETURN'
                                  ? state.activeTrip[i]['trip']['trip_group']
                                      ['route']['destination_name']
                                  : state.activeTrip[i]['pickup_point']['name'],
                          pointB:
                              state.activeTrip[i]['trip']['type'] == 'RETURN'
                                  ? state.activeTrip[i]['pickup_point']['name']
                                  : state.activeTrip[i]['trip']['trip_group']
                                      ['route']['destination_name'],
                          type: state.activeTrip[i]['details'] != null &&
                                  state.activeTrip[i]['details']['status'] ==
                                      'ONGOING'
                              ? 'Ongoing'
                              : "Booking Confirmed",
                          data: state.activeTrip[i],
                          id: state.activeTrip[i]['booking_id'],
                          differenceAB:
                              "${state.activeTrip[i]['pickup_point']['time_to_dest'] ~/ 60}h ${state.activeTrip[i]['pickup_point']['time_to_dest'] % 60}m",
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
                        text: "${AppTranslations.of(context).text("create_trip")}",
                        width: screenSize.width / 2,
                        borderRadius: BorderRadius.circular(30),
                        padding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 30),
                      ),
                    ));
        });
  }
}
