import 'package:flutter/material.dart';
import './verify_otp_view.dart';

class VerifyOtp extends StatefulWidget {
  final String mode;
  final String phoneNumber;
  final Map signUpdata;

  VerifyOtp({this.phoneNumber, this.mode: 'login', this.signUpdata});

  @override
  VerifyOtpView createState() => new VerifyOtpView();
}
