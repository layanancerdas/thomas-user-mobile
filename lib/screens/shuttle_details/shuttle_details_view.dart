import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/custom_tab_indicator.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/ajk_state.dart';
import 'package:tomas/screens/choose_month/widget/list_subcription.dart';
import 'package:tomas/screens/detail_order/widget/list_subscription.dart';
import 'package:tomas/screens/shuttle_details/widgets/card_information.dart';
import 'package:tomas/widgets/card_schedule.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/custom_text.dart';
import './shuttle_details_view_model.dart';
import 'widgets/card_policy.dart';
import 'package:table_calendar/table_calendar.dart';

class ShuttleDetailsView extends ShuttleDetailsViewModel {
  @override
  CalendarFormat _calendarFormat = CalendarFormat.week;
  // var listDate = [DateTime.utc(2023, 3, 10), DateTime.utc(2023, 3, 04)];
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              leading: TextButton(
                style: TextButton.styleFrom(),
                onPressed: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  'assets/images/back_icon.svg',
                ),
              ),
              // elevation: 3,
              title: CustomText(
                "Shuttle Detail",
                color: ColorsCustom.black,
              ),
              bottom: TabBar(
                unselectedLabelColor: ColorsCustom.generalText,
                labelColor: ColorsCustom.primary,
                labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins"),
                indicator: CustomTabIndicator(
                    color: ColorsCustom.primary,
                    radius: 10,
                    width: screenSize.width / 2,
                    height: 3),
                indicatorColor: ColorsCustom.primary,
                tabs: [
                  Tab(text: "Schedule"),
                  Tab(text: "e-Ticket"),
                ],
              ),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  TabBarView(
                    children: [
                      scheduleSection(context),
                      eTicketSection(context)
                    ],
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: StoreConnector<AppState, AjkState>(
                          converter: (store) => store.state.ajkState,
                          builder: (context, state) {
                            return Container(
                                padding: EdgeInsets.fromLTRB(24, 15, 8, 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: Offset(
                                          3, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(children: [
                                  CustomText(
                                    "Rp. ${Utils.currencyFormat.format(state.selectedPickUpPoint['price'] * 10)} / Trip",
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            width: 170,
                                            child: CustomButton(
                                              onPressed: () => onBooking(),
                                              bgColor: ColorsCustom.primary,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              textColor: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              text: "Book",
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8),
                                            ),
                                          )))
                                ]));
                          })),
                  isLoading
                      ? Container(
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
                        )
                      : SizedBox()
                ],
              ),
            )));
  }

  Widget scheduleSection(BuildContext context) {
    return StoreConnector<AppState, AjkState>(
        converter: (store) => store.state.ajkState,
        builder: (context, state) {
          return ListView(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              children: [
                CustomText(
                  // "${state.selectedTrip['trip_group_name']}",
                  "AJK Shuttle",
                  color: ColorsCustom.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset('assets/images/school_bus.svg'),
                    ),
                    CustomText(
                      "Every ",
                      color: ColorsCustom.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                    CustomText(
                      "${Utils.formatterDate.format(DateTime.parse(state.selectedTrip['start_date'] + " " + state.selectedTrip['departure_time'])) ?? "-"}",
                      color: ColorsCustom.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    CustomText(
                      " - ",
                      color: ColorsCustom.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                    CustomText(
                      "${Utils.formatterDateWithYear.format(DateTime.parse(state.selectedTrip['end_date'] + " " + state.selectedTrip['return_time'])) ?? "-"}",
                      color: ColorsCustom.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                CustomText(
                  "Date Schedule",
                  color: ColorsCustom.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                SizedBox(
                  height: 5,
                ),
                isLoading
                    ? Container(
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
                      )
                    : TableCalendar(
                        headerStyle: HeaderStyle(
                            titleTextStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            formatButtonTextStyle:
                                TextStyle(color: Colors.white, fontSize: 14),
                            formatButtonPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            formatButtonDecoration: BoxDecoration(
                                color: ColorsCustom.primary,
                                borderRadius: BorderRadius.circular(20))),
                        calendarStyle: CalendarStyle(
                            selectedDecoration: (BoxDecoration(
                                color: ColorsCustom.primary,
                                borderRadius: BorderRadius.circular(30))),
                            todayTextStyle: TextStyle(color: Colors.white),
                            todayDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ColorsCustom.blueSystem)),
                        firstDay: includedDate[0],
                        lastDay: includedDate[includedDate.length - 1],
                        focusedDay: includedDate[0],
                        calendarFormat: _calendarFormat,
                        onFormatChanged: (format) => setState(() {
                          _calendarFormat = format;
                        }),
                        selectedDayPredicate: (day) =>
                            includedDate.contains(day),
                        // shouldFillViewport: true,
                      ),
                SizedBox(
                  height: 15,
                ),
                // CustomText(
                //   "Seat Available : 2",
                //   color: ColorsCustom.black,
                //   fontWeight: FontWeight.w500,
                //   fontSize: 12,
                // ),
                SizedBox(
                  height: 15,
                ),
                CustomText(
                  "Departure Schedule",
                  color: ColorsCustom.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),

                // ListSubscriptionOrder(),
                CardSchedule(
                  // includedDate: includedDate,
                  dateA: Utils.formatterDate.format(DateTime.parse(
                      state.selectedTrip['start_date'] +
                          " " +
                          state.selectedTrip['departure_time'])),
                  dateB: Utils.formatterDateWithYear.format(DateTime.parse(
                      state.selectedTrip['end_date'] +
                          " " +
                          state.selectedTrip['return_time'])),
                  timeA: Utils.formatterTime.format(DateTime.parse(
                      state.selectedTrip['start_date'] +
                          " " +
                          state.selectedTrip['departure_time'])),
                  timeB: Utils.formatterTime.format(DateTime.parse(
                          state.selectedTrip['end_date'] +
                              " " +
                              state.selectedTrip['departure_time'])
                      .add(Duration(
                          minutes: state.selectedPickUpPoint['time_to_dest']))),
                  differenceAB:
                      "${state.selectedPickUpPoint['time_to_dest'] ~/ 60}h ${state.selectedPickUpPoint['time_to_dest'] % 60}m",
                  pointA: "${state.selectedPickUpPoint['name']}",
                  pointB: "${state.selectedTrip['route']['destination_name']}",
                  addressA: "${state.selectedPickUpPoint['address']}",
                  addressB:
                      "${state.selectedTrip['route']['destination_address']}",
                  coordinatesA: LatLng(state.selectedPickUpPoint['latitude'],
                      state.selectedPickUpPoint['longitude']),
                  coordinatesB: LatLng(
                      state.selectedTrip['route']['destination_latitude'],
                      state.selectedTrip['route']['destination_longitude']),
                ),
                SizedBox(height: 15),
                CustomText(
                  "Return Schedule",
                  color: ColorsCustom.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                CardSchedule(
                  // includedDate: includedDate,
                  dateB: Utils.formatterDateWithYear.format(DateTime.parse(
                      state.selectedTrip['end_date'] +
                          " " +
                          state.selectedTrip['departure_time'])),
                  dateA: Utils.formatterDate.format(DateTime.parse(
                      state.selectedTrip['start_date'] +
                          " " +
                          state.selectedTrip['return_time'])),
                  timeB: Utils.formatterTime.format(DateTime.parse(
                          state.selectedTrip['end_date'] +
                              " " +
                              state.selectedTrip['return_time'])
                      .add(Duration(
                          minutes: state.selectedPickUpPoint['time_to_dest']))),
                  timeA: Utils.formatterTime.format(DateTime.parse(
                      state.selectedTrip['start_date'] +
                          " " +
                          state.selectedTrip['return_time'])),
                  differenceAB:
                      "${state.selectedPickUpPoint['time_to_dest'] ~/ 60}h ${state.selectedPickUpPoint['time_to_dest'] % 60}m",
                  pointB: "${state.selectedPickUpPoint['name']}",
                  pointA: "${state.selectedTrip['route']['destination_name']}",
                  addressB: "${state.selectedPickUpPoint['address']}",
                  addressA:
                      "${state.selectedTrip['route']['destination_address']}",
                  coordinatesB: LatLng(state.selectedPickUpPoint['latitude'],
                      state.selectedPickUpPoint['longitude']),
                  coordinatesA: LatLng(
                      state.selectedTrip['route']['destination_latitude'],
                      state.selectedTrip['route']['destination_longitude']),
                ),
                SizedBox(height: 110),
              ]);
        });
  }

  Widget eTicketSection(BuildContext context) {
    return ListView(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CustomText(
              "Important Information",
              color: ColorsCustom.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          CardInformation(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: CustomText(
              "Policy",
              color: ColorsCustom.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          CardPolicy(),
          SizedBox(height: 110),
        ]);
  }
}
