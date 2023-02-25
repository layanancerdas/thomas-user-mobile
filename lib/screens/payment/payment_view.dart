import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/screens/payment/widgets/card_finish_wallet.dart';
import 'package:tomas/screens/payment/widgets/card_instructor.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/custom_text.dart';
import './payment_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class PaymentView extends PaymentViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !widget.fromDeeplink,
          leading: TextButton(
            style: TextButton.styleFrom(),
            onPressed: () => Navigator.pop(context),
            child: SvgPicture.asset(
              'assets/images/back_icon.svg',
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: mode == 'unfinish'
              ? CustomText(
                  "${AppTranslations.of(context).text("payment")}",
                  color: ColorsCustom.black,
                )
              : SizedBox(),
        ),
        body: Stack(
          children: [
            mode == 'unfinish'
                ? ListView(
                    padding: EdgeInsets.only(
                        top: 16, left: 16, right: 16, bottom: 120),
                    children: [
                        CustomText(
                          "${AppTranslations.of(context).text("complete_the_payment")}",
                          color: ColorsCustom.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: ColorsCustom.primaryOrangeVeryLow),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "${Utils.formatterDateLong.format(expiredTime)}",
                                color: ColorsCustom.primaryOrangeHigh,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              CustomText(
                                "$countdown",
                                color: ColorsCustom.primaryOrangeHigh,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        CardInstructor(
                          dataPayment: dataPayment,
                          paymentMethod: dataPaymentMethod,
                          isLoading: isLoading,
                        ),
                        SizedBox(height: 16),
                        CustomText(
                          "${AppTranslations.of(context).text("after_payment")}",
                          color: ColorsCustom.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ])
                : Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                          top: 16, left: 16, right: 16, bottom: 120),
                      child: Column(
                        children: [
                          SvgPicture.asset('assets/images/congratulation.svg'),
                          CustomText(
                            "${AppTranslations.of(context).text("congratulations")}",
                            color: ColorsCustom.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          SizedBox(height: 5),
                          CustomText(
                            "${AppTranslations.of(context).text("success_payment")}",
                            color: ColorsCustom.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          SizedBox(height: 24),
                          widget.dataNotif != null
                              ? SizedBox()
                              : CardFinishWallet(
                                  paymentMethod: dataPaymentMethod,
                                  dataPayment: dataPayment,
                                  isLoading: isLoading,
                                  dataNotif: widget.dataNotif ?? null,
                                )
                        ],
                      ),
                    ),
                  ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(3, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: CustomButton(
                    onPressed: () => mode == 'finish' ? onFinish() : onPay(),
                    bgColor: ColorsCustom.primary,
                    textColor: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    text: widget.mode == 'unfinish'
                        ? "${AppTranslations.of(context).text("continue")}"
                        : "${AppTranslations.of(context).text("view_my_trip")}",
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                )),
            isLoading
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
                : SizedBox()
          ],
        ));
  }
}
