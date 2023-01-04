import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/screens/contact_us/widgets/card_contact.dart';
import 'package:tomas/widgets/custom_text.dart';
import './contact_us_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class ContactUsView extends ContactUsViewModel {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // backgroundColor: isLoading ? ColorsCustom.primary : Colors.white,
          leading: TextButton(
            style: TextButton.styleFrom(),
            onPressed: () => Navigator.pop(context),
            child: SvgPicture.asset(
              'assets/images/back_icon.svg',
            ),
          ),
        ),
        body: Stack(children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 5,
                            top: screenSize.width * 0.04,
                            bottom: screenSize.width * 0.06),
                        child: CustomText(
                          "${AppTranslations.of(context).text("contact_us")}",
                          color: ColorsCustom.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CardContact(
                        title: "Email",
                        icon: "email-red",
                        value: "contactcenter@tomaas.id",
                        url: "email",
                      ),
                      CardContact(
                        title: "Whatsapp only",
                        icon: "whatsapp-red",
                        value: "+62 82332878777",
                        url: "https://wa.me/6282332878777",
                      ),
                    ]),
              )),
        ]));
  }
}
