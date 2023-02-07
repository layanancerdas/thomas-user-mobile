import 'package:flutter/material.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/custom_cupertino_picker.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/screens/verify_otp/verify_otp.dart';
import 'package:tomas/widgets/custom_text.dart';
import './sign_up.dart';
import 'package:tomas/localization/app_translations.dart';

abstract class SignUpViewModel extends State<SignUp> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nipController = TextEditingController();

  String selectedShift = 'Non Shift';
  int selectedDivision;

  // String countryCode = "+62";
  String errorFullname = "";
  String errorPhoneNumber = "";
  String errorEmail = "";
  String errorRegister = "";
  String errorDivision = "";
  String errorNip = "";

  bool isLoading = false;

  List divisionList = List();

  void toggleLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  void toggleDivision(int value) {
    setState(() {
      selectedDivision = value;
    });
  }

  void setError({String type, String value}) {
    setState(() {
      if (type == 'phoneNumber') {
        errorPhoneNumber = value;
      } else if (type == 'nip') {
        errorNip = value;
      } else if (type == 'email') {
        errorEmail = value;
      } else if (type == 'division') {
        errorDivision = value;
      } else if (type == 'fullname') {
        errorFullname = value;
      } else if (type == 'register') {
        errorRegister = value;
      }
      isLoading = false;
    });
  }

  void clearError(String type) {
    setState(() {
      if (type == 'phoneNumber') {
        errorPhoneNumber = "";
      } else if (type == 'nip') {
        errorNip = "";
      } else if (type == 'email') {
        errorEmail = "";
      } else if (type == 'division') {
        errorDivision = "";
      } else if (type == 'fullname') {
        errorFullname = "";
      } else if (type == 'register') {
        errorRegister = "";
      }
    });
  }

  Future<void> initDivision() async {
    try {
      dynamic res = await Providers.getDivision();

      setState(() {
        divisionList = res.data['data'];
      });
    } catch (e) {
      print(e);
    }
  }

  void onShowDivision() {
    FocusScope.of(context).requestFocus(new FocusNode());
    clearError("division");
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.white.withOpacity(0.2),
            child: Container(
              height: 260.0,
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: CustomCupertinoPicker(
                        itemExtent: 32.0,
                        backgroundColor: Colors.white,
                        // useMagnifier: true,
                        onSelectedItemChanged: (value) => toggleDivision(value),
                        children: new List<Widget>.generate(divisionList.length,
                            (index) {
                          return new Center(
                            child:
                                new Text(divisionList[index]['division_name']),
                          );
                        })),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: 1, color: ColorsCustom.softGrey))),
                    child: Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                          height: 40,
                          child: TextButton(
                            style: TextButton.styleFrom(),
                            //materialTapTargetSize:
                            //materialTapTargetSize.shrinkWrap,
                            // color: Colors.white,
                            onPressed: () => Navigator.pop(context),
                            child: CustomText(
                              "Cancel",
                              color: ColorsCustom.primary,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        )),
                        Container(
                            width: 1, height: 40, color: ColorsCustom.softGrey),
                        Expanded(
                            child: SizedBox(
                          height: 40,
                          child: TextButton(
                            style: TextButton.styleFrom(),
                            //materialTapTargetSize:
                            //materialTapTargetSize.shrinkWrap,
                            // color: Colors.white,
                            onPressed: () {
                              selectedDivision == null
                                  ? toggleDivision(0)
                                  : print(selectedDivision);
                              Navigator.pop(context);
                            },
                            child: CustomText(
                              "Done",
                              color: ColorsCustom.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          );
        });
  }

  Future<void> onSignUp() async {
    if (nipController.text.length <= 0) {
      setError(
          type: "nip",
          value: AppTranslations.of(context).currentLanguage == 'id'
              ? "Mohon Isi NIP Anda"
              : "Please fill in your NIP");
    }
    if (fullnameController.text.length <= 0) {
      setError(
          type: "fullname",
          value: AppTranslations.of(context).currentLanguage == 'id'
              ? "Mohon Isi Nama Lengkap Anda"
              : "Please fill in your full name");
    }
    if (emailController.text.length <= 0) {
      setError(
          type: "email",
          value: AppTranslations.of(context).currentLanguage == 'id'
              ? "Mohon isi Email Anda"
              : "Please fill in your email");
    }
    if (phoneNumberController.text.length <= 0) {
      setError(
          type: "phoneNumber",
          value: AppTranslations.of(context).currentLanguage == 'id'
              ? "Mohon isi Nomor Handphone Anda"
              : "Please fill in your phone number");
    }
    if (selectedDivision == null) {
      setError(
          type: "division",
          value: AppTranslations.of(context).currentLanguage == 'id'
              ? "Mohon Pilih Divisi Anda"
              : "Please choose your division");
    }
    if (emailController.text.length > 0 &&
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailController.text)) {
      setError(
          type: "email",
          value: AppTranslations.of(context).currentLanguage == 'id'
              ? "Email Invalis"
              : "Invalid email");
    }
    if (phoneNumberController.text.length > 0 &&
            !RegExp(r'^[0]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(
                phoneNumberController.text
                    .replaceAll(new RegExp(r"\s+"), "")) ||
        phoneNumberController.text.length < 6) {
      setError(
          type: "phoneNumber",
          value: AppTranslations.of(context).currentLanguage == 'id'
              ? "Nomor Handphone Invalid"
              : "Invalid phone number");
    }

    if (errorPhoneNumber == "" &&
        errorFullname == "" &&
        errorDivision == "" &&
        errorNip == "" &&
        errorEmail == "" &&
        errorDivision == "") {
      toggleLoading(true);
      try {
        dynamic res = await Providers.signUp(
            email: emailController.text,
            divisionId:
                divisionList[selectedDivision]['division_id'].toString(),
            mobileNo:
                phoneNumberController.text.replaceAll(new RegExp(r"\s+"), ""),
            name: fullnameController.text,
            nip: nipController.text);
        print(res);

        if (res.data['message'] == 'SUCCESS') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => VerifyOtp(
                        mode: 'register',
                        phoneNumber: phoneNumberController.text,
                        signUpdata: {
                          'email': emailController.text,
                          'divisionId': divisionList[selectedDivision]
                                  ['division_id']
                              .toString(),
                          'mobileNo': phoneNumberController.text
                              .replaceAll(new RegExp(r"\s+"), ""),
                          'name': fullnameController.text
                        },
                      )));
        } else {
          if (res.data['message'].contains("name")) {
            setError(type: "name", value: Utils.inCaps(res.data['message']));
          } else if (res.data['message'].contains("phone_number")) {
            setError(
                type: "phoneNumber", value: Utils.inCaps(res.data['message']));
          } else if (res.data['message'].contains("email")) {
            setError(type: "email", value: Utils.inCaps(res.data['message']));
          }
          // else {
          //   setError(
          //       type: "register",
          //       value: res.data['message'][0].toUpperCase() +
          //           res.data['message'].substring(1));
          // }
        }
      } catch (e) {
        print(e);
        // setError(type: "register", value: e.toString());
      } finally {
        toggleLoading(false);
      }
    }
  }

  // void showSuccessDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (_) => CustomDialog(
  //             image: "success_icon.svg",
  //             title: "Phone Number Verification Sent",
  //             desc:
  //                 "We sent a verification phone number to ${phoneNumberController.text}. Please check and verify your phone number.",
  //             onClick: () => Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (_) => VerifyOtp(
  //                           mode: 'register',
  //                           phoneNumber: phoneNumberController.text,
  //                           signUpdata: {
  //                             'email': emailController.text,
  //                             'divisionId': divisionList[selectedDivision]
  //                                     ['division_id']
  //                                 .toString(),
  //                             'mobileNo': phoneNumberController.text
  //                                 .replaceAll(new RegExp(r"\s+"), ""),
  //                             'name': fullnameController.text
  //                           },
  //                         ))),
  //           ));
  // }

  @override
  void initState() {
    initDivision();
    super.initState();
  }
}
