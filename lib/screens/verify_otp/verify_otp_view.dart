import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';
import './verify_otp_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class VerifyOtpView extends VerifyOtpViewModel {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFAFAFA),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFFAFAFA),
        systemNavigationBarIconBrightness: Brightness.dark));
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
                  height: screenSize.height,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20,
                              top: screenSize.width * 0.04,
                              bottom: screenSize.width * 0.06),
                          child: CustomText(
                            "${AppTranslations.of(context).text("verify_phone")}",
                            color: ColorsCustom.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: RichText(
                            text: TextSpan(
                                text:
                                    "${AppTranslations.of(context).text("have_sent_verification")}",
                                style: TextStyle(
                                    color: Color(0xFF282828),
                                    fontSize: 13,
                                    height: 2,
                                    fontFamily: 'Poppins'),
                                children: [
                                  TextSpan(
                                      text: widget.phoneNumber
                                          .replaceAll(new RegExp(r"\s+"), "-"),
                                      style: TextStyle(
                                          color: ColorsCustom.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)),
                                  TextSpan(
                                      text:
                                          "${AppTranslations.of(context).text("enter_verify")}")
                                ]),
                          ),
                        ),
                        SizedBox(height: 15),
                        Center(
                          child: Container(
                              width: screenSize.width / 1.5,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 30),
                              child: PinCodeTextField(
                                  appContext: context,
                                  backgroundColor: Colors.transparent,
                                  pinTheme: PinTheme(
                                    activeColor: ColorsCustom.primary,
                                    activeFillColor: ColorsCustom.primary,
                                    selectedColor:
                                        ColorsCustom.primary.withOpacity(0.7),
                                    inactiveColor:
                                        ColorsCustom.primary.withOpacity(0.4),
                                    shape: PinCodeFieldShape.underline,
                                    borderRadius: BorderRadius.circular(5),
                                    fieldHeight: 50,
                                    fieldWidth: 40,
                                  ),
                                  textStyle: TextStyle(
                                      color: Color(0xFF282828),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                  length: 4,
                                  cursorColor:
                                      ColorsCustom.primary.withOpacity(0.7),
                                  controller: otpController,
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  animationType: AnimationType.fade,
                                  animationDuration:
                                      Duration(milliseconds: 200),
                                  onChanged: (_) => clearError())),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: errorOtp != null && errorOtp != ""
                              ? Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 30),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  // decoration: BoxDecoration(
                                  //     color: Color(0xFF1e90ff).withOpacity(0.3),
                                  //     borderRadius: BorderRadius.circular(30)),
                                  child: CustomText(
                                    "$errorOtp",
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w400,
                                    color: ColorsCustom.danger,
                                    fontSize: 13,
                                  ))
                              : startTimer > 0
                                  ? CustomText(
                                      "${leadingZero(startTimer ~/ 60)}:${leadingZero(startTimer % 60)}",
                                      textAlign: TextAlign.center,
                                      color: ColorsCustom.black,
                                      fontSize: 12,
                                    )
                                  : SizedBox(),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Didn't receive the code? ",
                                style: TextStyle(
                                    color: Color(0xFF282828),
                                    fontSize: 12,
                                    fontFamily: 'Poppins')),
                            GestureDetector(
                                onTap: () => onSendOtp(),
                                child: Text("Resend Code",
                                    style: TextStyle(
                                        color: !resendActive
                                            ? Colors.grey
                                            : ColorsCustom.primary,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                        fontSize: 13)))
                          ],
                        ),
                      ]),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        //   color: ColorsCustom.primary,
                        // textColor: Colors.white,
                        elevation: 1,
                      ),
                      onPressed: () => isLoading ? {} : onVerifyOtp(),
                      child: Text(
                        "Verify",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'Poppins'),
                      ),
                    ),
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
            )));
  }
}
