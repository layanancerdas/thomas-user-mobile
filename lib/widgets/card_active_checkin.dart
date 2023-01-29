import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';

class CardActiveCheckIn extends StatelessWidget {
  const CardActiveCheckIn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(12),
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
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "Shift Pagi",
                        color: ColorsCustom.black,
                        fontSize: 10,
                      ),
                      CustomText(
                        "Mon, 06 Feb 2023",
                        fontWeight: FontWeight.w600,
                        color: ColorsCustom.black,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: ColorsCustom.primaryDark,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    CustomText(
                      "Subscribe AJK",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 11,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1, color: Colors.white)),
                      child: CustomText(
                        "1 Month",
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 10,
            color: Colors.black,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SvgPicture.asset('assets/images/map.svg'),
              SizedBox(
                width: 8,
              ),
              CustomText(
                "Location Trip",
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 12,
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    "Departure",
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  CustomText(
                    "00:00",
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  CustomText(
                    "Bogor",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  CustomText(
                    "Alamat Lengkap",
                    color: ColorsCustom.generalText,
                    fontSize: 10,
                  ),
                  Text(
                    "View On Map",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: ColorsCustom.primaryDark,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset('assets/images/arrow-right-new.svg'),
                  CustomText(
                    "DD/MM",
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    "Departure",
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  CustomText(
                    "00:00",
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  CustomText(
                    "Head Office",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  CustomText(
                    "Alamat Lengkap",
                    color: ColorsCustom.generalText,
                    fontSize: 10,
                  ),
                  Text(
                    "View On Map",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: ColorsCustom.primaryDark,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 10,
            color: Colors.black,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    "Return",
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  CustomText(
                    "00:00",
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  CustomText(
                    "Head Office",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  CustomText(
                    "Alamat Lengkap",
                    color: ColorsCustom.generalText,
                    fontSize: 10,
                  ),
                  Text(
                    "View On Map",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: ColorsCustom.primaryDark,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset('assets/images/arrow-right-new.svg'),
                  CustomText(
                    "DD/MM",
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    "Return",
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  CustomText(
                    "00:00",
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  CustomText(
                    "Bogor",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  CustomText(
                    "Alamat Lengkap",
                    color: ColorsCustom.generalText,
                    fontSize: 10,
                  ),
                  Text(
                    "View On Map",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: ColorsCustom.primaryDark,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 10,
            color: Colors.black,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SvgPicture.asset('assets/images/school_bus.svg'),
              SizedBox(
                width: 8,
              ),
              CustomText(
                "Bus Detail",
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 12,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    "Driver",
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  CustomText(
                    "Tino Kartiono",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    "Mini Bus",
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  CustomText(
                    "Toyota Hiace",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      backgroundImage: AssetImage(
                    'assets/images/placeholder_user.png',
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    "12 Seat",
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  CustomText(
                    "B 122 JK",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: ColorsCustom.newGreen,
                borderRadius: BorderRadius.circular(10)),
            width: double.infinity,
            child: CustomText(
              "Check In",
              fontWeight: FontWeight.w600,
              color: Colors.white,
              textAlign: TextAlign.center,
              fontSize: 14,
            ),
          ),
          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 5, offset: Offset(0, 1), color: Colors.black12)
          ]),
    );
  }
}
