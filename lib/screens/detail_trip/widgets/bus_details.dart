import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class BusDetails extends StatelessWidget {
  final bool isLoading;

  BusDetails({this.isLoading: true});

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
                        offset: Offset(0, 0),
                        spreadRadius: 1,
                        blurRadius: 4,
                        color: ColorsCustom.black.withOpacity(0.15))
                  ]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/images/school_bus.svg',
                            height: 24,
                            width: 24,
                          ),
                          SizedBox(width: 16),
                          CustomText(
                            "${AppTranslations.of(context).text("bus_details")}",
                            color: ColorsCustom.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14),
                    isLoading ||
                            state.selectedMyTrip['details'] == null ||
                            state.selectedMyTrip['details']['status'] == 'INIT'
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        : Column(children: [
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
                                          "${state.selectedMyTrip['details']['driver'] != null ? state.selectedMyTrip['details']['driver']['name'] : "-"}",
                                          color: ColorsCustom.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        )
                                      ],
                                    ),
                                  ),
                                  state.selectedMyTrip['details']['driver'] !=
                                              null &&
                                          state.selectedMyTrip['details']
                                                  ['driver']['photo'] !=
                                              null
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              '${BASE_API + "/files/" + state.selectedMyTrip['details']['driver']['photo']}'),
                                        )
                                      : CircleAvatar(
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
                                        "${state.selectedMyTrip['details']['bus_type'] != null ? state.selectedMyTrip['details']['bus_type']['name'] : "-"}",
                                        color: ColorsCustom.generalText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      CustomText(
                                        "${state.selectedMyTrip['details']['bus_type'] != null ? state.selectedMyTrip['details']['bus_type']['seats'] : "-"} ${AppTranslations.of(context).text("seats")}",
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
                                        "${state.selectedMyTrip['details']['bus'] != null ? state.selectedMyTrip['details']['bus']['brand'] : "-"}",
                                        color: ColorsCustom.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      CustomText(
                                        "${state.selectedMyTrip['details']['bus'] != null ? state.selectedMyTrip['details']['bus']['license_plate'] : "-"}",
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
                  ]));
        });
  }
}
