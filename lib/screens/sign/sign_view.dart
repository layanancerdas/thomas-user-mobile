import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/error_form_text.dart';
import 'package:tomas/widgets/form_text.dart';
import './sign_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class SignView extends SignViewModel {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
            // backgroundColor: isLoading ? ColorsCustom.primary : Colors.white,
            leading: TextButton(
              style: TextButton.styleFrom(),
              onPressed: () => Navigator.pop(context),
              child: SvgPicture.asset(
                'assets/images/back_icon.svg',
              ),
            ),

            centerTitle: true,
            title: SvgPicture.asset(
              'assets/images/logo_tomaas.svg',
              height: 25,
            ),
          ),
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 5,
                          top: screenSize.width * 0.04,
                          bottom: screenSize.width * 0.04),
                      child: CustomText(
                        "Let's Roll",
                        color: ColorsCustom.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    widget.mode != 'ldap'
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, bottom: 0),
                            child: CustomText(
                              "${AppTranslations.of(context).text("enter_phone")}",
                              color: ColorsCustom.black,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          )
                        : SizedBox(),
                    errorUsername != "" && usernameController.text.length <= 0
                        ? ErrorForm(error: errorUsername)
                        : SizedBox(),
                    widget.mode == 'ldap'
                        ? FormText(
                            hint: "Username",
                            controller: usernameController,
                            onChange: clearError,
                            errorMessage: usernameController.text.length > 0
                                ? errorUsername
                                : "",
                            idError: "username")
                        : SizedBox(),
                    errorPhoneNumber != "" &&
                            phoneNumberController.text.length <= 0
                        ? ErrorForm(error: errorPhoneNumber)
                        : SizedBox(height: 33),
                    // widget.mode == 'ldap'
                    //     ? FormText(
                    //         hint: "Phone Number",
                    //         controller: phoneNumberController,
                    //         keyboard: TextInputType.phone,
                    //         onChange: clearError,
                    //       )
                    //     : SizedBox(),
                    // Container(
                    //   width: screenSize.width,
                    //   child:
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     Container(
                    //       width: 50,
                    //       height: 45,
                    //       decoration: BoxDecoration(
                    //           border: Border(
                    //               bottom: BorderSide(
                    //                   width: 1,
                    //                   color: Colors.grey.withOpacity(0.2)))),
                    //       child: CountryCodePicker(
                    //         onChanged: (value) {
                    //           setState(() {
                    //             countryCode = value.dialCode;
                    //           });
                    //         },
                    //         // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    //         initialSelection: 'ID',
                    //         favorite: ['+62', 'ID'],
                    //         showFlag: false,
                    //         // optional. Shows only country name and flag
                    //         showCountryOnly: false,
                    //         // optional. Shows only country name and flag when popup is closed.
                    //         showOnlyCountryWhenClosed: false,
                    //         // optional. aligns the flag and the Text left
                    //         alignLeft: false,
                    //         textStyle:
                    //             TextStyle(fontSize: 16, fontFamily: "Poppins"),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(bottom: .5),
                    //         child:
                    FormText(
                      controller: phoneNumberController,
                      hint:
                          "${AppTranslations.of(context).text("phone_number")} (e.g. 08123456789)",
                      phone: true,
                      keyboard: TextInputType.phone,
                      onChange: clearError,
                      errorMessage: phoneNumberController.text.length > 0
                          ? errorPhoneNumber
                          : "",
                      idError: "phoneNumber",
                    ),
                    errorPhoneNumber != "" &&
                            phoneNumberController.text.length <= 0
                        ? ErrorForm(error: errorPhoneNumber)
                        : SizedBox(height: 33),
                    widget.mode == 'ldap'
                        ? FormText(
                            controller: passwordController,
                            hint: "Password",
                            keyboard: TextInputType.text,
                            obscureText: true,
                            onChange: clearError,
                            errorMessage: passwordController.text.length > 0
                                ? errorPassword
                                : "",
                            idError: "password",
                          )
                        : SizedBox(),
                    // ),
                    //     )
                    //   ],
                    // ),
                    // ),
                    // errorPassword != ""
                    //     ? ErrorForm(error: errorPassword)
                    //     : SizedBox(height: 20),
                    // FormText(
                    //   hint: "Password",
                    //   obscureText: true,
                    //   controller: passwordController,
                    //   onChange: clearError,
                    // ),
                    // SizedBox(height: 20),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () async {
                    //         if (widget.mode == 'ldap') {
                    //           const _url =
                    //               'https://hrportal.dev.toyota.co.id/Login';
                    //           await canLaunch(_url)
                    //               ? await launch(_url)
                    //               : throw 'Could not launch $_url';
                    //         } else {
                    //           Navigator.pushNamed(context, '/ForgotPassword');
                    //         }
                    //       },
                    //       child: CustomText(
                    //         "Forgot Password?",
                    //         color: ColorsCustom.primary,
                    //         fontSize: 12,
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // errorLogin != ""
                    //     ? ErrorForm(error: errorLogin)
                    //     : SizedBox(height: 20),
                  ],
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom == 0 ? 30 : 10,
                left: 0,
                right: 0,
                child: CustomButton(
                  text: "${AppTranslations.of(context).text("next")}",
                  textColor: Colors.white,
                  bgColor: ColorsCustom.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  onPressed: () =>
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, '/Home', (Route<dynamic> route) => false)
                      onLogin(),
                ),
              ),
              isLoading
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white70,
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Loading(
                          color: ColorsCustom.primary,
                          indicator: BallSpinFadeLoaderIndicator(),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ));
  }
}
