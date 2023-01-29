import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';

class ListSubscription extends StatefulWidget {
  const ListSubscription({Key key}) : super(key: key);

  @override
  State<ListSubscription> createState() => _ListSubscriptionState();
}

class _ListSubscriptionState extends State<ListSubscription> {
  bool isExpand = true;
  @override
  Widget build(BuildContext context) {
    return isExpand
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 12),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/images/icon_list.svg'),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
              margin: EdgeInsets.symmetric(vertical: 12),
              width: double.maxFinite,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 5, offset: Offset(0, 1), color: Colors.black12)
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/images/icon_list.svg'),
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
          );
  }
}
