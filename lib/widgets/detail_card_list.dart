import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';

class DetailCardList extends StatefulWidget {
  final String pointA, pointB;
  DetailCardList({
    Key key,
    this.pointA,
    this.pointB,
  }) : super(key: key);

  @override
  State<DetailCardList> createState() => _DetailCardListState();
}

class _DetailCardListState extends State<DetailCardList> {
  bool isExpand = true;
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
                  SizedBox(
                    height: 12,
                  ),
                  isExpand
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5,
                                    offset: Offset(0, 1),
                                    color: Colors.black12)
                              ]),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isExpand = !isExpand;
                                  });
                                },
                                child: Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 1,
                                          offset: Offset(0, 1),
                                          color: Colors.black12)
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/images/icon_list.svg'),
                                          SizedBox(
                                            width: 18,
                                          ),
                                          CustomText(
                                            'Mon, 06 Feb 23 — Fri, 10 Feb 23',
                                            color: ColorsCustom.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_up,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/images/icon_shift_pagi.svg'),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    "Departure",
                                                    color: ColorsCustom.black,
                                                    fontSize: 12,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomText(
                                                        "00:00",
                                                        color:
                                                            ColorsCustom.black,
                                                        fontSize: 12,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .arrow_right_alt,
                                                          ),
                                                          CustomText(
                                                            "DD/MM",
                                                            color: ColorsCustom
                                                                .black,
                                                            fontSize: 8,
                                                          ),
                                                        ],
                                                      ),
                                                      CustomText(
                                                        "00:00",
                                                        color:
                                                            ColorsCustom.black,
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    "Return",
                                                    color: ColorsCustom.black,
                                                    fontSize: 12,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomText(
                                                        "00:00",
                                                        color:
                                                            ColorsCustom.black,
                                                        fontSize: 12,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .arrow_right_alt,
                                                          ),
                                                          CustomText(
                                                            "DD/MM",
                                                            color: ColorsCustom
                                                                .black,
                                                            fontSize: 8,
                                                          ),
                                                        ],
                                                      ),
                                                      CustomText(
                                                        "00:00",
                                                        color:
                                                            ColorsCustom.black,
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
                                        SvgPicture.asset(
                                          'assets/images/dot_line.svg',
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              isExpand = !isExpand;
                            });
                          },
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 5,
                                      offset: Offset(0, 1),
                                      color: Colors.black12)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/images/icon_list.svg'),
                                    SizedBox(
                                      width: 18,
                                    ),
                                    CustomText(
                                      'Mon, 06 Feb 23 — Fri, 10 Feb 23',
                                      color: ColorsCustom.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 12,
                  ),
                  CustomText(
                    "Upcoming",
                    color: ColorsCustom.black,
                    fontSize: 14,
                  ),
                  SizedBox(
                    height: 12,
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
