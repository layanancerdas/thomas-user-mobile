import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/screens/payment_confirmation/widgets/card_balance.dart';
import 'package:tomas/screens/payment_confirmation/widgets/card_coupon.dart';
import 'package:tomas/screens/payment_confirmation/widgets/card_payment_method.dart';
import 'package:tomas/screens/payment_confirmation/widgets/card_price_details.dart';
import 'package:tomas/screens/payment_confirmation/widgets/card_wallet.dart';
import 'package:tomas/screens/payment_confirmation/widgets/purchase_confirmation.dart';
import 'package:tomas/screens/payment_method/screen/payment_method.dart';
import 'package:tomas/screens/payment_webview/screen/payment_webview.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/custom_text.dart';
import './payment_confirmation_view_model.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:crypto/crypto.dart';

class PaymentConfirmationView extends PaymentConfirmationViewModel {
  @override
  var data = Get.arguments;
  Widget build(BuildContext context) {
    return Scaffold(
      key: paymentConfirmationKey,
      appBar: AppBar(
        leading: TextButton(
          style: TextButton.styleFrom(),
          onPressed: () => Navigator.pop(context),
          child: SvgPicture.asset(
            'assets/images/back_icon.svg',
          ),
        ),
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          "${AppTranslations.of(context).text("payment_confirmation")}",
          color: ColorsCustom.black,
        ),
      ),
      body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            print(state.userState.selectedMyTrip['invoice_id']);
            return SafeArea(
              child: Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                    children: [
                      PurchaseConfirmation(month),
                      state.ajkState.selectedPickUpPoint['price'] <= 0
                          ? SizedBox()
                          : SizedBox(height: 16),

                      CardCoupon(
                        isZeroPrice:
                            state.ajkState.selectedPickUpPoint['price'] <= 0,
                      ),
                      SizedBox(height: 16),

                      int.parse(amountPay) == 0
                          ? SizedBox()
                          : CardPaymentMethod(
                              onTapMethod: () {
                                Get.off(PaymentMethod(
                                  amount: int.parse(amountPay),
                                ));
                              },
                              payment:
                                  data != null ? data['paymentName'] : null,
                            ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 24, bottom: 16),
                      //   child: CustomText(
                      //     "${AppTranslations.of(context).text("price_details")}",
                      //     color: ColorsCustom.black,
                      //     fontWeight: FontWeight.w600,
                      //     fontSize: 14,
                      //   ),
                      // ),
                      // CardPriceDetails()
                    ],
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(24, 15, 8, 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset:
                                    Offset(3, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(children: [
                            StoreConnector<AppState, GeneralState>(
                                converter: (store) => store.state.generalState,
                                builder: (context, stateGeneral) {
                                  return StoreConnector<AppState, UserState>(
                                      converter: (store) =>
                                          store.state.userState,
                                      builder: (context, stateUser) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              "${AppTranslations.of(context).text("total")}",
                                              color: ColorsCustom.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                            CustomText(
                                              amountPay == ''
                                                  ? ''
                                                  : 'Rp. ' +
                                                      Utils.currencyFormat
                                                          .format(int.parse(
                                                              amountPay)),
                                              color: ColorsCustom.primary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ],
                                        );
                                      });
                                }),
                            SizedBox(width: 20),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 170,
                                  child: CustomButton(
                                    onPressed: () => data != null ||
                                            int.parse(amountPay) == 0
                                        ? int.parse(amountPay) == 0
                                            ? onZeroPricePay(state.userState
                                                .selectedMyTrip['invoice_id'])
                                            : onPayClick(data['paymentMethod'],
                                                data['paymentName'])
                                        : Get.snackbar('Warning',
                                            'Pilih payment method terlebih dahulu')
                                    // onNext()
                                    ,
                                    bgColor: data != null ||
                                            int.parse(amountPay) == 0
                                        ? ColorsCustom.primary
                                        : ColorsCustom.newGrey,
                                    textColor: Colors.white,
                                    fontSize: 16,
                                    borderRadius: BorderRadius.circular(12),
                                    fontWeight: FontWeight.w600,
                                    text: "Pay",
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                  ),
                                ),
                              ),
                            )
                          ]))),
                  isLoading
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white70,
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: Loading(
                              color: ColorsCustom.primary,
                              indicator: BallSpinFadeLoaderIndicator(),
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            );
          }),
    );
  }
}
