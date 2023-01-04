import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/map_fullscreen.dart';
import 'package:tomas/localization/app_translations.dart';

class CardWaitingPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserState>(
        converter: (store) => store.state.userState,
        builder: (context, state) {
          return Container(
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
                oneSection(
                  isReturn: state.selectedMyTrip['trip']['type'] == 'RETURN',
                  coordinateA: LatLng(
                      state.selectedMyTrip['pickup_point']['latitude'],
                      state.selectedMyTrip['pickup_point']['longitude']),
                  coordinateB: LatLng(
                      state.selectedMyTrip['trip']['trip_group']['route']
                          ['destination_latitude'],
                      state.selectedMyTrip['trip']['trip_group']['route']
                          ['destination_longitude']),
                  addressA: state.selectedMyTrip['pickup_point']['address'],
                  addressB: state.selectedMyTrip['trip']['trip_group']['route']
                      ['destination_address'],
                  pointA: state.selectedMyTrip['pickup_point']['name'],
                  pointB: state.selectedMyTrip['trip']['trip_group']['route']
                      ['destination_name'],
                  dateB: DateTime.parse(state.selectedMyTrip['trip']
                          ['trip_group']['end_date'] +
                      " " +
                      state.selectedMyTrip['trip']['trip_group']
                          ['departure_time']),
                  dateA: DateTime.parse(state.selectedMyTrip['trip']
                              ['trip_group']['start_date'] +
                          " " +
                          state.selectedMyTrip['trip']['trip_group']
                              ['departure_time'])
                      .add(Duration(
                          minutes: state.selectedMyTrip['pickup_point']
                              ['time_to_dest'])),
                  timeB: DateTime.parse(state.selectedMyTrip['trip']
                              ['trip_group']['start_date'] +
                          " " +
                          state.selectedMyTrip['trip']['trip_group']
                              ['departure_time'])
                      .add(Duration(
                          minutes: state.selectedMyTrip['pickup_point']
                              ['time_to_dest'])),
                  timeA: DateTime.parse(state.selectedMyTrip['trip']
                          ['trip_group']['start_date'] +
                      " " +
                      state.selectedMyTrip['trip']['trip_group']
                          ['departure_time']),
                  differenceAB:
                      "${state.selectedMyTrip['pickup_point']['time_to_dest'] ~/ 60}h ${state.selectedMyTrip['pickup_point']['time_to_dest'] % 60}m",
                  context: context,
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
                            width: double.infinity,
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
                oneSection(
                  isReturn: state.selectedMyTrip['trip']['type'] == 'RETURN',
                  coordinateB: LatLng(
                      state.selectedMyTrip['pickup_point']['latitude'],
                      state.selectedMyTrip['pickup_point']['longitude']),
                  coordinateA: LatLng(
                      state.selectedMyTrip['trip']['trip_group']['route']
                          ['destination_latitude'],
                      state.selectedMyTrip['trip']['trip_group']['route']
                          ['destination_longitude']),
                  addressB: state.selectedMyTrip['pickup_point']['address'],
                  addressA: state.selectedMyTrip['trip']['trip_group']['route']
                      ['destination_address'],
                  pointB: state.selectedMyTrip['pickup_point']['name'],
                  pointA: state.selectedMyTrip['trip']['trip_group']['route']
                      ['destination_name'],
                  dateB: DateTime.parse(state.selectedMyTrip['trip']
                          ['trip_group']['end_date'] +
                      " " +
                      state.selectedMyTrip['trip']['trip_group']
                          ['departure_time']),
                  dateA: DateTime.parse(state.selectedMyTrip['trip']
                              ['trip_group']['start_date'] +
                          " " +
                          state.selectedMyTrip['trip']['trip_group']
                              ['departure_time'])
                      .add(Duration(
                          minutes: state.selectedMyTrip['pickup_point']
                              ['time_to_dest'])),
                  timeB: DateTime.parse(state.selectedMyTrip['trip']
                              ['trip_group']['start_date'] +
                          " " +
                          state.selectedMyTrip['trip']['trip_group']
                              ['return_time'])
                      .add(Duration(
                          minutes: state.selectedMyTrip['pickup_point']
                              ['time_to_dest'])),
                  timeA: DateTime.parse(state.selectedMyTrip['trip']
                          ['trip_group']['start_date'] +
                      " " +
                      state.selectedMyTrip['trip']['trip_group']
                          ['return_time']),
                  differenceAB:
                      "${state.selectedMyTrip['pickup_point']['time_to_dest'] ~/ 60}h ${state.selectedMyTrip['pickup_point']['time_to_dest'] % 60}m",
                  context: context,
                ),
              ]));
        });
  }

  Widget oneSection(
      {BuildContext context,
      DateTime dateA,
      DateTime dateB,
      DateTime timeA,
      DateTime timeB,
      String differenceAB,
      String pointA,
      String pointB,
      String addressA,
      String addressB,
      bool isReturn: false,
      LatLng coordinateA,
      LatLng coordinateB}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 8),
                height: 20,
                width: 20,
                child: SvgPicture.asset('assets/images/school_bus.svg'),
              ),
              CustomText(
                "${AppTranslations.of(context).text("every")}",
                color: ColorsCustom.black,
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
              CustomText(
                Utils.formatterDate.format(dateA) ?? "-",
                color: ColorsCustom.black,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              CustomText(
                " - ",
                color: ColorsCustom.black,
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
              CustomText(
                Utils.formatterDateWithYear.format(dateB) ?? "-",
                color: ColorsCustom.black,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              )
            ],
          ),
          SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      Utils.formatterTime.format(timeA) ?? "-",
                      fontWeight: FontWeight.w500,
                      color: ColorsCustom.black,
                      fontSize: 14,
                    ),
                    SizedBox(height: 25),
                    CustomText(
                      differenceAB,
                      fontWeight: FontWeight.w500,
                      color: ColorsCustom.black,
                      fontSize: 9,
                    ),
                    SizedBox(height: 26),
                    CustomText(
                      Utils.formatterTime.format(timeB) ?? "-",
                      fontWeight: FontWeight.w500,
                      color: ColorsCustom.black,
                      fontSize: 14,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 2, color: ColorsCustom.black),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 64,
                      child: SvgPicture.asset(
                          "assets/images/dotted-long-black.svg"),
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
                        "${isReturn ? pointB : pointA}",
                        fontWeight: FontWeight.w500,
                        color: ColorsCustom.black,
                        fontSize: 14,
                      ),
                      SizedBox(height: 5),
                      Flexible(
                        child: CustomText(
                          "${Utils.capitalizeFirstofEach(isReturn ? addressB : addressA)}",
                          fontWeight: FontWeight.w400,
                          color: ColorsCustom.black,
                          fontSize: 12,
                          overflow: true,
                        ),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MapFullscreen(
                                      coordinates: coordinateA,
                                      city:
                                          "${Utils.capitalizeFirstofEach(isReturn ? pointB : pointA)}",
                                      address:
                                          "${Utils.capitalizeFirstofEach(isReturn ? addressB : addressA)}",
                                    ),
                                fullscreenDialog: true)),
                        child: CustomText(
                          "${AppTranslations.of(context).text("view_on_map")}",
                          fontWeight: FontWeight.w400,
                          color: ColorsCustom.primary,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 18),
                      CustomText(
                        "${isReturn ? pointA : pointB}",
                        fontWeight: FontWeight.w500,
                        color: ColorsCustom.black,
                        fontSize: 14,
                      ),
                      SizedBox(height: 5),
                      Flexible(
                        child: CustomText(
                          "${Utils.capitalizeFirstofEach(isReturn ? addressA : addressB)}",
                          fontWeight: FontWeight.w400,
                          color: ColorsCustom.black,
                          fontSize: 12,
                          overflow: true,
                        ),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MapFullscreen(
                                      coordinates: coordinateB,
                                      city:
                                          "${Utils.capitalizeFirstofEach(isReturn ? pointA : pointB)}",
                                      address:
                                          "${Utils.capitalizeFirstofEach(isReturn ? addressA : addressB)}",
                                    ),
                                fullscreenDialog: true)),
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
          ),
        ],
      ),
    );
  }
}
