import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/widgets/custom_text.dart';

class CardFinishWallet extends StatefulWidget {
  final bool isLoading;
  final Map dataPayment, paymentMethod, dataNotif;

  CardFinishWallet(
      {this.dataPayment, this.paymentMethod, this.isLoading, this.dataNotif});

  @override
  _CardFinishWalletState createState() => _CardFinishWalletState();
}

class _CardFinishWalletState extends State<CardFinishWallet> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          int price = widget.dataNotif != null
              ? state.userState.selectedMyTrip['invoice']['total_amount']
              : state.generalState.selectedVouchers.containsKey("voucher_id")
                  ? state.generalState.selectedVouchers['discount_type'] == 'AMOUNT'
                      ? state.ajkState.selectedPickUpPoint['price'] * 10 -
                          state.generalState.selectedVouchers['discount_amount']
                      : state.ajkState.selectedPickUpPoint['price'] * 10 -
                          (state.ajkState.selectedPickUpPoint['price'] *
                              10 *
                              (state.generalState
                                      .selectedVouchers['discount_percentage'] *
                                  100) ~/
                              100)
                  : state.ajkState.selectedPickUpPoint['price'] * 10;
          return price <= 0 || state.ajkState.selectedPickUpPoint['price'] <= 0
              ? SizedBox()
              : Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xFFE8E8E8)),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    ),
                                  ))
                                : widget.paymentMethod.containsKey('logo')
                                    ? Image.network(
                                        "$BASE_API/files/${widget.paymentMethod['logo'] ?? state.transactionState.selectedPaymentMethod['logo']}",
                                        // loadingBuilder:
                                        //     (context, child, loadingProgress) {
                                        //   if (loadingProgress == null) {
                                        //     return child;
                                        //   } else {
                                        //     return Center(
                                        //         child: SizedBox(
                                        //       width: 17,
                                        //       height: 17,
                                        //       child: CircularProgressIndicator(
                                        //         strokeWidth: 2.5,
                                        //         valueColor:
                                        //             new AlwaysStoppedAnimation<
                                        //                 Color>(Colors.white),
                                        //       ),
                                        //     ));
                                        //     // You can use LinearProgressIndicator or CircularProgressIndicator instead
                                        //   }
                                        // },
                                        // errorBuilder:
                                        //     (context, error, stackTrace) =>
                                        //         Center(
                                        //             child: SizedBox(
                                        //                 width: 17, height: 17)),
                                      )
                                    : Center(
                                        child: SizedBox(
                                        width: 17,
                                        height: 17,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )),
                          ),
                          SizedBox(width: 14),
                          CustomText(
                            "${(widget.paymentMethod['name'] ?? state.transactionState.selectedPaymentMethod['name']) ?? "-"}",
                            color: ColorsCustom.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ],
                      ),
                      CustomText(
                        "Rp${Utils.currencyFormat.format(price)}",
                        // "Rp994,000",
                        color: ColorsCustom.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )
                    ],
                  ),
                );
        });
  }
}
