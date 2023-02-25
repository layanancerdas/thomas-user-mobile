import 'package:flutter/material.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/screens/verify_otp/verify_otp.dart';
import './sign.dart';
import 'package:tomas/localization/app_translations.dart';

abstract class SignViewModel extends State<Sign> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // String countryCode = "+62";
  String errorUsername = "";
  String errorPhoneNumber = "";
  String errorPassword = "";
  String errorLogin = "";

  bool isLoading = false;

  void toggleLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  void setError({String type, String value}) {
    setState(() {
      if (type == 'phoneNumber') {
        errorPhoneNumber = value;
      } else if (type == 'password') {
        errorPassword = value;
      } else if (type == 'username') {
        errorUsername = value;
      } else if (type == 'login') {
        errorLogin = value;
      }
      isLoading = false;
    });
  }

  void clearError(String type) {
    setState(() {
      if (type == 'phoneNumber') {
        errorPhoneNumber = "";
      } else if (type == 'username') {
        errorUsername = "";
      } else if (type == 'password') {
        errorUsername = "";
      }
    });
  }

  Future<void> onLogin() async {
    // Bypass
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String jwtToken =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYzBlYjkyNzAtZWE5Ni0xMWViLWI4ZTktY2YxMWNkNzc3ZTc2IiwiaWF0IjoxNjI3MDQ1NjIzLCJleHAiOjE2NTg1ODE2MjN9.2gFnwHDnM4V-Wrsx7spUyUC6pJ3_uhyOZYHuAdoRkkg';
    // String jwtToken =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYzQwN2JiNTAtZWJhZS0xMWViLWI0OTktNjk5YjY0MTA4Yzk1IiwiaWF0IjoxNjI3MTM1MTc1LCJleHAiOjE2NTg2NzExNzV9.2uUE68HdXBQNrXM6otgozTE5zxCLsBl2GLOUPWQPw8U';
    // await prefs.setString('jwtToken', jwtToken);

    // Navigator.pushNamedAndRemoveUntil(
    //     context, '/Home', (Route<dynamic> route) => false);

    if (widget.mode == 'ldap' && usernameController.text.length <= 0) {
      setError(
          type: "username",
          value: AppTranslations.of(context).currentLanguage == 'id'
              ? "Mohon Isi Username Anda"
              : "Please fill in your username");
    }
    if (phoneNumberController.text.length <= 0) {
      setError(
          type: "phoneNumber",
          value: AppTranslations.of(context).currentLanguage == 'id'
              ? "Mohon Isi Nomor Handphone Anda"
              : "Please fill in your phone number");
    }
    if (phoneNumberController.text.length > 0 &&
        !RegExp(r'^[0]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(
            phoneNumberController.text.replaceAll(new RegExp(r"\s+"), ""))) {
      setError(
          type: "phoneNumber",
          value: AppTranslations.of(context).currentLanguage == 'id'
              ? "Nomor Handphone Invalid"
              : "Invalid phone number");
    }
    if (widget.mode == 'ldap' && passwordController.text.length <= 0) {
      setError(type: "password", value: "Please fill in your password");
    }
    if (widget.mode == 'ldap' && usernameController.text.length <= 0) {
      setError(type: "username", value: "Please fill in your username");
    }
    if (errorPhoneNumber == "" && errorUsername == "" && errorPassword == "") {
      toggleLoading(true);
      try {
        dynamic res;
        if (widget.mode == 'ldap') {
          res = await Providers.signInWithLDAP(
              password: passwordController.text,
              username: usernameController.text,
              phoneNumber: phoneNumberController.text
                  .replaceAll(new RegExp(r"\s+"), ""));
        } else {
          res = await Providers.signIn(
              phoneNumber: phoneNumberController.text
                  .replaceAll(new RegExp(r"\s+"), ""));
        }
        print(res.data['data']);
        if (res.data['message'] == 'SUCCESS') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => VerifyOtp(
                        mode: 'login',
                        phoneNumber: phoneNumberController.text,
                      )));
        } else {
          if (res.data['message'].contains("phone_number")) {
            setError(type: "phoneNumber", value: "Invalid phone number");
          } else if (res.data['message'].contains("user")) {
            setError(
                type: "phoneNumber",
                value: "Your phone number is not registered");
          }
          // else {
          //   setError(
          //       type: "login",
          //       value: res.data['message'][0].toUpperCase() +
          //           res.data['message'].substring(1));
          // }
        }
      } catch (e) {
        print(e);
        setError(type: "login", value: e);
      } finally {
        toggleLoading(false);
      }
    }
  }
}
