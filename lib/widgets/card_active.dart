import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';

class CardActive extends StatelessWidget {
  const CardActive({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Colors.black12)
      ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/images/icon_shift_pagi.svg'),
                  SizedBox(
                    width: 5,
                  ),
                  CustomText(
                    "Shift Pagi",
                    color: ColorsCustom.black,
                    fontSize: 12,
                  ),
                ],
              ),
              CustomText(
                "Mon, 06 Feb 2023",
                color: ColorsCustom.black,
                fontSize: 12,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Departure",
                      color: ColorsCustom.black,
                      fontSize: 12,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            CustomText(
                              "00:00",
                              color: ColorsCustom.black,
                              fontSize: 12,
                            ),
                            CustomText(
                              "Terminal",
                              color: ColorsCustom.black,
                              fontSize: 12,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.arrow_right_alt,
                            ),
                            CustomText(
                              "DD/MM",
                              color: ColorsCustom.black,
                              fontSize: 8,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CustomText(
                              "00:00",
                              color: ColorsCustom.black,
                              fontSize: 12,
                            ),
                            CustomText(
                              "Kantor",
                              color: ColorsCustom.black,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 12,
              ),
              SvgPicture.asset(
                'assets/images/vertical_divider.svg',
                width: 2,
                color: ColorsCustom.black,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Return",
                      color: ColorsCustom.black,
                      fontSize: 12,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            CustomText(
                              "00:00",
                              color: ColorsCustom.black,
                              fontSize: 12,
                            ),
                            CustomText(
                              "Kantor",
                              color: ColorsCustom.black,
                              fontSize: 12,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.arrow_right_alt,
                            ),
                            CustomText(
                              "DD/MM",
                              color: ColorsCustom.black,
                              fontSize: 8,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CustomText(
                              "00:00",
                              color: ColorsCustom.black,
                              fontSize: 12,
                            ),
                            CustomText(
                              "Terminal",
                              color: ColorsCustom.black,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: ColorsCustom.primaryDark)),
            width: double.infinity,
            child: CustomText(
              "Cancel Trip",
              fontWeight: FontWeight.w600,
              color: ColorsCustom.primary,
              textAlign: TextAlign.center,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
