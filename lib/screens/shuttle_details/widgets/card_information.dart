import 'package:flutter/material.dart';
import 'package:tomas/configs/static_text_en.dart';
import 'package:tomas/configs/static_text_id.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:tomas/widgets/custom_text.dart';

class CardInformation extends StatefulWidget {
  @override
  _CardInformationState createState() => _CardInformationState();
}

class _CardInformationState extends State<CardInformation> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomText(
            "${AppTranslations.of(context).text("how_to_use")}",
            color: ColorsCustom.black,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppTranslations.of(context).currentLanguage == 'id'
                  ? StaticTextId.howToUse.map((e) => listPoint(e)).toList()
                  : StaticTextEn.howToUse.map((e) => listPoint(e)).toList(),
            ),
          ),
          SizedBox(height: 16),
          CustomText(
            "${AppTranslations.of(context).text("terms")}",
            color: ColorsCustom.black,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppTranslations.of(context).currentLanguage == 'id'
                  ? StaticTextId.termsConditions
                      .map((e) => listPoint(e))
                      .toList()
                  : StaticTextEn.termsConditions
                      .map((e) => listPoint(e))
                      .toList(),
            ),
          )
        ]));
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
