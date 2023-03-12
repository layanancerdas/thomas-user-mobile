import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/screens/payment_webview/screen/payment_webview.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:tomas/screens/detail_subscription/screen/detail_subscription.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class CardList extends StatefulWidget {
  final String pointA,
      pointB,
      addressA,
      addressB,
      month,
      differenceAB,
      name,
      statusPayment,
      urlPayment,
      orderIdPayment,
      startDate,
      endDate;
  CardList(
      {this.name,
      this.month,
      this.pointA,
      this.pointB,
      this.addressA,
      this.addressB,
      this.differenceAB,
      this.statusPayment,
      this.orderIdPayment,
      this.urlPayment,
      this.startDate,
      this.endDate});

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
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
          widget.statusPayment == 'PENDING'
              ? Get.to(PaymentWebView(
                  url: widget.urlPayment,
                  orderId: widget.orderIdPayment,
                ))
              : Get.to(DetailSubscription(
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
                      widget.name,
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
                              widget.month,
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
                          widget.startDate == null || widget.endDate == null
                              ? ''
                              : DateFormat('dd MMMM yyyy').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(widget.startDate))) +
                                  ' - ' +
                                  DateFormat('dd MMMM yyyy').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(widget.endDate))),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      widget.statusPayment == 'SUCCESS'
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: ColorsCustom.primaryGreenVeryLow,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 1, color: ColorsCustom.newGreen)),
                              child: CustomText(
                                widget.statusPayment.toTitleCase(),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: ColorsCustom.newGreen
                                // getColorTypeText()
                                ,
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: ColorsCustom.primaryOrangeVeryLow,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 1,
                                      color: ColorsCustom.primaryOrange)),
                              child: CustomText(
                                widget.statusPayment.toTitleCase(),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: ColorsCustom.primaryOrange
                                // getColorTypeText()
                                ,
                              ),
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
                        child: CustomText(
                          widget.pointB,
                          textAlign: TextAlign.right,
                          color: ColorsCustom.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          widget.addressA,
                          color: ColorsCustom.generalText,
                          fontSize: 10,
                        ),
                      ),
                      CustomText(
                        widget.differenceAB,
                        color: ColorsCustom.generalText,
                        fontSize: 10,
                      ),
                      Expanded(
                        child: CustomText(
                          widget.addressB,
                          textAlign: TextAlign.right,
                          color: ColorsCustom.generalText,
                          fontSize: 10,
                        ),
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
