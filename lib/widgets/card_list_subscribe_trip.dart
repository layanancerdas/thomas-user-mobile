import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/screens/payment_confirmation/payment_confirmation.dart';
import 'package:tomas/screens/payment_webview/screen/payment_webview.dart';
import 'package:tomas/screens/round_trip/round_trip.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:tomas/screens/detail_subscription/screen/detail_subscription.dart';
import 'package:uuid/uuid.dart';

class CardListSubscribeTrip extends StatefulWidget {
  final String pointA,
      pointB,
      addressA,
      addressB,
      differenceAB,
      name,
      month,
      amount;
  CardListSubscribeTrip(
      {this.name,
      this.pointA,
      this.pointB,
      this.addressA,
      this.addressB,
      this.differenceAB,
      this.month,
      this.amount});

  @override
  _CardListSubscribeTripState createState() => _CardListSubscribeTripState();
}

class _CardListSubscribeTripState extends State<CardListSubscribeTrip> {
  String responseStatus = '';
  bool isLoading = true;

  // void toggleIsLoading(bool value) {
  //   setState(() {
  //     isLoading = value;
  //   });
  // }
  void setOrderID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uuid = Uuid();
    var v4 = await uuid.v4();
    prefs.setString('ORDER_ID', v4);
  }

  void setOrderAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('ORDER_AMOUNT', widget.amount);
  }

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
        onPressed: () => {Get.to(RoundTrip())},
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            widget.pointA,
                            color: ColorsCustom.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          CustomText(
                            widget.addressA,
                            color: ColorsCustom.generalText,
                            fontSize: 10,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SvgPicture.asset('assets/images/arrow-switch.svg'),
                          CustomText(
                            widget.differenceAB,
                            color: ColorsCustom.generalText,
                            fontSize: 10,
                            height: 2.4,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            widget.pointB,
                            color: ColorsCustom.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          CustomText(
                            widget.addressB,
                            color: ColorsCustom.generalText,
                            fontSize: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: new TextSpan(
                          text: 'Rp. ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: ColorsCustom.primary,
                              fontFamily: 'Poppins'),
                          children: <TextSpan>[
                            new TextSpan(
                                text: Utils.currencyFormat
                                    .format(int.parse(widget.amount))),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await setOrderID();
                          await setOrderAmount();
                          Get.to(PaymentConfirmation());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ColorsCustom.primary,
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          child: CustomText(
                            "Subscribe Now",
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
