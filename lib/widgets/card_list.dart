import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:tomas/screens/detail_subscription/screen/detail_subscription.dart';

class CardList extends StatefulWidget {
  final String pointA, pointB;
  CardList({
    this.pointA,
    this.pointB,
  });

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
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
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 24, offset: Offset(0, 4), color: Colors.black12)
          ]),
      child: TextButton(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(),
            // highlightColor: ColorsCustom.black.withOpacity(0.01),
            padding: EdgeInsets.all(0)),
        onPressed: () => {
          Get.to(DetailSubscription(
            pointA: 'terminal',
            pointB: 'kantor',
          ))
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: ColorsCustom.primaryDark,
              ),
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Subscribe AJK',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  SvgPicture.asset('assets/images/vertical_divider.svg',
                      color: Colors.white),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white)
                              // getColorTypeBackground()
                              ,
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: Center(
                            child: CustomText(
                              "1 Month",
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.white
                              // getColorTypeText()
                              ,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        CustomText(
                          "Mon, 06 Feb 23 - Mon, 06 Mar 23",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white
                          // getColorTypeText()
                          ,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/images/map.svg'),
                      SizedBox(
                        width: 8,
                      ),
                      CustomText(
                        "Location Trips",
                        color: ColorsCustom.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
                        color: ColorsCustom.primary,
                        fontSize: 14,
                      ),
                      CustomText(
                        "Return",
                        color: ColorsCustom.primary,
                        fontSize: 14,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6,
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
                      SvgPicture.asset('assets/images/arrow-switch.svg'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        "alamat lengkap",
                        color: ColorsCustom.generalText,
                        fontSize: 10,
                      ),
                      CustomText(
                        "alamat lengkap",
                        color: ColorsCustom.generalText,
                        fontSize: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  CustomText(
                    "View Detail",
                    color: ColorsCustom.primary,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
