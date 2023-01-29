import 'package:flutter/material.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';

class CardListHome extends StatelessWidget {
  const CardListHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Colors.black12)
      ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                "Menunggu Check In",
                color: ColorsCustom.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Departure",
                color: ColorsCustom.primary,
                fontSize: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "00:00",
                        color: ColorsCustom.black,
                        fontSize: 12,
                      ),
                      CustomText(
                        "Bogor",
                        color: ColorsCustom.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(
                        "Alamat Lengkap",
                        color: ColorsCustom.generalText,
                        fontSize: 10,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.arrow_right_alt,
                        size: 28,
                      ),
                      CustomText(
                        "DD/MM",
                        color: ColorsCustom.black,
                        fontSize: 8,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        "00:00",
                        color: ColorsCustom.black,
                        fontSize: 12,
                      ),
                      CustomText(
                        "Head Office",
                        color: ColorsCustom.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(
                        "Alamat Lengkap",
                        color: ColorsCustom.generalText,
                        fontSize: 10,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: ColorsCustom.newGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            child: CustomText(
              "Check In",
              fontWeight: FontWeight.w600,
              color: Colors.white,
              textAlign: TextAlign.center,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
