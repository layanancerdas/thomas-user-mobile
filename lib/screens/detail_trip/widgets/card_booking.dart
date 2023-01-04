import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/widgets/map_fullscreen.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class CardBooking extends StatelessWidget {
  final bool completed, isReturn;
  final String bookingCode,
      bookingId,
      timeA,
      timeB,
      dateA,
      dateB,
      differenceAB,
      pointA,
      pointB,
      addressA,
      addressB;
  final LatLng coordinatesA, coordinatesB;

  CardBooking(
      {this.bookingCode,
      this.bookingId,
      this.timeA,
      this.timeB,
      this.differenceAB,
      this.pointA,
      this.pointB,
      this.addressA,
      this.addressB,
      this.coordinatesA,
      this.coordinatesB,
      this.dateA,
      this.dateB,
      this.completed,
      this.isReturn: false});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                  blurRadius: 14,
                  color: ColorsCustom.black.withOpacity(0.12)),
            ]),
        child: Column(children: [
          completed
              ? SizedBox()
              : QrImage(
                  data:
                      "${BASE_API + "/ajk/booking/confirm_attendance?booking_id="}$bookingId",
                  version: QrVersions.auto,
                  size: 200.0,
                ),
          completed ? SizedBox() : SizedBox(height: 10),
          completed
              ? SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                "${AppTranslations.of(context).text("booking_code")}",
                      color: ColorsCustom.generalText,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    CustomText(
                      "$bookingCode",
                      color: ColorsCustom.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
          completed
              ? SizedBox()
              : Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      height: 10,
                      child: Row(
                        children: [
                          Expanded(
                              child: SvgPicture.asset(
                            "assets/images/divider-dotted.svg",
                            width: screenSize.width,
                          )),
                        ],
                      ),
                    ),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        left: -12,
                        child: Center(
                            child: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                              color: Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(12)),
                        ))),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        right: -12,
                        child: Center(
                          child: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                                color: Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ))
                  ],
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    "AJK",
                    color: ColorsCustom.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          "$timeA",
                          fontWeight: FontWeight.w500,
                          color: ColorsCustom.black,
                          fontSize: 14,
                        ),
                        SizedBox(height: 4),
                        CustomText(
                          "$dateA",
                          fontWeight: FontWeight.w400,
                          color: ColorsCustom.generalText,
                          fontSize: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          child: CustomText(
                            "$differenceAB",
                            fontWeight: FontWeight.w500,
                            color: ColorsCustom.generalText,
                            fontSize: 9,
                          ),
                        ),
                        CustomText(
                          "$timeB",
                          fontWeight: FontWeight.w500,
                          color: ColorsCustom.black,
                          fontSize: 14,
                        ),
                        SizedBox(height: 4),
                        CustomText(
                          "$dateB",
                          fontWeight: FontWeight.w400,
                          color: ColorsCustom.generalText,
                          fontSize: 10,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: ColorsCustom.black),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        SizedBox(height: 5),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          height: 82,
                          child: SvgPicture.asset(
                              "assets/images/dotted-very-long-black.svg"),
                        ),
                        SizedBox(height: 5),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 13),
                          child: Icon(
                            Icons.location_on,
                            size: 15,
                            color: ColorsCustom.black,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            "${isReturn ? pointB : pointA}",
                            fontWeight: FontWeight.w500,
                            color: ColorsCustom.black,
                            fontSize: 14,
                            overflow: true,
                          ),
                          SizedBox(height: 5),
                          CustomText(
                            "${isReturn ? addressB : addressA}",
                            fontWeight: FontWeight.w400,
                            color: ColorsCustom.black,
                            fontSize: 12,
                            overflow: true,
                          ),
                          SizedBox(height: 5),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MapFullscreen(
                                          coordinates: coordinatesA,
                                          city:
                                              "${Utils.capitalizeFirstofEach(isReturn ? pointB : pointA)}",
                                          address:
                                              "${Utils.capitalizeFirstofEach(isReturn ? addressB : addressA)}",
                                        ),
                                    fullscreenDialog: true)),
                            child: CustomText(
                            "${AppTranslations.of(context).text("view_on_map")}",
                              fontWeight: FontWeight.w400,
                              color: ColorsCustom.primary,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 35),
                          CustomText(
                            "${isReturn ? pointA : pointB}",
                            fontWeight: FontWeight.w500,
                            color: ColorsCustom.black,
                            fontSize: 14,
                            overflow: true,
                          ),
                          SizedBox(height: 5),
                          CustomText(
                            "${isReturn ? addressA : addressB}",
                            fontWeight: FontWeight.w400,
                            color: ColorsCustom.black,
                            fontSize: 12,
                            overflow: true,
                          ),
                          SizedBox(height: 5),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MapFullscreen(
                                          coordinates: coordinatesB,
                                          city:
                                              "${Utils.capitalizeFirstofEach(isReturn ? pointA : pointB)}",
                                          address:
                                              "${Utils.capitalizeFirstofEach(isReturn ? addressA : addressB)}",
                                        ),
                                    fullscreenDialog: true)),
                            child: CustomText(
                            "${AppTranslations.of(context).text("view_on_map")}",
                              fontWeight: FontWeight.w400,
                              color: ColorsCustom.primary,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ]));
  }
}
