import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/ajk_state.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class CardPriceDetails extends StatefulWidget {
  final String mode;

  CardPriceDetails({this.mode});

  @override
  _CardPriceDetailsState createState() => _CardPriceDetailsState();
}

class _CardPriceDetailsState extends State<CardPriceDetails> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AjkState>(
        converter: (store) => store.state.ajkState,
        builder: (context, state) {
          return StoreConnector<AppState, UserState>(
              converter: (store) => store.state.userState,
              builder: (context, stateUser) {
                return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset.zero,
                              blurRadius: 4,
                              spreadRadius: 1,
                              color: Colors.black.withOpacity(0.15))
                        ]),
                    child: StoreConnector<AppState, GeneralState>(
                        converter: (store) => store.state.generalState,
                        builder: (context, stateGeneral) {
                          // print(stateUser.selectedMyTrip['pickup_point']
                          //     ['price']);
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    "${AppTranslations.of(context).text("shuttle_package_free")}",
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  CustomText(
                                    "Rp${Utils.currencyFormat.format(widget.mode == 'detail' ? stateUser.selectedMyTrip['pickup_point']['price'] * 10 : state.selectedPickUpPoint['price'] * 10)}",
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    "${AppTranslations.of(context).text("voucher_discount")}",
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  widget.mode == 'detail'
                                      ? CustomText(
                                          "Rp${Utils.currencyFormat.format(stateUser.selectedMyTrip['invoice']['discount'])}",
                                          color: ColorsCustom.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        )
                                      : CustomText(
                                          "- Rp${stateGeneral.selectedVouchers.containsKey("voucher_id") ? stateGeneral.selectedVouchers['discount_type'] == 'AMOUNT' ? Utils.currencyFormat.format(stateGeneral.selectedVouchers['discount_amount']) : Utils.currencyFormat.format(state.selectedPickUpPoint['price'] * 10 * (stateGeneral.selectedVouchers['discount_percentage'] * 100) ~/ 100) : 0}",
                                          color: ColorsCustom.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Divider(),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    "${AppTranslations.of(context).text("total_price")}",
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                  widget.mode == 'detail'
                                      ? CustomText(
                                          "Rp${Utils.currencyFormat.format(stateUser.selectedMyTrip['invoice']['total_amount'])}",
                                          color: ColorsCustom.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        )
                                      : CustomText(
                                          "Rp${stateGeneral.selectedVouchers.containsKey("voucher_id") ? stateGeneral.selectedVouchers['discount_type'] == 'AMOUNT' ? Utils.currencyFormat.format(state.selectedPickUpPoint['price'] * 10 - stateGeneral.selectedVouchers['discount_amount']) : Utils.currencyFormat.format(state.selectedPickUpPoint['price'] * 10 - (state.selectedPickUpPoint['price'] * 10 * (stateGeneral.selectedVouchers['discount_percentage'] * 100) ~/ 100)) : Utils.currencyFormat.format(state.selectedPickUpPoint['price'] * 10)}",
                                          color: ColorsCustom.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                ],
                              ),
                            ],
                          );
                        }));
              });
        });
  }
}
