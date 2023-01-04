import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/localization/app_translations.dart';
import 'custom_text.dart';

class ModalLowBalance extends StatefulWidget {
  @override
  _ModalLowBalanceState createState() => _ModalLowBalanceState();
}

class _ModalLowBalanceState extends State<ModalLowBalance> {
  Future<void> onRetry() async {
    // re-get data balance
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.white.withOpacity(0.20),
      child: Stack(
        children: [
          Container(
            height: screenSize.height,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                )),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/low_balance.svg"),
                SizedBox(height: 30),
                CustomText(
                  "${AppTranslations.of(context).text("low_balance")}",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: ColorsCustom.black,
                  // textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                CustomText(
                  "${AppTranslations.of(context).text("balance_not_enough")}",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: ColorsCustom.black,
                  // textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                //   color: ColorsCustom.primary,
                // textColor: Colors.white,
                elevation: 1,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => onRetry(),
              child: Text(
                "Retry",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                "assets/images/close.svg",
                width: 16,
                height: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
