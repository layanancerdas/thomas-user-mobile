import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class NoResultSearchAjk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        SvgPicture.asset("assets/images/no_search_ajk.svg"),
        CustomText(
          "${AppTranslations.of(context).text("no_shuttle")}",
          fontWeight: FontWeight.w300,
          fontSize: 14,
          color: ColorsCustom.black,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
