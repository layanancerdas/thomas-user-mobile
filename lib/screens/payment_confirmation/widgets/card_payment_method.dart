import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:redux/redux.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/payment_method/screen/payment_method.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class CardPaymentMethod extends StatelessWidget {
  final String payment;
  final Function onTapMethod;
  CardPaymentMethod({this.payment, this.onTapMethod});

  Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Container(
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
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    onTapMethod();
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 35,
                                      child:
                                          Icon(Icons.account_balance_wallet)),
                                  SizedBox(width: 16),
                                  CustomText(
                                    payment == null
                                        ? "Select Payment Method"
                                        : payment,
                                    color: state.generalState.selectedVouchers
                                            .containsKey('name')
                                        ? ColorsCustom.black
                                        : ColorsCustom.disable,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  )
                                ],
                              ),
                            ),
                            CustomText(
                              state.generalState.selectedVouchers
                                      .containsKey('name')
                                  ? "${AppTranslations.of(context).text("remove")}"
                                  : "${AppTranslations.of(context).text("add")}",
                              color: ColorsCustom.tosca,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )));
        });
  }
}
