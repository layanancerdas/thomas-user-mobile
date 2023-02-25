import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/helpers/push_notification_service.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import './verify_otp.dart';

abstract class VerifyOtpViewModel extends State<VerifyOtp> {
  Store<AppState> store;
  final PushNotificationService pushNotificationService =
      PushNotificationService();
  TextEditingController otpController = TextEditingController();

  String currentSelected = '';
  String errorOtp = "";

  bool resendActive = false;
  bool isLoading = false;

  Timer timer;
  int startTimer = 30;

  void toggleLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  void toggleTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(oneSec, (Timer timer) {
      if (mounted) {
        setState(
          () {
            if (startTimer < 1) {
              timer.cancel();
              resendActive = true;
            } else {
              startTimer = startTimer - 1;
            }
          },
        );
      }
    });
  }

  String leadingZero(int value) {
    return value.toString().padLeft(2, '0');
  }

  void setError(String value) {
    setState(() {
      errorOtp = value;
      isLoading = false;
    });
  }

  void clearError() {
    setState(() {
      errorOtp = "";
    });
  }

  Future<void> onSendOtp() async {
    if (resendActive) {
      try {
        clearError();
        setState(() {
          startTimer = 30;
        });
        toggleTimer();
        dynamic res;
        if (widget.mode == 'login') {
          res = await Providers.signIn(
              phoneNumber:
                  widget.phoneNumber.replaceAll(new RegExp(r"\s+"), ""));
        } else if (widget.mode == 'register') {
          // res = await Providers.signUp(
          //     divisionId: widget.signUpdata['divisionId'],
          //     email: widget.signUpdata['email'],
          //     mobileNo: widget.signUpdata['mobileNo'],
          //     name: widget.signUpdata['name']);

          res = await Providers.signIn(
              phoneNumber: widget.signUpdata['mobileNo']);
        }

        if (res.data['message'] == 'SUCCESS') {
          setState(() {
            resendActive = false;
          });
        } else {
          setState(() {
            resendActive = true;
            if (mounted && timer != null) {
              timer.cancel();
            }
          });
          setError(res.data['message']);
        }
      } catch (e) {
        print(e.toString());
        setError(e.toString());
      }
    }
  }

  Future<void> onVerifyOtp() async {
    clearError();
    toggleLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      dynamic res;

      if (widget.mode == 'login') {
        res = await Providers.confirmLogin(otp: otpController.text);
      } else if (widget.mode == 'register') {
        res = await Providers.confirmOtp(otp: otpController.text);
      }

      print(res);

      if (res.data['message'] == 'SUCCESS') {
        print(res.data['data']['token']);
        await prefs.setString('jwtToken', res.data['data']['token']);
        await getUserDetail();

        await pushNotificationService.getFirebaseToken();

        Navigator.pushNamedAndRemoveUntil(
            context, '/Home', (Route<dynamic> route) => false);
      } else if (res.data['code'] == "DATA_NOT_FOUND") {
        setError("Invalid code, please resend OTP again");
      }
    } catch (e) {
      print(e);
      setError(e.toString());
    } finally {
      toggleLoading(false);
    }
  }

  Future<void> getUserDetail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dynamic res = await Providers.getUserDetail();
      store.dispatch(SetUserDetail(userDetail: res.data['data']));

      if (res.data['data']['permitted_ajk']) {
        prefs.remove('ajkPermitTime');
      }
    } catch (e) {
      print("user detail");
      print(e);
    }
  }

  @override
  void initState() {
    toggleTimer();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
    });
  }

  @override
  void dispose() {
    if (mounted && timer != null) {
      timer.cancel();
    }
    super.dispose();
  }
}
