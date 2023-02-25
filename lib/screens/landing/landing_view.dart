import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/screens/sign/sign.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/custom_text.dart';
import './landing_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class LandingView extends LandingViewModel {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            "assets/images/login_image.svg",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red,
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(56, 38, 43, 0),
                  Color.fromRGBO(56, 38, 43, 0.48)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenSize.width * 0.09),
                      SvgPicture.asset(
                        'assets/images/logo_tomaas.svg',
                        height: screenSize.width * 0.07,
                      ),
                      SizedBox(height: 15),
                      CustomText(
                        "Easiest way plan your trip",
                        color: ColorsCustom.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        text: "${AppTranslations.of(context).text("tmmin")}",
                        textColor: Colors.white,
                        bgColor: ColorsCustom.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Sign(mode: "ldap"))),
                      ),
                      CustomButton(
                        text: "${AppTranslations.of(context).text("login")}",
                        bgColor: Colors.white,
                        textColor: ColorsCustom.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Sign(mode: "basic"))),
                      ),
                      SizedBox(height: screenSize.width * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: CustomText(
                              "${AppTranslations.of(context).text("not_a_member_yet")}",
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/SignUp'),
                              child: CustomText(
                                "${AppTranslations.of(context).text("get_an_account")}",
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.width * 0.05),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
