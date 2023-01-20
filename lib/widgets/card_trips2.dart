import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class CardTrips2 extends StatefulWidget {
  final String id, title, type, pointA, pointB;
  final DateTime dateA, dateB;
  final bool home;
  final Map data;

  CardTrips2({
    this.title,
    this.type,
    this.pointA,
    this.pointB,
    this.dateA,
    this.dateB,
    this.home: false,
    this.id,
    this.data,
  });

  @override
  _CardTrips2State createState() => _CardTrips2State();
}

class _CardTrips2State extends State<CardTrips2> {
  String status = "";
  String responseStatus = '';
  bool isLoading = true;

  // void toggleIsLoading(bool value) {
  //   setState(() {
  //     isLoading = value;
  //   });
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
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
        onPressed: () => {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: ColorsCustom.newGreenLight.withOpacity(0.1),
                      border: Border.all(color: ColorsCustom.newGreen)
                      // getColorTypeBackground()
                      ,
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: Center(
                    child: CustomText(
                      "Subscribed",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: ColorsCustom.newGreen
                      // getColorTypeText()
                      ,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  'assets/images/checkbox.svg',
                  width: 12,
                ),
                SizedBox(
                  width: 5,
                ),
                CustomText(
                  "1 Month ",
                  color: ColorsCustom.black,
                  fontSize: 10,
                ),
                CustomText(
                  "01/02/2023 - 28/02/2023",
                  color: ColorsCustom.black,
                  fontSize: 10,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  "Departure",
                  color: ColorsCustom.black,
                  fontSize: 14,
                ),
                CustomText(
                  "Return",
                  color: ColorsCustom.black,
                  fontSize: 14,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomText(
                    widget.pointA,
                    color: ColorsCustom.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomText(
                      widget.pointB,
                      color: ColorsCustom.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
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
}
