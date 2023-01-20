import 'package:flutter/material.dart';
import 'package:tomas/configs/static_text_en.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tomas/configs/static_text_id.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/screens/detail_trip/widgets/card_booking.dart';
import 'package:tomas/screens/detail_trip/widgets/card_waiting_payment.dart';
import 'package:tomas/screens/detail_trip/widgets/more_info.dart';
import 'package:tomas/screens/detail_trip/widgets/payment_info.dart';
import 'package:tomas/screens/lifecycle_manager/lifecycle_manager.dart';
import 'package:tomas/screens/review/review.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/custom_text.dart';
import './detail_trip_view_model.dart';
import 'widgets/bus_details.dart';

class DetailTripView extends DetailTripViewModel {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserState>(
        converter: (store) => store.state.userState,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: TextButton(
                style: TextButton.styleFrom(),
                onPressed: () => Navigator.pop(context),
                // onPressed: () => Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (_) => Home(index: 1, tab: 1)),
                //     (Route<dynamic> route) => false),
                child: SvgPicture.asset(
                  'assets/images/back_icon.svg',
                ),
              ),
              // elevation: 3,
              centerTitle: true,
              title: CustomText(
                // "${state.selectedMyTrip['trip']['trip_group']['trip_group_name']}",
                "${AppTranslations.of(context).text("trip_detail")}",
                color: ColorsCustom.black,
              ),
            ),
            body: Stack(
              children: [
                Container(
                  height: double.infinity,
                  child: SmartRefresher(
                      controller: refreshController,
                      enablePullUp: false,
                      enablePullDown: true,
                      onRefresh: onRefresh,
                      child: Stack(
                        children: [
                          ListView(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 20),
                            controller: scrollController,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    "Your Position :",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    height: 2.1,
                                    color: ColorsCustom.black,
                                  ),
                                  CustomText(
                                    distance.toStringAsFixed(0) +
                                        ' Meter From Pickup Point',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 2.1,
                                    color: ColorsCustom.primary,
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    "Status:",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    height: 2.1,
                                    color: ColorsCustom.black,
                                  ),
                                  CustomText(
                                    status,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 2.1,
                                    color: getColorTypeText(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              state.selectedMyTrip['status'] == "PENDING"
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                          CustomText(
                                            "Auto cancel in:",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            height: 2.1,
                                            color: ColorsCustom.black,
                                          ),
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 14, vertical: 3),
                                              decoration: BoxDecoration(
                                                  color: ColorsCustom
                                                      .primaryOrange,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: CustomText(
                                                "$countdown",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              )),
                                        ])
                                  : SizedBox(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    state.selectedMyTrip['status'] == "PENDING"
                                        ? "Invoice ID"
                                        : "Booking ID",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    height: 2.1,
                                    color: ColorsCustom.black,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              // highlightColor:
                                              //     ColorsCustom.black.withOpacity(0.1),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                            ),
                                            onPressed: () => onCopy(
                                                "${state.selectedMyTrip['booking_code']}"),
                                            child: SvgPicture.asset(
                                              "assets/images/copy.svg",
                                              width: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      CustomText(
                                        "${state.selectedMyTrip['booking_code']}",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 2.1,
                                        color: ColorsCustom.black,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              state.selectedMyTrip['status'] == "PENDING" ||
                                      (state.selectedMyTrip['status'] ==
                                              "CANCELED" &&
                                          state.selectedMyTrip[
                                                  'booking_details'] ==
                                              null &&
                                          state.selectedMyTrip['pickup_point']
                                                  ['latitude'] ==
                                              null)
                                  ? CardWaitingPayment()
                                  : CardBooking(
                                      completed:
                                          state.selectedMyTrip['status'] ==
                                                  "COMPLETED" ||
                                              state.selectedMyTrip['status'] ==
                                                  "MISSED" ||
                                              state.selectedMyTrip['attended'],
                                      isReturn: state.selectedMyTrip['trip']
                                              ['type'] ==
                                          'RETURN',
                                      bookingCode:
                                          state.selectedMyTrip['booking_code'],
                                      bookingId:
                                          state.selectedMyTrip['booking_id'],
                                      addressA:
                                          state.selectedMyTrip['pickup_point']
                                                  ['address'] ??
                                              "-",
                                      addressB: state.selectedMyTrip['trip']
                                              ['trip_group']['route']
                                          ['destination_address'],
                                      coordinatesA: LatLng(
                                          state.selectedMyTrip['pickup_point']
                                              ['latitude'],
                                          state.selectedMyTrip['pickup_point']
                                              ['longitude']),
                                      coordinatesB: LatLng(
                                          state.selectedMyTrip['trip']
                                                  ['trip_group']['route']
                                              ['destination_latitude'],
                                          state.selectedMyTrip['trip']
                                                  ['trip_group']['route']
                                              ['destination_longitude']),
                                      dateA: state.selectedMyTrip['trip']
                                                  ['type'] ==
                                              'RETURN'
                                          ? Utils.formatterDateVertical.format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  state.selectedMyTrip['trip']
                                                      ['departure_time']))
                                          : Utils.formatterDateVertical.format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  state.selectedMyTrip['trip']
                                                      ['departure_time'])),
                                      dateB: state.selectedMyTrip['trip']['type'] == 'RETURN'
                                          ? Utils.formatterDateVertical.format(
                                              DateTime.fromMillisecondsSinceEpoch(state.selectedMyTrip['trip']['departure_time']).add(Duration(
                                                  minutes: state.selectedMyTrip['pickup_point']
                                                      ['time_to_dest'])))
                                          : Utils.formatterDateVertical.format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                      state.selectedMyTrip['trip']['departure_time'])
                                                  .add(Duration(minutes: state.selectedMyTrip['pickup_point']['time_to_dest']))),
                                      differenceAB:
                                          "${state.selectedMyTrip['pickup_point']['time_to_dest'] ~/ 60}h ${state.selectedMyTrip['pickup_point']['time_to_dest'] % 60}m",
                                      pointA:
                                          state.selectedMyTrip['pickup_point']
                                              ['name'],
                                      pointB: state.selectedMyTrip['trip']
                                              ['trip_group']['route']
                                          ['destination_name'],
                                      timeB: state.selectedMyTrip['trip']
                                                  ['type'] ==
                                              'RETURN'
                                          ? Utils.formatterTime.format(DateTime.parse(
                                                  state.selectedMyTrip['trip']
                                                              ['trip_group']
                                                          ['start_date'] +
                                                      " " +
                                                      state.selectedMyTrip['trip']
                                                              ['trip_group']
                                                          ['return_time'])
                                              .add(
                                                  Duration(minutes: state.selectedMyTrip['pickup_point']['time_to_dest'])))
                                          : Utils.formatterTime.format(DateTime.parse(state.selectedMyTrip['trip']['trip_group']['start_date'] + " " + state.selectedMyTrip['trip']['trip_group']['departure_time']).add(Duration(minutes: state.selectedMyTrip['pickup_point']['time_to_dest']))),
                                      timeA: state.selectedMyTrip['trip']
                                                  ['type'] ==
                                              'RETURN'
                                          ? Utils.formatterTime.format(
                                              DateTime.parse(
                                                  state.selectedMyTrip['trip']
                                                              ['trip_group']
                                                          ['start_date'] +
                                                      " " +
                                                      state.selectedMyTrip['trip']
                                                              ['trip_group']
                                                          ['return_time']))
                                          : Utils.formatterTime.format(
                                              DateTime.parse(state.selectedMyTrip['trip']['trip_group']['start_date'] + " " + state.selectedMyTrip['trip']['trip_group']['departure_time'])),
                                    ),
                              state.selectedMyTrip['status'] != "PENDING" ||
                                      (state.selectedMyTrip['status'] !=
                                              "CANCELED" &&
                                          state.selectedMyTrip['invoice'] !=
                                              null)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        (state.selectedMyTrip['details'] ==
                                                        null &&
                                                    state.selectedMyTrip[
                                                            'status'] ==
                                                        "PENDING") ||
                                                (state.selectedMyTrip[
                                                            'details'] ==
                                                        null &&
                                                    state.selectedMyTrip[
                                                            'status'] ==
                                                        "CANCELED")
                                            ? SizedBox()
                                            : BusDetails(
                                                isLoading: state.selectedMyTrip[
                                                        'booking_details'] ==
                                                    null),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8, top: 4),
                                          child: CustomText(
                                            "${AppTranslations.of(context).text("more_info")}",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 2.1,
                                            color: ColorsCustom.black,
                                          ),
                                        ),
                                        MoreInfo(
                                          title:
                                              "${AppTranslations.of(context).text("important_travel_info")}",
                                          icon: 'info_outline',
                                          content: AppTranslations.of(context)
                                                      .currentLanguage ==
                                                  'id'
                                              ? StaticTextId.howToUse
                                              : StaticTextEn.howToUse,
                                        ),
                                        MoreInfo(
                                            title:
                                                "${AppTranslations.of(context).text("terms")}",
                                            icon: 'verified_outline',
                                            content: AppTranslations.of(context)
                                                        .currentLanguage ==
                                                    'id'
                                                ? StaticTextId.termsConditions
                                                : StaticTextEn.termsConditions),
                                        MoreInfo(
                                          title:
                                              "${AppTranslations.of(context).text("refund")}",
                                          icon: 'document_outline',
                                          content: AppTranslations.of(context)
                                                      .currentLanguage ==
                                                  'id'
                                              ? [
                                                  ...StaticTextId.refundPolicy,
                                                  ...StaticTextId
                                                      .reschedulePolicy
                                                ]
                                              : [
                                                  ...StaticTextEn.refundPolicy,
                                                  ...StaticTextEn
                                                      .reschedulePolicy
                                                ],
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8, top: 4),
                                child: CustomText(
                                  "${AppTranslations.of(context).text("payment_info")}",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 2.1,
                                  color: ColorsCustom.black,
                                ),
                              ),
                              PaymentInfo(
                                  hideReceipt: state.selectedMyTrip['status'] ==
                                          "PENDING" ||
                                      (state.selectedMyTrip['status'] !=
                                              "CANCELED" &&
                                          state.selectedMyTrip['invoice'] !=
                                              null)),
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 0),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            color: ColorsCustom.black
                                                .withOpacity(0.15))
                                      ]),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                    ),
                                    //materialTapTargetSize:
                                    //materialTapTargetSize.shrinkWrap,
                                    onPressed: () => Navigator.pushNamed(
                                        context, "/ContactUs"),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          "${AppTranslations.of(context).text("need_a_help")}",
                                          color: ColorsCustom.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                        SvgPicture.asset(
                                          "assets/images/arrow_right.svg",
                                          height: 16,
                                          width: 16,
                                        ),
                                      ],
                                    ),
                                  )),
                              state.selectedMyTrip['status'] == "PENDING"
                                  ? SizedBox(height: 130)
                                  : (state.selectedMyTrip['status'] ==
                                              "ACTIVE" &&
                                          state.selectedMyTrip['details'] !=
                                              null &&
                                          state.selectedMyTrip['details']
                                                  ['status'] ==
                                              'ONGOING')
                                      ? SizedBox(
                                          height: 90,
                                        )
                                      : SizedBox(height: 20),
                              state.selectedMyTrip['status'] == "PENDING" ||
                                      (state
                                                  .selectedMyTrip['status'] ==
                                              "ACTIVE" &&
                                          state.selectedMyTrip['details'] !=
                                              null &&
                                          state.selectedMyTrip['details']
                                                  ['status'] ==
                                              'ONGOING')
                                  ? SizedBox()
                                  : state.selectedMyTrip['status'] ==
                                              "COMPLETED" &&
                                          state.selectedMyTrip['rating'] ==
                                              null &&
                                          state.selectedMyTrip['review'] == null
                                      ? CustomButton(
                                          text:
                                              "${AppTranslations.of(context).text("give_a_review")}",
                                          textColor: Colors.white,
                                          bgColor: ColorsCustom.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => Review(
                                                      isFromDetail: true))),
                                        )
                                      : state.selectedMyTrip['status'] ==
                                                  "COMPLETED" ||
                                              state.selectedMyTrip['status'] ==
                                                  "CANCELED" ||
                                              state.selectedMyTrip['status'] ==
                                                  "MISSED" ||
                                              (state.selectedMyTrip[
                                                          'status'] ==
                                                      "ACTIVE" &&
                                                  state.selectedMyTrip[
                                                          'details'] !=
                                                      null &&
                                                  state.selectedMyTrip[
                                                          'details'] !=
                                                      null &&
                                                  state.selectedMyTrip['details']
                                                          ['status'] ==
                                                      'ONGOING')
                                          ? SizedBox()
                                          : OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 14),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                // borderSide: BorderSide(
                                                //     color: ColorsCustom.primary)
                                              ),
                                              onPressed: () => onConfirmation(),
                                              child: CustomText(
                                                "${AppTranslations.of(context).text("canceled_this_booking")}",
                                                color: ColorsCustom.primary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            )
                            ],
                          ),
                        ],
                      )),
                ),
                state.selectedMyTrip['status'] == "PENDING" ||
                        (state.selectedMyTrip['status'] == "ACTIVE" &&
                            state.selectedMyTrip['details'] != null &&
                            state.selectedMyTrip['details']['status'] ==
                                'ONGOING')
                    ? Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          height: onBottom &&
                                  state.selectedMyTrip['status'] == "PENDING"
                              ? 175
                              : 110,
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 32),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              boxShadow: onBottom &&
                                      state.selectedMyTrip['status'] ==
                                          "PENDING"
                                  ? []
                                  : [
                                      BoxShadow(
                                          offset: Offset(4, 0),
                                          blurRadius: 12,
                                          spreadRadius: 0,
                                          color: Colors.black.withOpacity(0.15))
                                    ]),
                          child: Column(
                            children: [
                              onBottom &&
                                      state.selectedMyTrip['status'] ==
                                          "PENDING"
                                  ? state.selectedMyTrip['status'] ==
                                              "COMPLETED" ||
                                          state.selectedMyTrip['status'] ==
                                              "CANCELED" ||
                                          state.selectedMyTrip['status'] ==
                                              "MISSED"
                                      ? SizedBox()
                                      : Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(top: 8),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              // borderSide: BorderSide(
                                              //     color: ColorsCustom.primary),
                                            ),
                                            onPressed: () => onConfirmation(),
                                            child: CustomText(
                                              "${AppTranslations.of(context).text("canceled_this_booking")}",
                                              color: ColorsCustom.primary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                  : SizedBox(),
                              onBottom &&
                                      state.selectedMyTrip['status'] ==
                                          "PENDING"
                                  ? state.selectedMyTrip['status'] ==
                                              "COMPLETED" ||
                                          state.selectedMyTrip['status'] ==
                                              "CANCELED" ||
                                          state.selectedMyTrip['status'] ==
                                              "MISSED"
                                      ? SizedBox(height: 5)
                                      : SizedBox()
                                  : SizedBox(),
                              CustomButton(
                                text: state.selectedMyTrip['status'] ==
                                        "PENDING"
                                    ? "${AppTranslations.of(context).text("pay")}"
                                    : "${AppTranslations.of(context).text("live_tracking")}",
                                textColor: Colors.white,
                                bgColor: ColorsCustom.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                onPressed: () =>
                                    state.selectedMyTrip['status'] == "PENDING"
                                        ? onPaymentInstructionsClick()
                                        : Navigator.pushNamed(
                                            context, '/LiveTracking'),
                              ),
                            ],
                          ),
                        ))
                    : SizedBox(),
                StoreConnector<AppState, GeneralState>(
                    converter: (store) => store.state.generalState,
                    builder: (context, stateGeneral) {
                      return stateGeneral.isLoading || isLoading
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
                          : SizedBox();
                    }),
                //button check in
                // Positioned(
                //     bottom: 0,
                //     right: 0,
                //     child: Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(20),
                //           color: 0 < distance && distance < 700
                //               ? ColorsCustom.primary
                //               : Colors.grey,
                //         ),
                //         alignment: Alignment.center,
                //         margin: EdgeInsets.all(20),
                //         padding: EdgeInsets.all(25),
                //         child: Text(
                //           'Check In',
                //           style: TextStyle(color: Colors.white),
                //         ))
                //     )
              ],
            ),
          );
        });
  }
}
