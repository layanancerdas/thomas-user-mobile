import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/ajk_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/widgets/custom_text.dart';

class PurchaseConfirmation extends StatelessWidget {
  final String month;
  PurchaseConfirmation(this.month);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AjkState>(
        converter: (store) => store.state.ajkState,
        builder: (context, state) {
          return StoreConnector<AppState, UserState>(
              converter: (store) => store.state.userState,
              builder: (context, stateUser) {
                print(state.selectedTrip['start_date']);
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: ColorsCustom.primaryVeryLow.withOpacity(0.4),
                      border: Border.all(width: 1, color: ColorsCustom.primary),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 23,
                            width: 23,
                            child: SvgPicture.asset(
                                'assets/images/school_bus.svg'),
                          ),
                          SizedBox(width: 16),
                          Flexible(
                            child: CustomText(
                              "${state.selectedPickUpPoint['name']}",
                              color: ColorsCustom.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              overflow: true,
                            ),
                          ),
                          Container(
                            width: 30,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child:
                                SvgPicture.asset('assets/images/exchange.svg'),
                          ),
                          Flexible(
                            child: CustomText(
                              "${state.selectedRoute['destination_name']}",
                              color: ColorsCustom.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              overflow: true,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      month == '0'
                          ? Row(
                              children: [
                                CustomText(
                                  "${Utils.formatterDate.format(DateTime.parse(state.selectedTrip['start_date'])) ?? "-"}",
                                  color: ColorsCustom.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                                CustomText(
                                  " - ",
                                  color: ColorsCustom.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                ),
                                // Container(
                                //   width: 30,
                                //   margin: EdgeInsets.symmetric(horizontal: 5),
                                //   child: Image.asset('assets/images/arrow.png'),
                                // ),
                                CustomText(
                                  "${Utils.formatterDateWithYear.format(DateTime.parse(state.selectedTrip['end_date'])) ?? "-"}",
                                  color: ColorsCustom.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                )
                              ],
                            )
                          : CustomText(
                              "${month} Subscriptions",
                              color: ColorsCustom.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                    ],
                  ),
                );
              });
        });
  }
}
