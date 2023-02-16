import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/providers/providers.dart';

class PaymentMethodController extends GetxController {
  List dataPayment = [].obs;
  RxBool isLoading = false.obs;

  toggleLoading(bool value) {
    isLoading.value = value;
  }

  void getPaymentMethods(amount, datenow, signature) async {
    toggleLoading(true);
    Dio dio = Dio();
    var url = BASE_DUITKU + "/paymentmethod/getpaymentmethod";
    var params = {
      "merchantcode": BASE_MERCHANT_CODE,
      "amount": amount.toString(),
      "datetime": datenow,
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
    print(response.data);
    if (response.data['responseCode'] == "00") {
      dataPayment = response.data['paymentFee'];
      toggleLoading(false);
    } else {
      toggleLoading(false);
    }
  }
}
