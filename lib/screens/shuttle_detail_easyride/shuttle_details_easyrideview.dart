import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
import 'package:tomas/screens/payment_confirmation/widgets/card_payment_method.dart';
import 'package:tomas/screens/payment_method/screen/payment_method.dart';
import 'package:tomas/screens/shuttle_details/widgets/card_information.dart';
import 'package:tomas/widgets/card_schedule.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'shuttle_details_easyride_view_model.dart';
import 'widgets/card_policy.dart';
import 'package:table_calendar/table_calendar.dart';

class ShuttleDetailsEasyRideView extends ShuttleDetailsViewEasyRideModel {
  @override
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
                                    "Rp. ${Utils.currencyFormat.format(state.selectedPickUpPoint['price'])} / Trip",
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            width: 170,
                                            child: CustomButton(
                                              onPressed: () => onPayClick(),
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
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 4),
                            spreadRadius: -3,
                            blurRadius: 12,
                            color: ColorsCustom.black.withOpacity(0.17))
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: SvgPicture.asset(
                                'assets/images/school_bus.svg'),
                          ),
                          CustomText(
                            "Schedule ",
                            color: ColorsCustom.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),
                          CustomText(
                            "${Utils.formatterDate.format(DateTime.fromMillisecondsSinceEpoch(state.easyRide['departure_time']))}",
                            color: ColorsCustom.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 25,
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

                        timeA: Utils.formatterTime.format(
                            DateTime.fromMillisecondsSinceEpoch(
                                state.easyRide['departure_time'])),
                        timeB: Utils.formatterTime.format(
                            DateTime.fromMillisecondsSinceEpoch(
                                    state.easyRide['departure_time'])
                                .add(Duration(
                                    minutes: state
                                        .selectedPickUpPoint['time_to_dest']))),
                        differenceAB:
                            "${state.selectedPickUpPoint['time_to_dest'] ~/ 60}h ${state.selectedPickUpPoint['time_to_dest'] % 60}m",
                        pointA:
                            "${state.easyRide['type'] == 'DEPARTURE' ? state.selectedPickUpPoint['name'] : state.selectedTrip['route']['destination_name']}",
                        pointB:
                            "${state.easyRide['type'] == 'DEPARTURE' ? state.selectedTrip['route']['destination_name'] : state.selectedPickUpPoint['name']}",
                        addressA:
                            "${state.easyRide['type'] == 'DEPARTURE' ? state.selectedPickUpPoint['address'] : state.selectedTrip['route']['destination_address']}",
                        addressB:
                            "${state.easyRide['type'] == 'DEPARTURE' ? state.selectedTrip['route']['destination_address'] : state.selectedPickUpPoint['address']}",
                        coordinatesA: state.easyRide['type'] == 'DEPARTURE'
                            ? LatLng(state.selectedPickUpPoint['latitude'],
                                state.selectedPickUpPoint['longitude'])
                            : LatLng(
                                state.selectedTrip['route']
                                    ['destination_latitude'],
                                state.selectedTrip['route']
                                    ['destination_longitude']),
                        coordinatesB: state.easyRide['type'] == 'DEPARTURE'
                            ? LatLng(
                                state.selectedTrip['route']
                                    ['destination_latitude'],
                                state.selectedTrip['route']
                                    ['destination_longitude'])
                            : LatLng(state.selectedPickUpPoint['latitude'],
                                state.selectedPickUpPoint['longitude']),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                CardPaymentMethod(
                  onTapMethod: () {
                    Get.off(PaymentMethod(
                      page: 'easyride',
                      amount: state.selectedPickUpPoint['price'],
                    ));
                  },
                  payment:
                      dataPayment == null ? null : dataPayment['paymentName'],
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
