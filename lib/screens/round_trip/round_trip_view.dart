import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/custom_tab_indicator.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/ajk_state.dart';
import 'package:tomas/screens/subscribe_trip/screen/subscribe_trip.dart';
import 'package:tomas/widgets/alert_permit.dart';
import 'package:tomas/widgets/card_easyride.dart';
import 'package:tomas/widgets/card_round_trip.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/no_result_search_ajk.dart';
import './round_trip_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class RoundTripView extends RoundTripViewModel {
  @override
  DateTime nowYear = DateTime.now().add(Duration(days: 365));
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: ColorsCustom.primary,
              colorScheme: ColorScheme.light(primary: ColorsCustom.primary),
              // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        },
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: nowYear);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      getAllTripById(selectedDate, selectedDate.add(Duration(days: 365)));
    }
  }

  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return StoreConnector<AppState, AjkState>(
        converter: (store) => store.state.ajkState,
        builder: (context, state) {
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
                      Tab(text: "Subscribe"),
                      Tab(text: "Easy Ride"),
                    ],
                  ),

                  // elevation: 3,
                  centerTitle: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: CustomText(
                            "${Utils.capitalizeFirstofEach(state.selectedPickUpPoint['name']) ?? "-"}",
                            color: ColorsCustom.black,
                            overflow: true,
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: SvgPicture.asset('assets/images/exchange.svg'),
                      ),
                      Expanded(
                        child: CustomText(
                          "${Utils.capitalizeFirstofEach(state.selectedRoute['destination_name']) ?? "-"}",
                          color: ColorsCustom.black,
                          overflow: true,
                        ),
                      ),
                    ],
                  ),
                  actions: [SizedBox(width: 50)],
                ),
                body: Stack(children: [
                  TabBarView(
                    children: [
                      subscribeSection(context),
                      easyRideSection(context)
                    ],
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
                      : SizedBox()
                  // ],
                ])),
          );
        });
  }

  Widget subscribeSection(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return StoreConnector<AppState, AjkState>(
        converter: (store) => store.state.ajkState,
        builder: (context, state) {
          return ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                        color: ColorsCustom.primary,
                        borderRadius: BorderRadius.circular(10)),
                    // margin: EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                  right: 8,
                                ),
                                height: 20,
                                width: 20,
                                child: SvgPicture.asset(
                                  'assets/images/calendar.svg',
                                  color: Colors.white,
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            CustomText(
                              "Start From ",
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                            CustomText(
                              // "",
                              // "${state.resolveDate['start_date']}",
                              DateFormat('dd MMMM yyyy').format(selectedDate),
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.only(left: 16),
                child: CustomText(
                  'Subscribe Trip',
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      subscribe
                          ? 'Subscribe is active'
                          : 'Subscribe is not active',
                      color: subscribe
                          ? ColorsCustom.newGreen
                          : ColorsCustom.primary,
                      fontSize: 14,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          subscribe = !subscribe;
                        });
                        Get.to(SubscribeTrip(
                            idRoute: state.selectedRoute['route_id'],
                            pickupPointId:
                                state.selectedPickUpPoint['pickup_point_id']));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorsCustom.primary,
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(12),
                        child: CustomText(
                          subscribe ? 'Extend' : 'Subscribe Now',
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              trips.length > 0
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: trips.length,
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        return CardRoundtrip(
                          subscribe: subscribe,
                          color: i == 0
                              ? 'blue'
                              : i == 1
                                  ? 'yellow'
                                  : 'green',
                          locationA: state.selectedPickUpPoint['name'],
                          locationB: trips[i]['route']['destination_name'],
                          locationD: state.selectedPickUpPoint['name'],
                          locationC: trips[i]['route']['destination_name'],
                          differenceAB:
                              "${state.selectedPickUpPoint['time_to_dest'] ~/ 60}h ${state.selectedPickUpPoint['time_to_dest'] % 60}m",
                          differenceCD:
                              "${state.selectedPickUpPoint['time_to_dest'] ~/ 60}h ${state.selectedPickUpPoint['time_to_dest'] % 60}m",
                          name: "${trips[i]['trip_group_name']}",
                          price: Utils.currencyFormat
                              .format(state.selectedPickUpPoint['price'] * 10),
                          timeA: Utils.formatterTime.format(DateTime.parse(
                              trips[i]['start_date'] +
                                  " " +
                                  trips[i]['departure_time'])),
                          timeB: Utils.formatterTime.format(DateTime.parse(
                                  trips[i]['start_date'] +
                                      " " +
                                      trips[i]['departure_time'])
                              .add(Duration(
                                  minutes: state
                                      .selectedPickUpPoint['time_to_dest']))),
                          timeC: Utils.formatterTime.format(DateTime.parse(
                              trips[i]['start_date'] +
                                  " " +
                                  trips[i]['return_time'])),
                          timeD: Utils.formatterTime.format(DateTime.parse(
                                  trips[i]['start_date'] +
                                      " " +
                                      trips[i]['return_time'])
                              .add(Duration(
                                  minutes: state
                                      .selectedPickUpPoint['time_to_dest']))),
                          week: "${Utils.formatterDate.format(DateTime.parse(trips[i]['start_date'])) ?? "-"}" +
                              " - " +
                              "${Utils.formatterDateWithYear.format(DateTime.parse(trips[i]['end_date'])) ?? "-"}",
                          distance: '1',
                          data: trips[i],
                          onBook: onBook,
                          // isActive: isSubscribe,
                        );
                      })
                  : Container(
                      height: screenSize.height / 2,
                      width: double.infinity,
                      child: NoResultSearchAjk()),
            ],
          );
        });
  }

  Widget easyRideSection(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return StoreConnector<AppState, AjkState>(
        converter: (store) => store.state.ajkState,
        builder: (context, state) {
          return ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                        color: ColorsCustom.primary,
                        borderRadius: BorderRadius.circular(10)),
                    // margin: EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                  right: 8,
                                ),
                                height: 20,
                                width: 20,
                                child: SvgPicture.asset(
                                  'assets/images/calendar.svg',
                                  color: Colors.white,
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            CustomText(
                              "Start From ",
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                            CustomText(
                              // "",
                              // "${state.resolveDate['start_date']}",
                              DateFormat('dd MMMM yyyy').format(selectedDate),
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.only(left: 16),
                child: CustomText(
                  'Easy Ride',
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              trips.length > 0
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: trips.length,
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        return Column(
                          children: List.generate(
                              trips[i]['trips'].length,
                              (index) => selectedDate.isAfter(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          trips[i]['trips'][index]
                                              ['departure_time']))
                                  ? SizedBox()
                                  : CardEasyRide(
                                      subscribe: true,
                                      color: 'blue',
                                      locationA: trips[i]['trips'][index]
                                                  ['type'] ==
                                              'DEPARTURE'
                                          ? state.selectedPickUpPoint['name']
                                          : trips[i]['route']
                                              ['destination_name'],
                                      locationB: trips[i]['trips'][index]
                                                  ['type'] ==
                                              'RETURN'
                                          ? state.selectedPickUpPoint['name']
                                          : trips[i]['route']
                                              ['destination_name'],

                                      differenceAB:
                                          "${state.selectedPickUpPoint['time_to_dest'] ~/ 60}h ${state.selectedPickUpPoint['time_to_dest'] % 60}m",

                                      price: Utils.currencyFormat.format(
                                          state.selectedPickUpPoint['price']),
                                      timeA: Utils.formatterTime.format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              trips[i]['trips'][index]
                                                  ['departure_time'])),
                                      timeB: Utils.formatterTime.format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                                  trips[i]['trips'][index]
                                                      ['departure_time'])
                                              .add(Duration(
                                                  minutes:
                                                      state.selectedPickUpPoint[
                                                          'time_to_dest']))),

                                      week:
                                          "${Utils.formatterDate.format(DateTime.fromMillisecondsSinceEpoch(trips[i]['trips'][index]['departure_time']))}",

                                      data: trips[i],
                                      dataEasyRide: trips[i]['trips'][index],
                                      onBook: onBookEasyRide,
                                      // isActive: isSubscribe,
                                    )),
                        );

                        // CardEasyRide(
                        //   subscribe: true,
                        //   color: 'blue',
                        //   locationA: state.selectedPickUpPoint['name'],
                        //   locationB: trips[i]['route']['destination_name'],
                        //   locationD: state.selectedPickUpPoint['name'],
                        //   locationC: trips[i]['route']['destination_name'],
                        //   differenceAB:
                        //       "${state.selectedPickUpPoint['time_to_dest'] ~/ 60}h ${state.selectedPickUpPoint['time_to_dest'] % 60}m",
                        //   differenceCD:
                        //       "${state.selectedPickUpPoint['time_to_dest'] ~/ 60}h ${state.selectedPickUpPoint['time_to_dest'] % 60}m",
                        //   name: "${trips[i]['trip_group_name']}",
                        //   price: Utils.currencyFormat
                        //       .format(state.selectedPickUpPoint['price'] * 10),
                        //   timeA: Utils.formatterTime.format(DateTime.parse(
                        //       trips[i]['start_date'] +
                        //           " " +
                        //           trips[i]['departure_time'])),
                        //   timeB: Utils.formatterTime.format(DateTime.parse(
                        //           trips[i]['start_date'] +
                        //               " " +
                        //               trips[i]['departure_time'])
                        //       .add(Duration(
                        //           minutes: state
                        //               .selectedPickUpPoint['time_to_dest']))),
                        //   timeC: Utils.formatterTime.format(DateTime.parse(
                        //       trips[i]['start_date'] +
                        //           " " +
                        //           trips[i]['return_time'])),
                        //   timeD: Utils.formatterTime.format(DateTime.parse(
                        //           trips[i]['start_date'] +
                        //               " " +
                        //               trips[i]['return_time'])
                        //       .add(Duration(
                        //           minutes: state
                        //               .selectedPickUpPoint['time_to_dest']))),
                        //   week: "${Utils.formatterDate.format(DateTime.parse(trips[i]['start_date'])) ?? "-"}" +
                        //       " - " +
                        //       "${Utils.formatterDateWithYear.format(DateTime.parse(trips[i]['end_date'])) ?? "-"}",
                        //   distance: '1',
                        //   data: trips[i],
                        //   onBook: onBook,
                        //   // isActive: isSubscribe,
                        // );
                      })
                  : Container(
                      height: screenSize.height / 2,
                      width: double.infinity,
                      child: NoResultSearchAjk()),
            ],
          );
        });
  }
}
