import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/transaction_state.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class CardBalance extends StatefulWidget {
  final bool useBalance;
  final bool isZeroPrice;
  final toggle;

  CardBalance({this.useBalance, this.toggle, this.isZeroPrice});

  @override
  _CardBalanceState createState() => _CardBalanceState();
}

class _CardBalanceState extends State<CardBalance> {
  @override
  Widget build(BuildContext context) {
    return widget.isZeroPrice ? SizedBox() : StoreConnector<AppState, TransactionState>(
        converter: (store) => store.state.transactionState,
        builder: (context, state) {
          return state.balances > 0
              ? Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 35,
                              child:
                                  SvgPicture.asset("assets/images/money.svg"),
                            ),
                            SizedBox(width: 16),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  "${AppTranslations.of(context).text("balance")}: ",
                                  color: ColorsCustom.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                                CustomText(
                                  "Rp${Utils.currencyFormat.format(state.balances)}",
                                  color: ColorsCustom.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      CupertinoSwitch(
                        value: widget.useBalance,
                        activeColor: ColorsCustom.primary,
                        onChanged: widget.isZeroPrice
                            ? null
                            : (bool value) =>
                                state.balances > 0 ? widget.toggle() : {},
                      ),
                    ],
                  ))
              : SizedBox();
        });
  }
}
