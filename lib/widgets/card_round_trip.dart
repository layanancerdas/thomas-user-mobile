import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class CardRoundtrip extends StatelessWidget {
  final String name,
      price,
      timeA,
      timeB,
      timeC,
      timeD,
      differenceAB,
      differenceCD,
      distance,
      locationA,
      locationB,
      locationC,
      locationD,
      color,
      week;
  final Map data;
  final bool isActive;
  final onBook;

  CardRoundtrip(
      {this.name,
      this.price,
      this.timeA,
      this.timeB,
      this.timeC,
      this.timeD,
      this.differenceAB,
      this.differenceCD,
      this.locationA,
      this.locationB,
      this.color: 'blue',
      this.distance,
      this.onBook,
      this.data,
      this.locationC,
      this.locationD,
      this.week,
      this.isActive});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 4),
                spreadRadius: 0,
                blurRadius: 14,
                color: ColorsCustom.black.withOpacity(0.12))
          ]),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        onPressed: () => onBook(data),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        // "${name.length > 25 ? name.substring(0, 24) + "..." : name}",
                        "AJK Shuttle",
                        fontWeight: FontWeight.w600,
                        color: ColorsCustom.black,
                        fontSize: 14,
                      ),
                      // RichText(
                      //   text: new TextSpan(
                      //     text: 'Rp',
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 14,
                      //         color: ColorsCustom.primary,
                      //         fontFamily: 'Poppins'),
                      //     children: <TextSpan>[
                      //       new TextSpan(text: '$price'),
                      //       new TextSpan(
                      //           text: '/pkg',
                      //           style: TextStyle(
                      //             color: ColorsCustom.black,
                      //             fontWeight: FontWeight.w400,
                      //             fontSize: 12,
                      //           )),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/images/round-trip.svg",
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 8),
                      RichText(
                        text: new TextSpan(
                          text: AppTranslations.of(context).currentLanguage ==
                                  'id'
                              ? "Trip PP"
                              : 'Round Trip ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: ColorsCustom.black,
                              fontFamily: 'Poppins'),
                          children: <TextSpan>[
                            new TextSpan(
                                text: ' $week',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomText(
                                    "$timeA",
                                    fontWeight: FontWeight.w500,
                                    color: ColorsCustom.black,
                                    fontSize: 12,
                                  ),
                                  SizedBox(height: 10),
                                  CustomText(
                                    "$differenceAB",
                                    fontWeight: FontWeight.w500,
                                    color: ColorsCustom.black,
                                    fontSize: 9,
                                  ),
                                  SizedBox(height: 10),
                                  CustomText(
                                    "$timeB",
                                    fontWeight: FontWeight.w500,
                                    color: ColorsCustom.black,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 15, right: 15, top: 5),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: color == 'blue'
                                              ? ColorsCustom.tosca
                                              : color == 'yellow'
                                                  ? ColorsCustom.yellow
                                                  : ColorsCustom.green,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      height: 29,
                                      child: SvgPicture.asset(
                                          "assets/images/dotted-$color.svg")),
                                  SizedBox(height: 5),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 13),
                                    child: Icon(
                                      Icons.location_on,
                                      size: 15,
                                      color: color == 'blue'
                                          ? ColorsCustom.tosca
                                          : color == 'yellow'
                                              ? ColorsCustom.yellow
                                              : ColorsCustom.green,
                                    ),
                                  ),
                                ],
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: CustomText(
                                        "$locationA",
                                        fontWeight: FontWeight.w500,
                                        color: ColorsCustom.black,
                                        overflow: true,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 33),
                                    Flexible(
                                      child: CustomText(
                                        "$locationB",
                                        fontWeight: FontWeight.w500,
                                        overflow: true,
                                        color: ColorsCustom.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        constraints: BoxConstraints(minHeight: 40),
                        margin: EdgeInsets.only(right: 10, left: 10),
                        color: ColorsCustom.softGrey,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomText(
                                    "$timeC",
                                    fontWeight: FontWeight.w500,
                                    color: ColorsCustom.black,
                                    fontSize: 12,
                                  ),
                                  SizedBox(height: 10),
                                  CustomText(
                                    "$differenceCD",
                                    fontWeight: FontWeight.w500,
                                    color: ColorsCustom.black,
                                    fontSize: 9,
                                  ),
                                  SizedBox(height: 10),
                                  CustomText(
                                    "$timeD",
                                    fontWeight: FontWeight.w500,
                                    color: ColorsCustom.black,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 15, right: 15, top: 5),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: color == 'blue'
                                              ? ColorsCustom.tosca
                                              : color == 'yellow'
                                                  ? ColorsCustom.yellow
                                                  : ColorsCustom.green,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 29,
                                    child: SvgPicture.asset(
                                        "assets/images/dotted-$color.svg"),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 13),
                                    child: Icon(
                                      Icons.location_on,
                                      size: 15,
                                      color: color == 'blue'
                                          ? ColorsCustom.tosca
                                          : color == 'yellow'
                                              ? ColorsCustom.yellow
                                              : ColorsCustom.green,
                                    ),
                                  ),
                                ],
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: CustomText(
                                        "$locationC",
                                        fontWeight: FontWeight.w500,
                                        color: ColorsCustom.black,
                                        fontSize: 12,
                                        overflow: true,
                                      ),
                                    ),
                                    SizedBox(height: 33),
                                    Flexible(
                                      child: CustomText(
                                        "$locationD",
                                        fontWeight: FontWeight.w500,
                                        color: ColorsCustom.black,
                                        fontSize: 12,
                                        overflow: true,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  height: 10,
                  child: Row(
                    children: [
                      Expanded(
                          child: SvgPicture.asset(
                        "assets/images/divider-dotted.svg",
                        width: screenSize.width,
                      )),
                    ],
                  ),
                ),
                Positioned(
                    top: 9,
                    left: -12,
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                          color: Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(12)),
                    )),
                Positioned(
                    top: 9,
                    right: -12,
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                          color: Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(12)),
                    ))
              ],
            ),
            Container(
              // color: Colors.red,
              padding: const EdgeInsets.only(left: 24, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // RichText(
                  //   text: new TextSpan(
                  //     text: 'Rp',
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 14,
                  //         color: ColorsCustom.primary,
                  //         fontFamily: 'Poppins'),
                  //     children: <TextSpan>[
                  //       new TextSpan(text: '$price'),
                  //       new TextSpan(
                  //           text: '/pkg',
                  //           style: TextStyle(
                  //             color: ColorsCustom.black,
                  //             fontWeight: FontWeight.w400,
                  //             fontSize: 12,
                  //           )),
                  //     ],
                  //   ),
                  // ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     SizedBox(
                  //       width: 20,
                  //       height: 20,
                  //       child: SvgPicture.asset("assets/images/route-$color.svg"),
                  //     ),
                  //     SizedBox(width: 8),
                  //     CustomText(
                  //       "$distance Km",
                  //       fontWeight: FontWeight.w400,
                  //       color: ColorsCustom.black,
                  //       fontSize: 12,
                  //     ),
                  //   ],
                  // ),
                  StoreConnector<AppState, UserState>(
                      converter: (store) => store.state.userState,
                      builder: (context, stateUser) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isActive
                                ? ColorsCustom.primary
                                : ColorsCustom.newGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 18),
                            elevation: 1,
                          ),
                          //materialTapTargetSize:
                          //materialTapTargetSize.shrinkWrap,

                          onPressed: () => onBook(data),

                          child: Center(
                            child: CustomText(
                              AppTranslations.of(context).currentLanguage ==
                                      'id'
                                  ? "Pesan Sekarang"
                                  : "Book Now",
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
