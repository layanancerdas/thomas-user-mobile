import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/configs/static_text_en.dart';
import 'package:tomas/configs/static_text_id.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/ajk_state.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/redux/modules/transaction_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class CardInstructor extends StatefulWidget {
  final bool isLoading;
  final Map dataPayment, paymentMethod;

  CardInstructor({this.dataPayment, this.paymentMethod, this.isLoading});

  @override
  _CardInstructorState createState() => _CardInstructorState();
}

class _CardInstructorState extends State<CardInstructor> {
  List getInstructor(value) {
    String name = value.toLowerCase().replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    if (name == 'ovo') {
      return AppTranslations.of(context).currentLanguage == 'id'
          ? StaticTextId.paymentInstructorOvo
          : StaticTextEn.paymentInstructorOvo;
    } else if (name == 'gopay') {
      return AppTranslations.of(context).currentLanguage == 'id'
          ? StaticTextId.paymentInstructorGopay
          : StaticTextEn.paymentInstructorGopay;
    } else if (name == 'linkaja') {
      return AppTranslations.of(context).currentLanguage == 'id'
          ? StaticTextId.paymentInstructorLinkAja
          : StaticTextEn.paymentInstructorLinkAja;
    } else if (name == 'dana') {
      return AppTranslations.of(context).currentLanguage == 'id'
          ? StaticTextId.paymentInstructorDana
          : StaticTextEn.paymentInstructorDana;
    } else if (name == 'shopeepay') {
      return AppTranslations.of(context).currentLanguage == 'id'
          ? StaticTextId.paymentInstructorShopeePay
          : StaticTextEn.paymentInstructorShopeePay;
    } else {
      return ["No Data."];
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserState>(
        converter: (store) => store.state.userState,
        builder: (context, state) {
          return Card(
              elevation: 3,
              shadowColor: ColorsCustom.black.withOpacity(.35),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: StoreConnector<AppState, TransactionState>(
                      converter: (store) => store.state.transactionState,
                      builder: (context, stateTransaction) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: widget.isLoading
                                        ? Center(
                                            child: SizedBox(
                                            width: 17,
                                            height: 17,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(Colors.white),
                                            ),
                                          ))
                                        : Image.network(
                                            "$BASE_API/files/${stateTransaction.selectedPaymentMethod.containsKey("logo") ? stateTransaction.selectedPaymentMethod['logo'] : widget.paymentMethod['logo']}",
                                            // loadingBuilder: (context, child,
                                            //     loadingProgress) {
                                            //   if (loadingProgress == null) {
                                            //     return child;
                                            //   } else {
                                            //     return Center(
                                            //         child: SizedBox(
                                            //       width: 17,
                                            //       height: 17,
                                            //       child:
                                            //           CircularProgressIndicator(
                                            //         strokeWidth: 2.5,
                                            //         valueColor:
                                            //             new AlwaysStoppedAnimation<
                                            //                     Color>(
                                            //                 Colors.white),
                                            //       ),
                                            //     ));
                                            //     // You can use LinearProgressIndicator or CircularProgressIndicator instead
                                            //   }
                                            // },
                                            // errorBuilder:
                                            //     (context, error, stackTrace) =>
                                            //         SizedBox(),
                                          ),
                                  ),
                                  SizedBox(width: 14),
                                  CustomText(
                                    "${stateTransaction.selectedPaymentMethod.containsKey("name") ? stateTransaction.selectedPaymentMethod['name'] : widget.paymentMethod['name']}",
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              StoreConnector<AppState, GeneralState>(
                                  converter: (store) =>
                                      store.state.generalState,
                                  builder: (context, stateGeneral) {
                                    return StoreConnector<AppState, AjkState>(
                                        converter: (store) =>
                                            store.state.ajkState,
                                        builder: (context, stateAjk) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomText(
                                                "${AppTranslations.of(context).text("payment_total")}",
                                                color: ColorsCustom.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                              // widget.detail
                                              //     ? CustomText(
                                              //         "Rp${Utils.currencyFormat.format(state.selectedMyTrip['invoice']['total_amount'])}",
                                              //         color:
                                              //             ColorsCustom.primary,
                                              //         fontWeight:
                                              //             FontWeight.w600,
                                              //         fontSize: 14,
                                              //       )
                                              //     :
                                              CustomText(
                                                "Rp${stateGeneral.selectedVouchers.containsKey("voucher_id") ? stateGeneral.selectedVouchers['discount_type'] == 'AMOUNT' ? Utils.currencyFormat.format(stateAjk.selectedPickUpPoint['price'] * 10 - stateGeneral.selectedVouchers['discount_amount']) : Utils.currencyFormat.format(stateAjk.selectedPickUpPoint['price'] * 10 - (stateAjk.selectedPickUpPoint['price'] * 10 * (stateGeneral.selectedVouchers['discount_percentage'] * 100) ~/ 100)) : Utils.currencyFormat.format(stateAjk.selectedPickUpPoint['price'] * 10)}",
                                                color: ColorsCustom.primary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ],
                                          );
                                        });
                                  }),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  CustomText(
                                    "Invoice ID: ",
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  CustomText(
                                    "${state.selectedMyTrip['booking_code'] ?? "-"}",
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                child: Divider(),
                              ),
                              CustomText(
                                "${AppTranslations.of(context).text("payment_instruction")}",
                                color: ColorsCustom.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                              SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: getInstructor(stateTransaction
                                              .selectedPaymentMethod
                                              .containsKey("name")
                                          ? stateTransaction
                                              .selectedPaymentMethod['name']
                                          : widget.paymentMethod['name'])
                                      .map((e) => listPoint(e))
                                      .toList(),
                                ),
                              ),
                            ]);
                      })));
        });
  }

  Widget listPoint(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            width: 4,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: Color(0xFF75C1D4),
                borderRadius: BorderRadius.circular(2)),
          ),
          SizedBox(width: 10),
          Flexible(
            child: CustomText(
              "$value",
              color: ColorsCustom.generalText,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
