import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redux/redux.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class CardCoupon extends StatefulWidget {
  final String mode;
  final bool isZeroPrice;

  CardCoupon({this.mode, this.isZeroPrice});

  @override
  _CardCouponState createState() => _CardCouponState();
}

class _CardCouponState extends State<CardCoupon> {
  Store<AppState> store;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
    });
  }

  void onClick() {
    if (store.state.generalState.selectedVouchers.containsKey('name')) {
      store.dispatch(SetSelectedVoucher(selectedVoucher: {}));
    } else {
      Navigator.pushNamed(context, "/Vouchers");
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isZeroPrice
        ? SizedBox()
        : StoreConnector<AppState, AppState>(
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
                      onPressed: widget.isZeroPrice ? null : () => onClick(),
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
                                        child: SvgPicture.asset(
                                            "assets/images/coupon.svg"),
                                      ),
                                      SizedBox(width: 16),
                                      CustomText(
                                        "${state.generalState.selectedVouchers.containsKey('name') ? Utils.capitalizeFirstofEach(state.generalState.selectedVouchers['name']) : "Use Tomas Voucher"}",
                                        color: state
                                                .generalState.selectedVouchers
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
                          Positioned(
                              top: 16,
                              left: -8,
                              child: Container(
                                height: 16,
                                width: 16,
                                decoration: BoxDecoration(
                                    color: Color(0xFFF4F4F4),
                                    borderRadius: BorderRadius.circular(12)),
                              )),
                          Positioned(
                              top: 16,
                              right: -8,
                              child: Container(
                                height: 16,
                                width: 16,
                                decoration: BoxDecoration(
                                    color: Color(0xFFF4F4F4),
                                    borderRadius: BorderRadius.circular(12)),
                              ))
                        ],
                      )));
            });
  }
}
