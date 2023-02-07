import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/error_form_text.dart';
import 'package:tomas/widgets/form_text.dart';
import './sign_up_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class SignUpView extends SignUpViewModel {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
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
                          bottom: screenSize.width * 0.03),
                      child: CustomText(
                        "${AppTranslations.of(context).text("create_account")}",
                        color: ColorsCustom.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    errorNip != "" && nipController.text.length <= 0
                        ? ErrorForm(error: errorNip)
                        : SizedBox(height: 33),
                    FormText(
                      hint: "NIP",
                      controller: nipController,
                      errorMessage:
                          nipController.text.length > 0 ? errorNip : "",
                      capitalize: true,
                      onChange: clearError,
                      idError: "nip",
                    ),
                    errorFullname != "" && fullnameController.text.length <= 0
                        ? ErrorForm(error: errorFullname)
                        : SizedBox(height: 33),
                    FormText(
                      hint: "${AppTranslations.of(context).text("full_name")}",
                      controller: fullnameController,
                      errorMessage: fullnameController.text.length > 0
                          ? errorFullname
                          : "",
                      capitalize: true,
                      onChange: clearError,
                      idError: "fullname",
                    ),
                    errorEmail != "" && emailController.text.length <= 0
                        ? ErrorForm(error: errorEmail)
                        : SizedBox(height: 33),
                    FormText(
                      hint: "Email",
                      keyboard: TextInputType.emailAddress,
                      controller: emailController,
                      errorMessage:
                          emailController.text.length > 0 ? errorEmail : "",
                      onChange: clearError,
                      idError: "email",
                    ),
                    errorPhoneNumber != "" &&
                            phoneNumberController.text.length <= 0
                        ? ErrorForm(error: errorPhoneNumber)
                        : SizedBox(height: 33),
                    // Container(
                    //   width: screenSize.width,
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.end,
                    //     children: [
                    //       Container(
                    //         width: 50,
                    //         height: 45,
                    //         decoration: BoxDecoration(
                    //             border: Border(
                    //                 bottom: BorderSide(
                    //                     width: 1,
                    //                     color: Colors.grey.withOpacity(0.2)))),
                    //         child: CountryCodePicker(
                    //           onChanged: (value) {
                    //             setState(() {
                    //               countryCode = value.dialCode;
                    //             });
                    //           },
                    //           // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    //           initialSelection: 'ID',
                    //           favorite: ['+62', 'ID'],
                    //           showFlag: false,
                    //           // optional. Shows only country name and flag
                    //           showCountryOnly: false,
                    //           // optional. Shows only country name and flag when popup is closed.
                    //           showOnlyCountryWhenClosed: false,
                    //           // optional. aligns the flag and the Text left
                    //           alignLeft: false,
                    //           textStyle:
                    //               TextStyle(fontSize: 16, fontFamily: "Poppins"),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(bottom: 1),
                    // child:
                    FormText(
                      controller: phoneNumberController,
                      hint:
                          "${AppTranslations.of(context).text("phone_number")} (e.g. 08123456789)",
                      phone: true,
                      keyboard: TextInputType.phone,
                      errorMessage: phoneNumberController.text.length > 0
                          ? errorPhoneNumber
                          : "",
                      onChange: clearError,
                      idError: "phoneNumber",
                    ),
                    errorDivision != "" && selectedDivision == null
                        ? ErrorForm(error: errorDivision)
                        : SizedBox(height: 33),
                    Container(
                      width: screenSize.width,
                      margin: EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.2)))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          selectedDivision != null
                              ? CustomText(
                                  "${errorDivision != "" ? errorDivision : "Division"}",
                                  color: errorDivision != ""
                                      ? ColorsCustom.danger
                                      : Color(0xFFA1A4A8),
                                  fontSize: 12,
                                  height: 1.5,
                                )
                              : SizedBox(),
                          Row(
                            children: [
                              Expanded(
                                child: CupertinoButton(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: CustomText(
                                        "${selectedDivision == null ? errorDivision != "" ? errorDivision : '${AppTranslations.of(context).text("choose_division")}' : divisionList[selectedDivision]['division_name']}",
                                        color: selectedDivision == null
                                            ? Color(0xFFA1A4A8)
                                            : errorDivision != ""
                                                ? ColorsCustom.danger
                                                : ColorsCustom.black,
                                        fontSize: 16,
                                        fontWeight: selectedDivision == null
                                            ? FontWeight.w300
                                            : FontWeight.w400,
                                        height: 1.5,
                                      ),
                                    ),
                                    onPressed: () => onShowDivision()),
                              ),
                              GestureDetector(
                                onTap: () => onShowDivision(),
                                child: SvgPicture.asset(
                                    'assets/images/accordion.svg',
                                    width: 12),
                              ),
                              SizedBox(width: 10),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 33),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            "Shift",
                            color: Color(0xFFA1A4A8),
                            fontSize: 12,
                            height: 1.5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                      value: 'Shift',
                                      groupValue: selectedShift,
                                      onChanged: (val) {
                                        setState(() {
                                          selectedShift = val;
                                        });
                                      }),
                                  Text('Shift')
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                      value: 'Non Shift',
                                      groupValue: selectedShift,
                                      onChanged: (val) {
                                        setState(() {
                                          selectedShift = val;
                                        });
                                      }),
                                  Text('Non Shift')
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // FormText(
                    //   hint: "Password",
                    //   obscureText: true,
                    //   controller: passwordController,
                    //   onChange: clearError,
                    // ),
                    // errorConfirmPassword != ""
                    //     ? ErrorForm(error: errorConfirmPassword)
                    //     : SizedBox(height: 20),
                    // FormText(
                    //   hint: "Confirm Password",
                    //   obscureText: true,
                    //   controller: confirmPasswordController,
                    //   onChange: clearError,
                    // ),
                    SizedBox(height: 20),
                    // errorRegister != ""
                    //     ? ErrorForm(error: errorRegister)
                    //     : SizedBox(height: 20),
                  ],
                ),
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: CustomButton(
                  text: "${AppTranslations.of(context).text("register")}",
                  textColor: Colors.white,
                  bgColor: ColorsCustom.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  onPressed: () => onSignUp(),
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
