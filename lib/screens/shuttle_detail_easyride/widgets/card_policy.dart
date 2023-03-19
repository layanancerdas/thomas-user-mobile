import 'package:flutter/material.dart';
import 'package:tomas/configs/static_text_en.dart';
import 'package:tomas/configs/static_text_id.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:tomas/widgets/custom_text.dart';

class CardPolicy extends StatefulWidget {
  @override
  _CardPolicyState createState() => _CardPolicyState();
}

class _CardPolicyState extends State<CardPolicy> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset.zero,
                  blurRadius: 4,
                  spreadRadius: 1,
                  color: Colors.black.withOpacity(0.15))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CustomText(
                "${AppTranslations.of(context).text("refund_policy")}",
                color: ColorsCustom.black,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: AppTranslations.of(context).currentLanguage == 'id'
                    ? StaticTextId.refundPolicy
                        .map((e) => listPoint(e))
                        .toList()
                    : StaticTextEn.refundPolicy
                        .map((e) => listPoint(e))
                        .toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              height: 1,
              color: ColorsCustom.border,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CustomText(
                "${AppTranslations.of(context).text("reschedule_policy")}",
                color: ColorsCustom.black,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: AppTranslations.of(context).currentLanguage == 'id'
                    ? StaticTextId.reschedulePolicy
                        .map((e) => listPoint(e))
                        .toList()
                    : StaticTextEn.reschedulePolicy
                        .map((e) => listPoint(e))
                        .toList(),
              ),
            ),
          ],
        ));
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
