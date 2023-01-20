import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class DetailCardTrips2 extends StatefulWidget {
  final String id,
      title,
      type,
      pointA,
      pointB,
      addressA,
      addressB,
      timeA,
      timeB,
      differenceAB;
  final DateTime dateA, dateB;
  final bool home, completed, isReturn;
  final Map data;

  DetailCardTrips2(
      {this.title,
      this.type,
      this.pointA,
      this.pointB,
      this.dateA,
      this.dateB,
      this.home: false,
      this.id,
      this.data,
      this.completed,
      this.addressA,
      this.addressB,
      this.timeA,
      this.timeB,
      this.differenceAB,
      this.isReturn});

  @override
  _DetailCardTrips2State createState() => _DetailCardTrips2State();
}

class _DetailCardTrips2State extends State<DetailCardTrips2> {
  String status = "";
  String responseStatus = '';
  bool isLoading = false;
  bool completed = false;
  bool isReturn = false;
  // void toggleIsLoading(bool value) {
  //   setState(() {
  //     isLoading = value;
  //   });
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width - 32,
      margin: widget.home
          ? EdgeInsets.only(left: 8, right: 4)
          : EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: widget.type == 'Ongoing' ||
                  status ==
                      "${AppTranslations.of(context).text("driver_on_the_way")}" ||
                  status == "${AppTranslations.of(context).text("driver_has_arrived")}"
              ? Border.all(color: ColorsCustom.primaryGreen)
              : null,
          boxShadow: [
            BoxShadow(
                blurRadius: 24, offset: Offset(0, 4), color: Colors.black12)
          ]),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          // highlightColor: ColorsCustom.black.withOpacity(0.01),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onPressed: () => {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/school_bus.svg',
                      height: 23,
                      width: 23,
                    ),
                    SizedBox(width: 16),
                    CustomText(
                      "${widget.title}",
                      // "AJK Packages",
                      color: ColorsCustom.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: ColorsCustom.newGreenLight.withOpacity(0.1),
                      border: Border.all(color: ColorsCustom.newGreen)
                      // getColorTypeBackground()
                      ,
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: Center(
                    child: CustomText(
                      "Subscribed",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: ColorsCustom.newGreen
                      // getColorTypeText()
                      ,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  'assets/images/checkbox.svg',
                  width: 12,
                ),
                SizedBox(
                  width: 5,
                ),
                CustomText(
                  "1 Month ",
                  color: ColorsCustom.black,
                  fontSize: 10,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                          blurRadius: 14,
                          color: ColorsCustom.black.withOpacity(0.12)),
                    ]),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            "AJK Departure",
                            color: ColorsCustom.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(
                                  widget.timeA,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsCustom.black,
                                  fontSize: 14,
                                ),
                                SizedBox(height: 4),
                                CustomText(
                                  Utils.formatterDateWithYear
                                      .format(widget.dateA),
                                  fontWeight: FontWeight.w400,
                                  color: ColorsCustom.generalText,
                                  fontSize: 10,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  child: CustomText(
                                    widget.differenceAB,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsCustom.generalText,
                                    fontSize: 9,
                                  ),
                                ),
                                CustomText(
                                  widget.timeB,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsCustom.black,
                                  fontSize: 14,
                                ),
                                SizedBox(height: 4),
                                CustomText(
                                  Utils.formatterDateWithYear
                                      .format(widget.dateB),
                                  fontWeight: FontWeight.w400,
                                  color: ColorsCustom.generalText,
                                  fontSize: 10,
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
                                          width: 2, color: ColorsCustom.black),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  height: 82,
                                  child: SvgPicture.asset(
                                      "assets/images/dotted-very-long-black.svg"),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 13),
                                  child: Icon(
                                    Icons.location_on,
                                    size: 15,
                                    color: ColorsCustom.black,
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
                                  CustomText(
                                    "${isReturn ? widget.pointB : widget.pointA}",
                                    fontWeight: FontWeight.w500,
                                    color: ColorsCustom.black,
                                    fontSize: 14,
                                    overflow: true,
                                  ),
                                  SizedBox(height: 5),
                                  CustomText(
                                    "${isReturn ? widget.addressB : widget.addressA}",
                                    fontWeight: FontWeight.w400,
                                    color: ColorsCustom.black,
                                    fontSize: 12,
                                    overflow: true,
                                  ),
                                  SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: () => {},
                                    //  Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (_) => MapFullscreen(
                                    //               coordinates: coordinatesA,
                                    //               city:
                                    //                   "${Utils.capitalizeFirstofEach(isReturn ? pointB : pointA)}",
                                    //               address:
                                    //                   "${Utils.capitalizeFirstofEach(isReturn ? addressB : addressA)}",
                                    //             ),
                                    //         fullscreenDialog: true)),
                                    child: CustomText(
                                      "${AppTranslations.of(context).text("view_on_map")}",
                                      fontWeight: FontWeight.w400,
                                      color: ColorsCustom.primary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 35),
                                  CustomText(
                                    "${isReturn ? widget.pointA : widget.pointB}",
                                    fontWeight: FontWeight.w500,
                                    color: ColorsCustom.black,
                                    fontSize: 14,
                                    overflow: true,
                                  ),
                                  SizedBox(height: 5),
                                  CustomText(
                                    "${isReturn ? widget.addressA : widget.addressB}",
                                    fontWeight: FontWeight.w400,
                                    color: ColorsCustom.black,
                                    fontSize: 12,
                                    overflow: true,
                                  ),
                                  SizedBox(height: 5),
                                  GestureDetector(
                                    // onTap: () => Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (_) => MapFullscreen(
                                    //               coordinates: coordinatesB,
                                    //               city:
                                    //                   "${Utils.capitalizeFirstofEach(isReturn ? pointA : pointB)}",
                                    //               address:
                                    //                   "${Utils.capitalizeFirstofEach(isReturn ? addressA : addressB)}",
                                    //             ),
                                    //         fullscreenDialog: true)
                                    //         ),
                                    child: CustomText(
                                      "${AppTranslations.of(context).text("view_on_map")}",
                                      fontWeight: FontWeight.w400,
                                      color: ColorsCustom.primary,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ])),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                          blurRadius: 14,
                          color: ColorsCustom.black.withOpacity(0.12)),
                    ]),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/school_bus.svg',
                                height: 23,
                                width: 23,
                              ),
                              SizedBox(width: 16),
                              CustomText(
                                "Bus Details",
                                color: ColorsCustom.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // isLoading
                        //     // ||
                        //     //     state.selectedMyTrip['details'] == null ||
                        //     //     state.selectedMyTrip['details']['status'] == 'INIT'
                        //     ? Padding(
                        //         padding:
                        //             const EdgeInsets.symmetric(horizontal: 16),
                        //         child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             CustomText(
                        //               "${AppTranslations.of(context).text("coming_soon")}",
                        //               fontSize: 14,
                        //               fontWeight: FontWeight.w300,
                        //               color: ColorsCustom.black,
                        //             ),
                        //             SvgPicture.asset(
                        //               'assets/images/hour_glass.svg',
                        //               height: 18,
                        //               width: 18,
                        //             ),
                        //           ],
                        //         ),
                        //       )
                        //     :
                        Column(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        "${AppTranslations.of(context).text("driver")}",
                                        color: ColorsCustom.generalText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      SizedBox(height: 4),
                                      CustomText(
                                        'test',
                                        // "${state.selectedMyTrip['details']['driver'] != null ? state.selectedMyTrip['details']['driver']['name'] : "-"}",
                                        color: ColorsCustom.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      )
                                    ],
                                  ),
                                ),
                                // state.selectedMyTrip['details']['driver'] !=
                                //             null &&
                                //         state.selectedMyTrip['details']
                                //                 ['driver']['photo'] !=
                                //             null
                                //     ? CircleAvatar(
                                //         backgroundImage: NetworkImage(
                                //             '${BASE_API + "/files/" + state.selectedMyTrip['details']['driver']['photo']}'),
                                //       )
                                //     :
                                CircleAvatar(
                                    backgroundImage: AssetImage(
                                  'assets/images/placeholder_user.png',
                                ))
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey, height: 1),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      "Bis Patas",
                                      // "${state.selectedMyTrip['details']['bus_type'] != null ? state.selectedMyTrip['details']['bus_type']['name'] : "-"}",
                                      color: ColorsCustom.generalText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    CustomText(
                                      "Bis Besar",
                                      // "${state.selectedMyTrip['details']['bus_type'] != null ? state.selectedMyTrip['details']['bus_type']['seats'] : "-"} ${AppTranslations.of(context).text("seats")}",
                                      color: ColorsCustom.generalText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      "Eko Jaya",
                                      // "${state.selectedMyTrip['details']['bus'] != null ? state.selectedMyTrip['details']['bus']['brand'] : "-"}",
                                      color: ColorsCustom.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomText(
                                      "D 122",
                                      // "${state.selectedMyTrip['details']['bus'] != null ? state.selectedMyTrip['details']['bus']['license_plate'] : "-"}",
                                      color: ColorsCustom.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ])
                      ],
                    ),
                  )
                ])),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorsCustom.newGreen),
              child: CustomText(
                "Check In",
                textAlign: TextAlign.center,
                // "${state.selectedMyTrip['details']['bus'] != null ? state.selectedMyTrip['details']['bus']['license_plate'] : "-"}",
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: CustomText(
                "Cancel",
                textAlign: TextAlign.center,
                // "${state.selectedMyTrip['details']['bus'] != null ? state.selectedMyTrip['details']['bus']['license_plate'] : "-"}",
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
