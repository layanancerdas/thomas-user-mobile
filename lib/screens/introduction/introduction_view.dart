import 'package:flutter/material.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/custom_introduction.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:tomas/widgets/custom_text.dart';
import './introduction_view_model.dart';

class IntroductionView extends IntroductionViewModel {
  @override
  Widget build(BuildContext context) {
    // Replace this with your build function
    return CustomIntroductionScreen(
      pages: AppTranslations.of(context).currentLanguage == 'id'
          ? introductionId
          : introductionEn,
      onDone: () => onDone(),
      onSkip: () => onDone(),
      showSkipButton: true,
      showNextButton: true,
      skip: CustomText(
        "Skip",
        color: ColorsCustom.primary,
      ),
      next: const Icon(Icons.arrow_forward),
      done: SizedBox(),

      isProgressTap: false,
      isProgress: false,

      // dotsDecorator: DotsDecorator(
      //     size: const Size.square(10.0),
      //     activeSize: const Size(20.0, 10.0),
      //     activeColor: ColorsCustom.primary,
      //     color: Colors.black26,
      //     spacing: const EdgeInsets.symmetric(horizontal: 3.0),
      //     activeShape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(25.0))),
    );
  }
}
