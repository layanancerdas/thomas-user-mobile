import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/transaction_state.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class CardWallet extends StatefulWidget {
  final onWalletClick;
  final bool isZeroPrice;

  CardWallet({this.onWalletClick, this.isZeroPrice: false});
  @override
  _CardWalletState createState() => _CardWalletState();
}

class _CardWalletState extends State<CardWallet> {
  @override
  Widget build(BuildContext context) {
    return widget.isZeroPrice
        ? SizedBox()
        : Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 4),
                      spreadRadius: -3,
                      blurRadius: 12,
                      color: ColorsCustom.black.withOpacity(0.17))
                ]),
            child: TextButton(
                style: TextButton.styleFrom(
                  // highlightColor: ColorsCustom.softGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.all(16),
                ),
                onPressed:
                    widget.isZeroPrice ? null : () => widget.onWalletClick(),
                child: StoreConnector<AppState, TransactionState>(
                    converter: (store) => store.state.transactionState,
                    builder: (context, state) {
                      return Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(width: 6),
                                Container(
                                    height: 20,
                                    child: state.selectedPaymentMethod
                                            .containsKey('logo')
                                        ? Image.network(
                                            '${BASE_API + "/files/" + state.selectedPaymentMethod['logo']}',
                                          )
                                        : SizedBox()),
                                SizedBox(width: 16),
                                CustomText(
                                  "${state.selectedPaymentMethod['name'] ?? "Ovo"}",
                                  color: ColorsCustom.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     CustomText(
                                //       "Balance",
                                //       color: ColorsCustom.black,
                                //       fontWeight: FontWeight.w300,
                                //       fontSize: 10,
                                //     ),
                                //     CustomText(
                                //       "Rp365,800",
                                //       color: ColorsCustom.black,
                                //       fontWeight: FontWeight.w600,
                                //       fontSize: 12,
                                //     )
                                //   ],
                                // )
                              ],
                            ),
                          ),
                          CustomText(
                            "${AppTranslations.of(context).text("change")}",
                            color: ColorsCustom.tosca,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ],
                      );
                    })));
  }
}
