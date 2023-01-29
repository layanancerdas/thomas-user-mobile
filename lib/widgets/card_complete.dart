import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';

class CardComplete extends StatelessWidget {
  const CardComplete({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            "Mon, 06 Feb 2023",
            color: ColorsCustom.black,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          SizedBox(
            height: 10,
          ),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1, color: ColorsCustom.newGreen)),
                child: CustomText(
                  "Complete",
                  color: ColorsCustom.newGreen,
                  fontSize: 10,
                ),
              )
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "00:00",
                          color: ColorsCustom.black,
                          fontSize: 12,
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
                        CustomText(
                          "00:00",
                          color: ColorsCustom.black,
                          fontSize: 12,
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
                'assets/images/vertical_divider_dotted.svg',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "00:00",
                          color: ColorsCustom.black,
                          fontSize: 12,
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
                        CustomText(
                          "00:00",
                          color: ColorsCustom.black,
                          fontSize: 12,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Divider(
            height: 1,
            color: ColorsCustom.generalText,
          ),
          SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}
