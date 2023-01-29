import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/screens/home/home.dart';
import 'package:tomas/widgets/card_list_home.dart';
import 'package:tomas/widgets/card_trips.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class UpcomingTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return StoreConnector<AppState, UserState>(
        converter: (store) => store.state.userState,
        builder: (context, state) {
          return
              // state.activeTrip.length > 0 || state.pendingTrip.length > 0
              //     ?
              Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "Active Trip",
                      color: ColorsCustom.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      width: AppTranslations.of(context).currentLanguage == 'id'
                          ? 100
                          : 60,
                      height: 20,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          // highlightColor:
                          //     ColorsCustom.black.withOpacity(0.05),
                        ),
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Home(
                                      index: 1,
                                      tab: 1,
                                      forceLoading: true,
                                    ))),
                        child: CustomText(
                          "${AppTranslations.of(context).text("view_all")}",
                          color: ColorsCustom.primaryBlueHigh,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: double.infinity, child: CardListHome()

                  // ListView.builder(
                  //   padding: EdgeInsets.only(left: 8),
                  //   shrinkWrap: true,
                  //   scrollDirection: Axis.horizontal,
                  //   itemCount: state.activeTrip.length > 0
                  //       ? state.activeTrip.length
                  //       : state.pendingTrip.length,
                  //   itemBuilder: (ctx, i) {
                  //     return
                  //     Container(
                  //         margin: EdgeInsets.only(bottom: 30, top: 20),
                  //         width: screenSize.width - 32,
                  //         child: state.activeTrip.length > 0
                  //             ? CardTrips(
                  //                 home: true,
                  //                 dateA: state.activeTrip[i]['trip']
                  //                             ['type'] ==
                  //                         'RETURN'
                  //                     ? DateTime
                  //                         .fromMillisecondsSinceEpoch(state
                  //                                 .activeTrip[i]['trip']
                  //                             ['departure_time'])
                  //                     : DateTime
                  //                         .fromMillisecondsSinceEpoch(
                  //                             state.activeTrip[i]['trip']
                  //                                 ['departure_time']),
                  //                 dateB: state.activeTrip[i]['trip']
                  //                             ['type'] ==
                  //                         'RETURN'
                  //                     ? DateTime.fromMillisecondsSinceEpoch(state.activeTrip[i]['trip']['departure_time'])
                  //                         .add(Duration(
                  //                             minutes: state.activeTrip[i]
                  //                                     ['pickup_point']
                  //                                 ['time_to_dest']))
                  //                     : DateTime.fromMillisecondsSinceEpoch(
                  //                             state.activeTrip[i]['trip']
                  //                                 ['departure_time'])
                  //                         .add(Duration(minutes: state.activeTrip[i]['pickup_point']['time_to_dest'])),
                  //                 timeB: state.activeTrip[i]['trip']['type'] == 'RETURN'
                  //                     ? DateTime.parse(state.activeTrip[i]['trip']['trip_group']['start_date'] + " " + state.activeTrip[i]['trip']['trip_group']['return_time']).add(Duration(
                  //                         minutes: state.activeTrip[i]['pickup_point']
                  //                             ['time_to_dest']))
                  //                     : DateTime.parse(state.activeTrip[i]['trip']['trip_group']
                  //                                 ['start_date'] +
                  //                             " " +
                  //                             state.activeTrip[i]['trip']
                  //                                 ['trip_group']['departure_time'])
                  //                         .add(Duration(minutes: state.activeTrip[i]['pickup_point']['time_to_dest'])),
                  //                 timeA: state.activeTrip[i]['trip']['type'] == 'RETURN'
                  //                     ? DateTime.parse(state.activeTrip[i]
                  //                                 ['trip']['trip_group']
                  //                             ['start_date'] +
                  //                         " " +
                  //                         state.activeTrip[i]['trip']
                  //                                 ['trip_group']
                  //                             ['return_time'])
                  //                     : DateTime.parse(state.activeTrip[i]
                  //                                 ['trip']['trip_group']
                  //                             ['start_date'] +
                  //                         " " +
                  //                         state.activeTrip[i]['trip']
                  //                             ['trip_group']['departure_time']),
                  //                 title: "AJK " +
                  //                     (state.activeTrip[i]['trip']
                  //                                 ['type'] ==
                  //                             'RETURN'
                  //                         ? "Return"
                  //                         : "Departure"),
                  //                 pointA: state.activeTrip[i]['trip']
                  //                             ['type'] ==
                  //                         'RETURN'
                  //                     ? state.activeTrip[i]['trip']
                  //                             ['trip_group']['route']
                  //                         ['destination_name']
                  //                     : state.activeTrip[i]
                  //                         ['pickup_point']['name'],
                  //                 pointB: state.activeTrip[i]['trip']
                  //                             ['type'] ==
                  //                         'RETURN'
                  //                     ? state.activeTrip[i]
                  //                         ['pickup_point']['name']
                  //                     : state.activeTrip[i]['trip']
                  //                             ['trip_group']['route']
                  //                         ['destination_name'],
                  //                 type: state.activeTrip[i]['details'] !=
                  //                             null &&
                  //                         state.activeTrip[i]['details']
                  //                                 ['status'] ==
                  //                             'ONGOING'
                  //                     ? 'Ongoing'
                  //                     : "Booking Confirmed",
                  //                 data: state.activeTrip[i],
                  //                 id: state.activeTrip[i]['booking_id'],
                  //                 differenceAB:
                  //                     "${state.activeTrip[i]['pickup_point']['time_to_dest'] ~/ 60}h ${state.activeTrip[i]['pickup_point']['time_to_dest'] % 60}m",
                  //               )
                  //             : CardTrips(
                  //                 dateB: DateTime.parse(
                  //                     state.pendingTrip[i]['trip']
                  //                             ['trip_group']['end_date'] +
                  //                         " " +
                  //                         state.pendingTrip[i]['trip']
                  //                                 ['trip_group']
                  //                             ['departure_time']),
                  //                 dateA: DateTime.parse(
                  //                         state.pendingTrip[i]['trip']
                  //                                     ['trip_group']
                  //                                 ['start_date'] +
                  //                             " " +
                  //                             state.pendingTrip[i]['trip']
                  //                                     ['trip_group']
                  //                                 ['departure_time'])
                  //                     .add(Duration(
                  //                         minutes: state.pendingTrip[i]
                  //                                 ['pickup_point']
                  //                             ['time_to_dest'])),
                  //                 timeA: DateTime.parse(state
                  //                             .pendingTrip[i]['trip']
                  //                         ['trip_group']['start_date'] +
                  //                     " " +
                  //                     state.pendingTrip[i]['trip']
                  //                             ['trip_group']
                  //                         ['departure_time']),
                  //                 timeB: DateTime.parse(state
                  //                             .pendingTrip[i]['trip']
                  //                         ['trip_group']['end_date'] +
                  //                     " " +
                  //                     state.pendingTrip[i]['trip']
                  //                         ['trip_group']['return_time']),
                  //                 title: "AJK " +
                  //                     (state.pendingTrip[i]['trip']
                  //                                 ['type'] ==
                  //                             'RETURN'
                  //                         ? "Return"
                  //                         : "Departure"),
                  //                 pointA: state.pendingTrip[i]['trip']
                  //                             ['type'] ==
                  //                         'RETURN'
                  //                     ? state.pendingTrip[i]['trip']
                  //                             ['trip_group']['route']
                  //                         ['destination_name']
                  //                     : state.pendingTrip[i]
                  //                         ['pickup_point']['name'],
                  //                 pointB: state.pendingTrip[i]['trip']
                  //                             ['type'] ==
                  //                         'RETURN'
                  //                     ? state.pendingTrip[i]
                  //                         ['pickup_point']['name']
                  //                     : state.pendingTrip[i]['trip']
                  //                             ['trip_group']['route']
                  //                         ['destination_name'],
                  //                 type: "Waiting for Payment",
                  //                 data: state.pendingTrip[i],
                  //                 id: state.pendingTrip[i]['booking_id'],
                  //                 differenceAB:
                  //                     "${state.pendingTrip[i]['pickup_point']['time_to_dest'] ~/ 60}h ${state.pendingTrip[i]['pickup_point']['time_to_dest'] % 60}m",
                  //                 home: true,
                  //               ));
                  //   },
                  // )
                  ),
            ],
          );
          // :
        });
  }
}
