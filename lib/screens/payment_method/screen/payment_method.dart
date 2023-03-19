import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/screens/payment_confirmation/payment_confirmation.dart';
import 'package:tomas/screens/payment_confirmation/widgets/card_payment_method.dart';
import 'package:tomas/screens/payment_method/controller/payment_method_controller.dart';
import 'package:tomas/screens/payment_method/widget/card_payment_method.dart';
import 'package:tomas/screens/shuttle_detail_easyride/shuttle_details_easyride.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:crypto/crypto.dart';

class PaymentMethod extends StatefulWidget {
  final int amount;
  final String page;
  const PaymentMethod({Key key, this.amount, this.page}) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String formattedDateNow =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  var signature = '';
  int amount;
  final controller = Get.put(PaymentMethodController());
  void setSha256() async {
    setState(() {
      signature = sha256
          .convert(utf8.encode(BASE_MERCHANT_CODE +
              widget.amount.toString() +
              formattedDateNow +
              DUITKU_API_KEY))
          .toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setSha256();
    controller.getPaymentMethods(widget.amount, formattedDateNow, signature);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: TextButton(
            style: TextButton.styleFrom(),
            onPressed: () => Navigator.pop(context),
            child: SvgPicture.asset(
              'assets/images/back_icon.svg',
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: CustomText(
            "Payment Method",
            color: ColorsCustom.black,
          ),
        ),
        body: Container(
            color: Colors.white,
            child: Obx(() => controller.isLoading.value
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
                : ListView.builder(
                    itemCount: controller.dataPayment.length + 1,
                    itemBuilder: (context, index) => index ==
                            controller.dataPayment.length
                        ? CardPaymentMethodList(
                            urlImages: '212121',
                            name: 'PLAFON KOPKAR',
                            onTapMethod: () {
                              widget.page == 'easyride'
                                  ? Get.off(ShuttleDetailsEasyRide())
                                  : Get.off(PaymentConfirmation(),
                                      arguments: controller.dataPayment[index]);
                            },
                          )
                        : CardPaymentMethodList(
                            urlImages: controller.dataPayment[index]
                                ['paymentImage'],
                            name: controller.dataPayment[index]['paymentName'],
                            onTapMethod: () {
                              controller.setPaymentMethod(
                                  controller.dataPayment[index]);
                              widget.page == 'easyride'
                                  ? Get.off(ShuttleDetailsEasyRide())
                                  : Get.off(PaymentConfirmation(),
                                      arguments: controller.dataPayment[index]);
                            },
                          )))));
  }
}
