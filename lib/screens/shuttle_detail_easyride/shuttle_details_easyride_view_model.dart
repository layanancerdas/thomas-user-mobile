import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/home/home.dart';
import 'package:tomas/screens/payment_confirmation/payment_confirmation.dart';
import 'package:tomas/screens/payment_webview/screen/payment_webview.dart';
import 'package:tomas/screens/success_payment/screen/success_payment.dart';
import 'package:tomas/widgets/custom_dialog.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:uuid/uuid.dart';
import 'shuttle_details_easyride.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:crypto/crypto.dart';

abstract class ShuttleDetailsViewEasyRideModel
    extends State<ShuttleDetailsEasyRide> {
  Store<AppState> store;

  Map dataPayment = {};
  bool isLoading = false;
  String name = '';
  String email = '';
  String linkPayment = '';
  String order_id = '';
  void toggleLoading(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  void getPaymentMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      dataPayment = jsonDecode(prefs.getString('PAYMENT_METHOD'));
    });
  }

  void getOrderID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    order_id = prefs.getString('ORDER_ID');
    print(order_id);
  }

  Future<void> onBooking() async {
    if (!store.state.userState.userDetail['permitted_ajk']) {
      permitCheckAndRequest();
    } else {
      // toggleLoading(true);
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => PaymentConfirmation()));
    }
  }

  void showDialogError(String mode, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: CustomText(
              AppTranslations.of(context).currentLanguage == 'id'
                  ? "Pemesanan Gagal"
                  : 'Booking Failed',
              color: ColorsCustom.black),
          content: CustomText(
            Utils.capitalizeFirstofEach(message),
            color: ColorsCustom.generalText,
            height: 2,
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

  Future<void> getBookingByGroupId() async {
    try {
      dynamic res = await Providers.getBookingByBookingId(
          bookingId: store.state.userState.selectedMyTrip['booking_id']);
      // print(res.data);
      store.dispatch(SetSelectedMyTrip(
          selectedMyTrip: res.data['data'],
          getSelectedTrip: [res.data['data']]));
    } catch (e) {
      print("Bokking");
      print(e.toString());
    }
  }

  Future<void> onRequestPermit() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dynamic res = await Providers.permitRequest();
      if (res.data['code'] == 'SUCCESS') {
        prefs.setInt('ajkPermitTime', DateTime.now().millisecondsSinceEpoch);
        showSuccessDialog();
      }
    } catch (e) {
      print(e);
    }
  }

  void showSuccessDialog() {
    showDialog(
        context: context,
        builder: (_) => CustomDialog(
              image: "success_icon.svg",
              title: AppTranslations.of(context).currentLanguage == 'id'
                  ? "Permintaan Telah Dikirim"
                  : "Your Request Has Been Sent",
              desc: AppTranslations.of(context).currentLanguage == 'id'
                  ? "Mohon tunggu 48 jam (maks) untuk persetujuan admin. Kami akan menghubungi Anda melalui email."
                  : "Please wait 48 hours (max) for admin approval. We will contact you by email.",
              onClick: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/Home', (route) => false),
            ));
  }

  Future<void> permitCheckAndRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("ajkPermitTime") == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: CustomText('Booking Failed', color: ColorsCustom.black),
            content: CustomText(
              AppTranslations.of(context).currentLanguage == 'id'
                  ? 'Maaf, Anda tidak terdaftar sebagai pengguna AJK yang memenuhi syarat. Mohon minta persetujuan dari admin untuk menggunakan AJK.'
                  : 'Sorry, you are not registered as an eligible AJK user. Please request approval from admin to use AJK.',
              color: ColorsCustom.generalText,
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(),
                onPressed: () => onRequestPermit(),
                child: CustomText(
                  AppTranslations.of(context).currentLanguage == 'id'
                      ? "Kirim Permintaan"
                      : 'Send Request',
                  fontWeight: FontWeight.w600,
                  color: ColorsCustom.black,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(),
                onPressed: () => Navigator.pop(context),
                child: CustomText(
                  AppTranslations.of(context).currentLanguage == 'id'
                      ? "Batalkan"
                      : 'Cancel',
                  color: ColorsCustom.black,
                ),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: CustomText(
                AppTranslations.of(context).currentLanguage == 'id'
                    ? "Pesanan Gagal"
                    : 'Booking Failed',
                color: ColorsCustom.black),
            content: CustomText(
              AppTranslations.of(context).currentLanguage == 'id'
                  ? 'Sudah minta izin AJK, mohon tunggu 1x24 jam. Terima kasih.'
                  : 'You have requested an AJK permit, please wait 1x24 hours. Thank you.',
              color: ColorsCustom.generalText,
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(),
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => Home(index: 0)),
                    (Route<dynamic> route) => false),
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

  Future<void> getUserDetail() async {
    try {
      dynamic res = await Providers.getUserDetail();
      store.dispatch(SetUserDetail(userDetail: res.data['data']));
      if (res.data['code'].toString() == 'SUCCESS') {
        name = res.data['data']['name'];
        email = res.data['data']['email'];
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getVouchers() async {
    try {
      dynamic res = await Providers.getVouchers(
          limit: store.state.generalState.limitVoucher,
          offset: store.state.generalState.vouchers.length);
      store.dispatch(SetVouchers(vouchers: res.data['data']));
    } catch (e) {
      print("vouchers");
      print(e);
    }
  }

  void resetSelectedMyTrip() {
    store.dispatch(SetSelectedMyTrip(selectedMyTrip: {}, getSelectedTrip: []));
  }

  Future<void> onPayClick() async {
    toggleLoading(true);
    var signature = md5
        .convert(utf8.encode(BASE_MERCHANT_CODE +
            order_id +
            store.state.ajkState.selectedPickUpPoint['price'].toString() +
            DUITKU_API_KEY))
        .toString();
    Dio dio = Dio();
    var url = BASE_DUITKU + "/v2/inquiry";
    var params = {
      "merchantCode": BASE_MERCHANT_CODE,
      "paymentAmount":
          store.state.ajkState.selectedPickUpPoint['price'].toString(),
      "paymentMethod": dataPayment['paymentMethod'],
      "merchantOrderId": order_id,
      "productDetails": store.state.ajkState.selectedTrip['trip_group_name'],
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
      Get.off(PaymentWebView(
        url: linkPayment,
        orderId: order_id,
        page: 'easyride',
      ));
    } else {
      print('gagal');
      print(response.data);
      toggleLoading(false);
    }
  }

  @override
  void initState() {
    super.initState();
    getPaymentMethod();
    getOrderID();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);

      getUserDetail();
      resetSelectedMyTrip();
    });
  }
}
