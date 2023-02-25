import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/configs/static_text_en.dart';
import 'package:tomas/configs/static_text_id.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class ModalVoucherTerms extends StatefulWidget {
  final Map data;

  ModalVoucherTerms({this.data});

  @override
  _ModalVoucherTermsState createState() => _ModalVoucherTermsState();
}

class _ModalVoucherTermsState extends State<ModalVoucherTerms> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.white.withOpacity(0.20),
      height: screenSize.height,
      child: Stack(
        children: [
          Container(
            height: screenSize.height,
            width: screenSize.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                )),
            padding: EdgeInsets.only(top: 38),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  constraints: BoxConstraints(minHeight: 110),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                            blurRadius: 14,
                            color: ColorsCustom.black.withOpacity(0.12))
                      ]),
                  child: Stack(
                    children: [
                      Container(
                        constraints: BoxConstraints(minHeight: 110),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Stack(
                                  children: [
                                    Container(
                                        constraints:
                                            BoxConstraints(minHeight: 110),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        decoration: BoxDecoration(
                                            color: ColorsCustom.primaryGreen,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              bottomLeft: Radius.circular(16),
                                            )),
                                        child: Center(
                                          child: CustomText(
                                            "${widget.data['name']}",
                                            // "FREE\nRIDE",
                                            fontSize: 16,
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      right: -1.5,
                                      child: SvgPicture.asset(
                                        "assets/images/dashline.svg",
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ],
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        "Discount ${widget.data['discount_type'] == "AMOUNT" ? "Rp" + widget.data['discount_amount'].toString() : (widget.data['discount_percentage'] * 100).toString() + "%"} AJK",
                                        fontSize: 12,
                                        color: ColorsCustom.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      SizedBox(height: 8),
                                      CustomText(
                                        AppTranslations.of(context)
                                                    .currentLanguage ==
                                                'id'
                                            ? "Min spend Rp0"
                                            : "Min pembelian Rp0",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: ColorsCustom.black,
                                      ),
                                      SizedBox(height: 8),
                                      CustomText(
                                        AppTranslations.of(context)
                                                    .currentLanguage ==
                                                'id'
                                            ? "Valid Hingga ${Utils.formatterDateGeneral.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.data['last_valid'])))}"
                                            : "Valid till ${Utils.formatterDateGeneral.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.data['last_valid'])))}",
                                        fontSize: 12,
                                        color: ColorsCustom.generalText,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: -12,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                                color: Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: -12,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                  color: Color(0xFFF3F3F3),
                                  borderRadius: BorderRadius.circular(12)),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: CustomText(
                    AppTranslations.of(context).currentLanguage == 'id'
                        ? "Syarat dan ketentuan"
                        : "Terms and Conditions",
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: ColorsCustom.black,
                    // textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(bottom: 100, left: 16, right: 16),
                    shrinkWrap: true,
                    children:
                        AppTranslations.of(context).currentLanguage == 'id'
                            ? StaticTextId.termsConditionsCoupon
                                .map((e) => listPoint(e))
                                .toList()
                            : StaticTextEn.termsConditionsCoupon
                                .map((e) => listPoint(e))
                                .toList(),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 5,
              width: 32,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: ColorsCustom.generalText,
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.3),
                //     spreadRadius: 2,
                //     blurRadius: 8,
                //     offset: Offset(3, 4), // changes position of shadow
                //   ),
                // ],
              ),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  //   color: ColorsCustom.primary,
                  // textColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 1,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppTranslations.of(context).currentLanguage == 'id'
                      ? "Tutup"
                      : "Close",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Poppins'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
