import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/screens/detail_subscription/widget/list_subscription.dart';
import 'package:tomas/widgets/custom_text.dart';

class DetailSubscription extends StatefulWidget {
  final String pointA, pointB;
  DetailSubscription({
    Key key,
    this.pointA,
    this.pointB,
  }) : super(key: key);

  @override
  State<DetailSubscription> createState() => _DetailSubscriptionState();
}

class _DetailSubscriptionState extends State<DetailSubscription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: ListView(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 24,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                CustomText(
                  "Detail Subscription",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
                  // getColorTypeText()
                  ,
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    "Active",
                    color: ColorsCustom.black,
                    fontSize: 14,
                  ),
                  ListSubscription(),
                  CustomText(
                    "Upcoming",
                    color: ColorsCustom.black,
                    fontSize: 14,
                  ),
                  ListSubscription(),
                  ListSubscription(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
