import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/error_form_text.dart';
import 'package:tomas/widgets/form_text.dart';
import './profile_edit_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class ProfileEditView extends ProfileEditViewModel {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => onWillPop(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Scaffold(
            appBar: AppBar(
              // backgroundColor: isLoading ? ColorsCustom.primary : Colors.white,
              leading: TextButton(
                style: TextButton.styleFrom(),
                onPressed: () => onWillPop(),
                child: SvgPicture.asset(
                  'assets/images/back_icon.svg',
                ),
              ),
            ),
            body: Stack(children: [
              Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5,
                              top: screenSize.width * 0.04,
                              bottom: screenSize.width * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "${AppTranslations.of(context).text("edit_profile")}",
                                color: ColorsCustom.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                              file == null
                                  ? GestureDetector(
                                      onTap: () => selectImage(),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: ColorsCustom.softGrey,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Stack(
                                          children: [
                                            fileName == "" || fileName == null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: SvgPicture.asset(
                                                      'assets/images/placeholder_user.svg',
                                                      fit: BoxFit.cover,
                                                      height: 60,
                                                      width: 60,
                                                    ))
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: Image.network(
                                                      "$BASE_API/files/$fileName",
                                                      fit: BoxFit.cover,
                                                      height: 60,
                                                      width: 60,
                                                    ),
                                                  ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 2,
                                                        color: Colors.white),
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: SvgPicture.asset(
                                                  'assets/images/plus.svg',
                                                  width: 8,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () => selectImage(),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        alignment: Alignment.bottomRight,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            image: DecorationImage(
                                                image: FileImage(file),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.white),
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: SvgPicture.asset(
                                            'assets/images/plus.svg',
                                            width: 8,
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                        errorFullname != "" &&
                                fullnameController.text.length <= 0
                            ? ErrorForm(error: errorFullname)
                            : SizedBox(),
                        FormText(
                          hint:
                              "${AppTranslations.of(context).text("full_name")}",
                          controller: fullnameController,
                          capitalize: true,
                          onChange: clearError,
                          errorMessage: fullnameController.text.length > 0
                              ? errorFullname
                              : "",
                          idError: "fullname",
                          withClear: true,
                          onClear: clearFullName,
                        ),
                        errorEmail != "" && emailController.text.length <= 0
                            ? ErrorForm(error: errorEmail)
                            : SizedBox(height: 33),
                        verifiedWidget(
                            context,
                            FormText(
                              hint: "Email",
                              controller: emailController,
                              onChange: clearError,
                              readOnly: true,
                              errorMessage: emailController.text.length > 0
                                  ? errorEmail
                                  : "",
                              idError: "email",
                            ),
                            true,
                            'email'),
                        errorPhoneNumber != "" &&
                                phoneNumberController.text.length <= 0
                            ? ErrorForm(error: errorPhoneNumber)
                            : SizedBox(height: 33),
                        verifiedWidget(
                            context,
                            FormText(
                              hint:
                                  "${AppTranslations.of(context).text("phone_number")}  (e.g. 08123456789)",
                              controller: phoneNumberController,
                              phone: true,
                              keyboard: TextInputType.phone,
                              readOnly: true,
                              onChange: clearError,
                              errorMessage:
                                  phoneNumberController.text.length > 0
                                      ? errorPhoneNumber
                                      : "",
                              idError: "phoneNumber",
                            ),
                            true,
                            'phoneNumber'),
                        SizedBox(height: 25),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: screenSize.width,
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
                                    )
                                  : SizedBox(),
                              Row(
                                children: [
                                  Expanded(
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: CustomText(
                                          "${selectedDivision == null ? errorDivision != "" ? errorDivision : "${AppTranslations.of(context).text("choose_division")}" : divisionList[selectedDivision]['division_name']}",
                                          color: selectedDivision == null
                                              ? errorDivision != ""
                                                  ? ColorsCustom.danger
                                                  : Color(0xFFA1A4A8)
                                              : ColorsCustom.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          // height: 1.5,
                                        ),
                                      ),
                                      onPressed: () {},
                                      // onShowDivision()
                                    ),
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
                      ]),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: CustomButton(
                    text: "${AppTranslations.of(context).text("save")} ",
                    textColor: Colors.white,
                    bgColor: ColorsCustom.primary,
                    fontSize: 16,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    onPressed: () => onSubmit()),
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
            ]),
          ),
        ));
  }

  Widget verifiedWidget(
      BuildContext context, Widget formText, bool status, String mode) {
    return Stack(
      children: [
        formText,
        Positioned(
          top: 0,
          right: 0,
          child: status
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                      color: ColorsCustom.primaryGreenVeryLow,
                      borderRadius: BorderRadius.circular(16)),
                  child: CustomText(
                    "Verified",
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: ColorsCustom.primaryGreenHigh,
                  ),
                )
              : SizedBox(
                  height: 20,
                  width: 62,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      // borderSide: BorderSide(color: ColorsCustom.primary),
                    ),
                    onPressed: () => onVerify(mode),
                    child: CustomText(
                      "Verify",
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: ColorsCustom.primaryHigh,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
