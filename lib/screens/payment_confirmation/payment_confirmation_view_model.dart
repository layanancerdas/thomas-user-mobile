import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/home/home.dart';
import 'package:tomas/screens/payment/payment.dart';
import 'package:tomas/screens/payment_webview/screen/payment_webview.dart';
import 'package:tomas/widgets/custom_text.dart';
import './payment_confirmation.dart';
import 'package:crypto/crypto.dart';

abstract class PaymentConfirmationViewModel extends State<PaymentConfirmation> {
  Store<AppState> store;
  final GlobalKey<ScaffoldState> paymentConfirmationKey =
      GlobalKey<ScaffoldState>();
  PersistentBottomSheetController bottomSheetController;

  Map dataPayment = {};
  String order_id = '';
  String errorPaymentMethod = "";
  String linkPayment = "";
  String name = "";
  String email = "";
  String amountPay = "";
  String month = "";
  String nameSubs = "";
  String idSubs = "";
  int startDate = 0;
  int endDate = 0;
  bool isLoading = false;
  bool errorPayment = false;

  @override
  void initState() {
    super.initState();
    getOrderID();
    getUserDetail();
    getMonth();
    getName();
    getSubsId();
    setTotalPay();
    getStartEndDate();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   store = StoreProvider.of<AppState>(context);
    //   initData();
    // });
  }

  void toggleLoading(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  void getOrderID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    order_id = prefs.getString('ORDER_ID');
    print(order_id);
  }

  void setTotalPay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      amountPay = prefs.getString('ORDER_AMOUNT');
    });
  }

  void getMonth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      month = prefs.getString('ORDER_DURATION');
    });
  }

  void getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      nameSubs = prefs.getString('ORDER_NAME');
    });
  }

  void getStartEndDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      startDate = prefs.getInt('START_DATE');
      endDate = prefs.getInt('END_DATE');
    });
  }

  void getSubsId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      idSubs = prefs.getString('SUBS_ID');
    });
  }

  Future<void> getUserDetail() async {
    try {
      dynamic res = await Providers.getUserDetail();
      // print(res);
      print(res.data);
      if (res.data['code'].toString() == 'SUCCESS') {
        name = res.data['data']['name'];
        email = res.data['data']['email'];
      }
    } catch (e) {
      print("user detail");
      print(e);
    }
  }

  void errorDialog(errorText) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: CustomText(
            AppTranslations.of(context).currentLanguage == 'id'
                ? "Failed"
                : 'Gagal',
            color: ColorsCustom.black,
          ),
          content: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              CustomText(
                errorText,
                color: ColorsCustom.generalText,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(),
              onPressed: () {
                Navigator.pop(context);
              },
              child: CustomText(
                'Oke',
                color: ColorsCustom.blueSystem,
              ),
            ),
          ],
        );
      },
    );
  }

  // void toggleUseBalance() {
  //   store.dispatch(UseBalance());
  // }
  Future<void> postAjkSubscription(
      paymentMethod, urlPayment, paymentName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");
    Dio dio = Dio();
    var url = BASE_API + "/ajk/user/subscription";
    var params = {
      "subcriptions_id": idSubs,
      "merchandOrderId": order_id,
      "paymentAmount": amountPay.toString(),
      "paymentMethod": paymentMethod,
      "paymentMethodName": paymentName,
      "productDetails": nameSubs,
      "customerVaName": name,
      "email": email,
      "payment_url": urlPayment,
      "start_date": startDate,
      "end_date": endDate,
    };
    final response = await dio.post(
      url,
      data: jsonEncode(params),
      options: Options(
        headers: {'authorization': Providers.basicAuth, 'token': jwtToken},
        followRedirects: false,
        validateStatus: (status) {
          return status <= 500;
        },
      ),
    );
    print('ini url payment' + urlPayment);
    if (response.data['code'] == 'SUCCESS') {
      toggleLoading(false);
      Get.off(PaymentWebView(url: linkPayment, orderId: order_id));
    } else {
      toggleLoading(false);
      errorDialog(response.data['message']);
      print(response.data);
    }
  }

  Future<void> onPayClick(paymentMethod, paymentName) async {
    toggleLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var signature = md5
        .convert(utf8.encode(BASE_MERCHANT_CODE +
            order_id +
            amountPay.toString() +
            DUITKU_API_KEY))
        .toString();
    Dio dio = Dio();
    var url = BASE_DUITKU + "/v2/inquiry";
    var params = {
      "merchantCode": BASE_MERCHANT_CODE,
      "paymentAmount": amountPay.toString(),
      "paymentMethod": paymentMethod,
      "merchantOrderId": order_id,
      "productDetails": nameSubs,
      "customerVaName": name,
      "email": email,
      "callbackUrl": "https://google.com/callback",
      "returnUrl": "https://google.com/return",
      "signature": signature,
      "expiryPeriod": 60
    };
    final response = await dio.post(
      url,
      data: jsonEncode(params),
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status <= 500;
        },
      ),
    );
    if (response.data['statusCode'] == "00") {
      linkPayment = response.data['paymentUrl'];
      if (idSubs != '') {
        postAjkSubscription(paymentMethod, linkPayment, paymentName);
      } else {
        Get.off(PaymentWebView(url: linkPayment, orderId: order_id));
      }
    } else {
      print('gagal');
      print(response.data);
      toggleLoading(false);
    }
  }

  Future<void> onZeroPricePay(invoiceId) async {
    toggleLoading(true);
    try {
      dynamic res = await Providers.paymentBooking(
          balanceAmount: 0,
          invoiceId: invoiceId,
          paymentMethodId: null,
          voucherId: null);
      print(res.data);
      if (res.data['code'] == 'SUCCESS') {
        toggleLoading(false);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Payment(
                      mode: "finish",
                    )));
      } else {
        print(res.data['message']);
        showDialogError('error', "${res.data['message']}, please try again");
        // await onZeroPricePay();
      }
    } catch (e) {
      print(e);
    }

    toggleLoading(false);
  }

  void showDialogError(String mode, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: CustomText('Payment Failed', color: ColorsCustom.black),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomText(
              Utils.capitalizeFirstofEach(message),
              fontSize: 12,
              color: ColorsCustom.black,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(),
              onPressed: () async {
                if (mode == 'my_trips') {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Home(
                                index: 1,
                                tab: 1,
                                forceLoading: true,
                              )),
                      (Route<dynamic> route) => false);
                } else {
                  Navigator.pop(context);
                }
              },
              child: CustomText(
                'OK',
                color: ColorsCustom.blueSystem,
              ),
            ),
          ],
        );
      },
    );
  }
}
