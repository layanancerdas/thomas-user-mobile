import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/widgets/map_fullscreen.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class CardSchedule extends StatelessWidget {
  final String dateA,
      dateB,
      timeA,
      timeB,
      differenceAB,
      pointA,
      pointB,
      addressA,
      addressB;

  final LatLng coordinatesA, coordinatesB;

  CardSchedule({
    this.dateA,
    this.dateB,
    this.timeA,
    this.timeB,
    this.differenceAB,
    this.pointA,
    this.pointB,
    this.addressA,
    this.addressB,
    this.coordinatesA,
    this.coordinatesB,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: ColorsCustom.black.withOpacity(.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  "${dateA ?? "-"}",
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
                  "${dateB ?? "-"}",
                  color: ColorsCustom.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                )
              ],
            ),
            SizedBox(height: 15),
            CustomText(
              "Seat Available : 2",
              color: ColorsCustom.black,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        "${timeA ?? "-"}",
                        fontWeight: FontWeight.w500,
                        color: ColorsCustom.black,
                        fontSize: 14,
                      ),
                      SizedBox(height: 25),
                      CustomText(
                        "${differenceAB ?? "-"}",
                        fontWeight: FontWeight.w500,
                        color: ColorsCustom.black,
                        fontSize: 9,
                      ),
                      SizedBox(height: 26),
                      CustomText(
                        "${timeB ?? "-"}",
                        fontWeight: FontWeight.w500,
                        color: ColorsCustom.black,
                        fontSize: 14,
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
                            border:
                                Border.all(width: 2, color: ColorsCustom.black),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(height: 5),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 64,
                        child: SvgPicture.asset(
                            "assets/images/dotted-long-black.svg"),
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
                          "${pointA ?? "-"}",
                          fontWeight: FontWeight.w500,
                          color: ColorsCustom.black,
                          fontSize: 14,
                        ),
                        SizedBox(height: 5),
                        Flexible(
                          child: CustomText(
                            "${Utils.capitalizeFirstofEach(addressA)}",
                            fontWeight: FontWeight.w400,
                            color: ColorsCustom.black,
                            overflow: true,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 5),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MapFullscreen(
                                        coordinates: coordinatesA,
                                        city:
                                            "${Utils.capitalizeFirstofEach(pointA)}",
                                        address:
                                            "${Utils.capitalizeFirstofEach(addressA)}",
                                      ),
                                  fullscreenDialog: true)),
                          child: CustomText(
                            "${AppTranslations.of(context).text('view_on_map')}",
                            fontWeight: FontWeight.w400,
                            color: ColorsCustom.primary,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 18),
                        CustomText(
                          "${pointB ?? "-"}",
                          fontWeight: FontWeight.w500,
                          color: ColorsCustom.black,
                          fontSize: 14,
                        ),
                        SizedBox(height: 5),
                        Flexible(
                          child: CustomText(
                            "${Utils.capitalizeFirstofEach(addressB)}",
                            overflow: true,
                            fontWeight: FontWeight.w400,
                            color: ColorsCustom.black,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 5),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MapFullscreen(
                                        coordinates: coordinatesB,
                                        city:
                                            "${Utils.capitalizeFirstofEach(pointB)}",
                                        address:
                                            "${Utils.capitalizeFirstofEach(addressB)}",
                                      ),
                                  fullscreenDialog: true)),
                          child: CustomText(
                            "${AppTranslations.of(context).text('view_on_map')}",
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
            ),
          ],
        ),
      ),
    );
  }
}
