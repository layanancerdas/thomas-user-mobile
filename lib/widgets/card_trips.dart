import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:redux/redux.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/before_mytrip/screen/before_mytrip.dart';
import 'package:tomas/screens/lifecycle_manager/lifecycle_manager.dart';
import 'package:tomas/screens/payment_webview/screen/payment_webview.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class CardTrips extends StatefulWidget {
  final String id, title, type, pointA, pointB, differenceAB;
  String page, linkPayment, idEasyRide, orderId;
  Map dataEasyRide;
  final DateTime dateA, dateB, timeA, timeB;
  final bool home;
  final Map data;

  CardTrips(
      {this.title,
      this.type,
      this.pointA,
      this.pointB,
      this.dataEasyRide,
      this.page,
      this.linkPayment,
      this.idEasyRide,
      this.orderId,
      this.dateA,
      this.dateB,
      this.home: false,
      this.id,
      this.data,
      this.differenceAB,
      this.timeA,
      this.timeB});

  @override
  _CardTripsState createState() => _CardTripsState();
}

class _CardTripsState extends State<CardTrips> {
  Store<AppState> store;
  List tripHistory = [];

  String status = "";
  String responseStatus = '';
  bool isLoading = true;

  void toggleIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void getStatusText() {
    // print(widget.data['trip_histories']);
    if (mounted)
      setState(() {
        if (widget.data['status'] == "PENDING") {
          status = "${AppTranslations.of(context).text("waiting_for_payment")}";
        } else if (widget.data['status'] == "COMPLETED") {
          status = "${AppTranslations.of(context).text("completed")}";
        } else if (widget.data['status'] == "CANCELED") {
          status = "${AppTranslations.of(context).text("canceled")}";
        } else if (widget.data['status'] == "MISSED") {
          status = "${AppTranslations.of(context).text("missed_trip")}";
        } else if (widget.data['status'] == "ACTIVE") {
          if (widget.data['booking_note'] != null) {
            if (widget.data['booking_note'] == 'DRIVER_ON_THE_WAY') {
              status =
                  "${AppTranslations.of(context).text("driver_on_the_way")}";
            } else if (widget.data['booking_note'] == 'DRIVER_HAS_ARRIVED') {
              status =
                  "${AppTranslations.of(context).text("driver_has_arrived")}";
            } else if (widget.data['booking_note'] == 'ON_BOARD') {
              status = "${AppTranslations.of(context).text("on_board")}";
            }
          } else {
            status = "${AppTranslations.of(context).text("booking_confirmed")}";
          }
        } else {
          status = widget.type;
        }
      });
    toggleIsLoading(false);
  }

  Color getColorTypeText() {
    if (status == "${AppTranslations.of(context).text("driver_has_arrived")}" ||
        status == "${AppTranslations.of(context).text("driver_on_the_way")}" ||
        widget.type == 'Ongoing') {
      return ColorsCustom.primaryGreenHigh;
    } else if (status ==
        "${AppTranslations.of(context).text("waiting_for_payment")}") {
      return ColorsCustom.primaryOrangeHigh;
    } else if (status == "${AppTranslations.of(context).text("canceled")}" ||
        status == "${AppTranslations.of(context).text("missed_trip")}") {
      return ColorsCustom.primaryHigh;
    } else if (status ==
        "${AppTranslations.of(context).text("booking_confirmed")}") {
      return ColorsCustom.primaryBlueHigh;
    } else if (status == "${AppTranslations.of(context).text("completed")}") {
      return ColorsCustom.generalText;
    } else {
      return Colors.white;
    }
  }

  Color getColorTypeBackground() {
    if (status == "${AppTranslations.of(context).text("driver_has_arrived")}" ||
        status == "${AppTranslations.of(context).text("driver_on_the_way")}" ||
        widget.type == 'Ongoing') {
      return ColorsCustom.primaryGreenVeryLow;
    } else if (status ==
        "${AppTranslations.of(context).text("waiting_for_payment")}") {
      return ColorsCustom.primaryOrangeVeryLow;
    } else if (status == "${AppTranslations.of(context).text("canceled")}" ||
        status == "${AppTranslations.of(context).text("missed_trip")}") {
      return ColorsCustom.primaryVeryLow;
    } else if (status ==
        "${AppTranslations.of(context).text("booking_confirmed")}") {
      return ColorsCustom.primaryBlueVeryLow;
    } else if (status == "${AppTranslations.of(context).text("completed")}") {
      return ColorsCustom.border.withOpacity(0.64);
    } else {
      return Colors.white;
    }
  }

  Future<void> getBookingByGroupId() async {
    try {
      print(widget.id);
      dynamic res = await Providers.getBookingByBookingId(bookingId: widget.id);
      responseStatus = res.data['message'];
      print(res.data);
      store.dispatch(SetSelectedMyTrip(
          selectedMyTrip: res.data['data'],
          getSelectedTrip: [res.data['data']]));
    } catch (e) {
      print(e);
    }
  }

  Future<void> onClick() async {
    store.dispatch(SetIsLoading(isLoading: true));

    if (widget.page == 'pending') {
      Get.to(
        PaymentWebView(
          url: widget.linkPayment,
          orderId: widget.orderId,
          idEasyRide: widget.idEasyRide,
          dataEasyRide: widget.dataEasyRide,
          page: 'easyride',
        ),
      );
      store.dispatch(SetIsLoading(isLoading: false));
    } else {
      await getBookingByGroupId();
      if (responseStatus == 'SUCCESS') {
        Navigator.pushNamed(context, "/DetailTrip");
        store.dispatch(SetIsLoading(isLoading: false));
      } else {}
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
      getStatusText();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return
        // widget.type == 'Waiting for Payment' ||
        //         (widget.type == 'Canceled' &&
        //             widget.data['invoice']['status'] == 'PENDING')
        //     ? waitingForPayment(context):
        Container(
      width: screenSize.width - 32,
      margin: widget.home
          ? EdgeInsets.only(left: 8, right: 4)
          : EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: widget.type == 'Ongoing' ||
                  status ==
                      "${AppTranslations.of(context).text("driver_on_the_way")}" ||
                  status == "${AppTranslations.of(context).text("driver_has_arrived")}"
              ? Border.all(color: ColorsCustom.primaryGreen)
              : null,
          boxShadow: [
            BoxShadow(
                blurRadius: 24, offset: Offset(0, 4), color: Colors.black12)
          ]),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          // highlightColor: ColorsCustom.black.withOpacity(0.01),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onPressed: () => onClick(),
        // Get.to(BeforeMyTrip()
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/school_bus.svg',
                      height: 23,
                      width: 23,
                    ),
                    SizedBox(width: 16),
                    CustomText(
                      "${widget.title}",
                      // "AJK Packages",
                      color: ColorsCustom.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: getColorTypeBackground(),
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: Center(
                    child: CustomText(
                      "${isLoading ? "Loading..." : status}",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: getColorTypeText(),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    "${Utils.formatterDateWithYear.format(widget.dateA)}",
                    color: ColorsCustom.black,
                    fontWeight: FontWeight.w500,
                    height: 2.4,
                    fontSize: 10,
                  ),
                  CustomText(
                    "${Utils.formatterDateWithYear.format(widget.dateB)}",
                    color: ColorsCustom.black,
                    fontWeight: FontWeight.w500,
                    height: 2.4,
                    fontSize: 10,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomText(
                    "${Utils.formatterTime.format(widget.timeA)}",
                    color: ColorsCustom.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Container(
                  width: 30,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: SvgPicture.asset('assets/images/arrow-black.svg'),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomText(
                      "${Utils.formatterTime.format(widget.timeB)}",
                      color: ColorsCustom.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomText(
                    // "${widget.pointA}",
                    "${widget.pointA}",
                    color: ColorsCustom.black,
                    fontWeight: FontWeight.w400,
                    overflow: true,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 10),
                CustomText(
                  "${widget.differenceAB}",
                  color: ColorsCustom.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  height: 1,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomText(
                      "${widget.pointB}",
                      textAlign: TextAlign.end,
                      color: ColorsCustom.black,
                      fontWeight: FontWeight.w400,
                      overflow: true,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget waitingForPayment(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width - 32,
      margin: widget.home
          ? EdgeInsets.only(left: 8, right: 4)
          : EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                blurRadius: 24, offset: Offset(0, 4), color: Colors.black12)
          ]),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          // highlightColor: ColorsCustom.black.withOpacity(0.01),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onPressed: () => onClick(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/school_bus.svg',
                      height: 23,
                      width: 23,
                    ),
                    SizedBox(width: 16),
                    CustomText(
                      // "${widget.title}",
                      "${AppTranslations.of(context).text("ajk_packages")}",
                      color: ColorsCustom.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: getColorTypeBackground(),
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: Center(
                    child: CustomText(
                      "${widget.type}",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: getColorTypeText(),
                    ),
                  ),
                )
              ],
            ),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Round Trip ${Utils.formatterDate.format(widget.dateA)} - ${Utils.formatterDateWithYear.format(widget.dateB)}",
                      color: ColorsCustom.black,
                      fontWeight: FontWeight.w500,
                      height: 2.4,
                      fontSize: 10,
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            CustomText(
                              "${Utils.formatterTime.format(widget.timeA)}",
                              color: ColorsCustom.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            SizedBox(height: 8),
                            CustomText(
                              "${Utils.formatterTime.format(widget.timeB)}",
                              color: ColorsCustom.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ],
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    "${widget.pointA}",
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: SvgPicture.asset(
                                      'assets/images/arrow-black.svg'),
                                ),
                                Expanded(
                                  child: CustomText(
                                    "${widget.pointB}",
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    "${widget.pointB}",
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: SvgPicture.asset(
                                      'assets/images/arrow-black.svg'),
                                ),
                                Expanded(
                                  child: CustomText(
                                    "${widget.pointA}",
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
