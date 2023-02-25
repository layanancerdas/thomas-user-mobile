import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/configs/static_text_en.dart';
import 'package:tomas/configs/static_text_id.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:tomas/screens/faq/widgets/list_Faq.dart';
import 'package:tomas/widgets/custom_text.dart';
import './faq_view_model.dart';

class FaqView extends FaqViewModel {
  @override
  Widget build(BuildContext context) {
    // Replace this with your build function
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          style: TextButton.styleFrom(),
          onPressed: () => Navigator.pop(context),
          child: SvgPicture.asset(
            'assets/images/back_icon.svg',
          ),
        ),
        // elevation: 3,
        title: CustomText(
          "FAQ",
          color: ColorsCustom.black,
        ),
      ),
      body: ListView.builder(
        itemCount: AppTranslations.of(context).currentLanguage == 'id'
            ? StaticTextId.faq.length
            : StaticTextEn.faq.length,
        itemBuilder: (ctx, i) {
          return AppTranslations.of(context).currentLanguage == 'id'
              ? ListFaq(
                  title: StaticTextId.faq[i]['title'],
                  text: StaticTextId.faq[i]['text'] ?? null,
                  content: StaticTextId.faq[i]['content'] ?? null,
                )
              : ListFaq(
                  title: StaticTextEn.faq[i]['title'],
                  text: StaticTextEn.faq[i]['text'] ?? null,
                  content: StaticTextEn.faq[i]['content'] ?? null,
                );
        },
      ),
    );
  }
}
