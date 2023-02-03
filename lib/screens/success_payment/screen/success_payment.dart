import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/screens/home/home.dart';
import 'package:tomas/screens/my_trips/my_trips.dart';
import 'package:tomas/widgets/custom_text.dart';

class SuccessPayment extends StatelessWidget {
  const SuccessPayment({Key key}) : super(key: key);

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
        title: CustomText(
          "Success Transaction",
          color: ColorsCustom.black,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(12),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/success_payment.png',
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      CustomText(
                        "Congratulations!",
                        color: ColorsCustom.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomText(
                        "Your payment is successful.",
                        color: ColorsCustom.black,
                        fontSize: 16,
                      ),
                    ]),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () => Get.off(Home()),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorsCustom.primary,
                    ),
                    child: CustomText(
                      "Close",
                      color: Colors.white,
                      fontSize: 16,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
