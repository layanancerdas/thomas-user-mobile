import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class VoucherPopUp extends StatefulWidget {
  @override
  _VoucherPopUpState createState() => _VoucherPopUpState();
}

class _VoucherPopUpState extends State<VoucherPopUp> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: 48,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                      blurRadius: 14,
                      color: ColorsCustom.black.withOpacity(0.12))
                ]),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                // highlightColor: ColorsCustom.black.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.pushNamed(context, '/Vouchers'),
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 60,
                    decoration: BoxDecoration(
                      color: ColorsCustom.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/images/coupon_white.svg",
                        width: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  StoreConnector<AppState, GeneralState>(
                      converter: (store) => store.state.generalState,
                      builder: (context, state) {
                        return Expanded(
                            child: CustomText(
                          "${AppTranslations.of(context).text("you_have")} ${state.vouchers.length} ${AppTranslations.of(context).text("voucher_active")}",
                          color: ColorsCustom.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ));
                      }),
                  CustomText(
                    "${AppTranslations.of(context).text("view")}",
                    color: ColorsCustom.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(width: 10)
                ],
              ),
            )),
        Positioned(
            top: 16,
            left: 8,
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(12)),
            )),
      ],
    );
  }
}
