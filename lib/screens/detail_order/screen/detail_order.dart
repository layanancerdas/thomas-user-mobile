import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/ajk_state.dart';
import 'package:tomas/screens/detail_order/widget/list_subscription.dart';
import 'package:tomas/screens/payment_confirmation/payment_confirmation.dart';
import 'package:tomas/screens/payment_webview/screen/payment_webview.dart';
import 'package:tomas/widgets/alert_permit.dart';
import 'package:tomas/widgets/custom_text.dart';

class DetailOrder extends StatefulWidget {
  const DetailOrder({Key key}) : super(key: key);

  @override
  State<DetailOrder> createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AjkState>(
        converter: (store) => store.state.ajkState,
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                leading: TextButton(
                  style: TextButton.styleFrom(),
                  onPressed: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    'assets/images/back_icon.svg',
                  ),
                ),
                // elevation: 3,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CustomText(
                          "${Utils.capitalizeFirstofEach(state.selectedPickUpPoint['name']) ?? "-"}",
                          color: ColorsCustom.black,
                          overflow: true,
                        ),
                      ),
                    ),
                    Container(
                      width: 30,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: SvgPicture.asset('assets/images/exchange.svg'),
                    ),
                    Expanded(
                      child: CustomText(
                        "${Utils.capitalizeFirstofEach(state.selectedRoute['destination_name']) ?? "-"}",
                        color: ColorsCustom.black,
                        overflow: true,
                      ),
                    ),
                  ],
                ),
                actions: [SizedBox(width: 50)],
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    ListView(padding: EdgeInsets.all(20), children: [
                      CustomText(
                        "Detail",
                        color: ColorsCustom.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      ListSubscription(),
                      ListSubscription(),
                      ListSubscription(),
                      ListSubscription(),
                      SizedBox(
                        height: 140,
                      )
                    ]),
                    // ),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    "1 Month",
                                    color: ColorsCustom.primary,
                                    fontSize: 12,
                                  ),
                                  CustomText(
                                    "dd/mm/yyyy - dd/mm/yyyy",
                                    color: ColorsCustom.black,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              CustomText(
                                "Rp. 215.000",
                                color: ColorsCustom.primary,
                                fontSize: 18,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(PaymentConfirmation());
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorsCustom.primary),
                                  child: CustomText(
                                    "Subscribe",
                                    textAlign: TextAlign.center,
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ));
        });
  }
}
