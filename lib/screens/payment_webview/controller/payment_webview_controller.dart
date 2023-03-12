import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/screens/failed_payment/screen/failed_payment.dart';
import 'package:tomas/screens/home/home.dart';
import 'package:crypto/crypto.dart';
import 'package:tomas/screens/success_payment/screen/success_payment.dart';

class PaymentWebVIewController extends GetxController {
  List dataPayment = [].obs;
  RxBool isLoading = false.obs;
  String status = '';

  toggleLoading(bool value) {
    isLoading.value = value;
  }

  Future<void> updateStatusPay(merchantId, statusPayment) async {
    toggleLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");
    Dio dio = Dio();
    var url = BASE_API + "/ajk/user/subscription/pay";
    var params = {"id": merchantId, "status": statusPayment};
    final response = await dio.put(
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
    print(response.data);
    if (response.data['code'] == 'SUCCESS' && statusPayment == 'SUCCESS') {
      toggleLoading(false);
      Get.off(SuccessPayment(
        title: 'Success Payment',
        message: 'Your payment is successful',
      ));
    } else if (response.data['code'] == 'SUCCESS' &&
        statusPayment == 'FAILED') {
      toggleLoading(false);
      Get.off(FailedPayment());
    } else {
      toggleLoading(false);
    }
  }

  void getStatusTransaction(
    orderId,
  ) async {
    Dio dio = Dio();
    var signature = await md5
        .convert(utf8.encode(BASE_MERCHANT_CODE + orderId + DUITKU_API_KEY))
        .toString();
    var url = BASE_DUITKU + "/transactionStatus";

    var params = {
      "merchantcode": BASE_MERCHANT_CODE,
      "merchantOrderId": orderId,
      "signature": signature
    };
    // MyDialog.showLoadingDialog();
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
    if (response.data['statusCode'] != null) {
      status = response.data['statusCode'];
    }
    print(status);
  }
}
