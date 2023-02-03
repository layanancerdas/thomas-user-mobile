import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/configs/static_text_en.dart';
import 'package:tomas/configs/static_text_id.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:tomas/screens/detail_trip/widgets/more_info.dart';
import 'package:tomas/screens/detail_trip/widgets/payment_info.dart';
import 'package:tomas/widgets/custom_text.dart';

class CardActiveCheckIn extends StatelessWidget {
  final String status,
      dateDeparture,
      difference,
      timeDeparture,
      placeDeparture,
      addressDeparture,
      timeArrival,
      placeArrival,
      addressArrival,
      statusPayment;
  final Color color;
  final Function tapMapScreenDeparture, tapMapScreenArrival;
  final Map details;
  const CardActiveCheckIn(
      {Key key,
      this.status,
      this.dateDeparture,
      this.difference,
      this.timeDeparture,
      this.placeDeparture,
      this.addressDeparture,
      this.addressArrival,
      this.placeArrival,
      this.timeArrival,
      this.statusPayment,
      this.color,
      this.tapMapScreenDeparture,
      this.tapMapScreenArrival,
      this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        dateDeparture,
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
          Divider(
            height: 30,
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              CustomText(
                status,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 2.1,
                color: color,
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
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    timeDeparture,
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    placeDeparture,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  CustomText(
                    addressDeparture,
                    color: ColorsCustom.generalText,
                    fontSize: 10,
                  ),
                  InkWell(
                    onTap: () {
                      tapMapScreenDeparture();
                    },
                    child: Text(
                      "View On Map",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: ColorsCustom.primaryDark,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset('assets/images/arrow-right-new.svg'),
                  CustomText(
                    difference,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    "Arrival",
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    timeArrival,
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    placeArrival,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  CustomText(
                    addressArrival,
                    color: ColorsCustom.generalText,
                    fontSize: 10,
                  ),
                  InkWell(
                    onTap: () {
                      tapMapScreenArrival();
                    },
                    child: Text(
                      "View On Map",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: ColorsCustom.primaryDark,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            height: 30,
            color: Colors.black,
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
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    "00:00",
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  SizedBox(
                    height: 10,
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
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    "00:00",
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  SizedBox(
                    height: 10,
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
          Divider(
            height: 30,
            color: Colors.black,
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
          details == null || details['status'] == 'INIT'
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        "${AppTranslations.of(context).text("coming_soon")}",
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: ColorsCustom.black,
                      ),
                      SvgPicture.asset(
                        'assets/images/hour_glass.svg',
                        height: 18,
                        width: 18,
                      ),
                    ],
                  ),
                )
              : Row(
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
                          "${details['driver'] != null ? details['driver']['name'] : "-"}",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomText(
                          "${details['bus_type'] != null ? details['bus_type']['name'] : "-"}",
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        CustomText(
                          "${details['bus'] != null ? details['bus']['brand'] : "-"}",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        details['driver'] != null &&
                                details['driver']['photo'] != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                    '${BASE_API + "/files/" + details['driver']['photo']}'),
                              )
                            : CircleAvatar(
                                backgroundImage: AssetImage(
                                'assets/images/placeholder_user.png',
                              )),
                        SizedBox(
                          height: 10,
                        ),
                        CustomText(
                          "${details['bus_type'] != null ? details['bus_type']['seats'] : "-"} Seats",
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        CustomText(
                          "${details['bus'] != null ? details['bus']['license_plate'] : "-"}",
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
          MoreInfo(
            title:
                "${AppTranslations.of(context).text("important_travel_info")}",
            icon: 'info_outline',
            content: AppTranslations.of(context).currentLanguage == 'id'
                ? StaticTextId.howToUse
                : StaticTextEn.howToUse,
          ),
          MoreInfo(
              title: "${AppTranslations.of(context).text("terms")}",
              icon: 'verified_outline',
              content: AppTranslations.of(context).currentLanguage == 'id'
                  ? StaticTextId.termsConditions
                  : StaticTextEn.termsConditions),
          MoreInfo(
            title: "${AppTranslations.of(context).text("refund")}",
            icon: 'document_outline',
            content: AppTranslations.of(context).currentLanguage == 'id'
                ? [
                    ...StaticTextId.refundPolicy,
                    ...StaticTextId.reschedulePolicy
                  ]
                : [
                    ...StaticTextEn.refundPolicy,
                    ...StaticTextEn.reschedulePolicy
                  ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 4),
            child: CustomText(
              "${AppTranslations.of(context).text("payment_info")}",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 2.1,
              color: ColorsCustom.black,
            ),
          ),
          PaymentInfo(
              hideReceipt:
                  statusPayment == "PENDING" || (statusPayment != "CANCELED")),
          Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0),
                        spreadRadius: 1,
                        blurRadius: 4,
                        color: ColorsCustom.black.withOpacity(0.15))
                  ]),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                //materialTapTargetSize:
                //materialTapTargetSize.shrinkWrap,
                onPressed: () => Navigator.pushNamed(context, "/ContactUs"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "${AppTranslations.of(context).text("need_a_help")}",
                      color: ColorsCustom.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    SvgPicture.asset(
                      "assets/images/arrow_right.svg",
                      height: 16,
                      width: 16,
                    ),
                  ],
                ),
              )),
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
          SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: ColorsCustom.primary)),
            width: double.infinity,
            child: CustomText(
              "Cancel Trip",
              fontWeight: FontWeight.w600,
              color: ColorsCustom.primary,
              textAlign: TextAlign.center,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
