import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redux/redux.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class PaymentInfo extends StatefulWidget {
  final bool hideReceipt;

  PaymentInfo({this.hideReceipt: false});

  @override
  _PaymentInfoState createState() => _PaymentInfoState();
}

class _PaymentInfoState extends State<PaymentInfo> {
  Store<AppState> store;

  Map dataPayment = {};
  Map dataPaymentMethod = {};

  int discount = 0;

  Future<void> getPaymentByInvoiceId() async {
    try {
      // toggleIsLoading(true);
      dynamic res = await Providers.getPaymentByInvoiceId(
          invoiceId: store.state.userState.selectedMyTrip['invoice']
              ['invoice_id']);

      if (res.data['code'] == "SUCCESS") {
        List payMethod = store.state.transactionState.paymentMethod
            .where((element) =>
                element['id'].toLowerCase() ==
                res.data['data'][0]['pay_method'].toLowerCase())
            .toList();
        setState(() {
          dataPayment =
              res.data['data'].length > 0 ? res.data['data'][0] : null;
          dataPaymentMethod = payMethod[0];
        });
      }
      await getVoucherById(
          res.data['data'].length > 0 ? res.data['data'][0] : null);
    } catch (e) {
      print(e);
    } finally {
      // toggleIsLoading(false);
      print(dataPayment);
    }
  }

  Future<void> getVoucherById(Map data) async {
    print("uwuw");
    try {
      // toggleIsLoading(true);
      dynamic res =
          await Providers.getVouchersById(voucherId: dataPayment['voucher_id']);
      print(res.data);
      print(res.data['data']);

      if (res.data['code'] == "SUCCESS") {
        setState(() {
          discount = res.data['data']['discount_type'] == 'AMOUNT'
              ? res.data['data']['discount_amount']
              : (int.parse(dataPayment['amount']) *
                  (res.data['data']['discount_percentage'] * 100) ~/
                  100);
        });
      }
    } catch (e) {
      print(e);
    }
    print(discount);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
      getPaymentByInvoiceId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.only(top: 14),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0),
                        spreadRadius: 1,
                        blurRadius: 4,
                        color: ColorsCustom.black.withOpacity(0.15))
                  ]),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        "${AppTranslations.of(context).text("payment_method")}",
                        color: ColorsCustom.generalText,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 1.8,
                      ),
                      dataPaymentMethod != null
                          ? SizedBox(
                              height: 20,
                              child:
                                  SvgPicture.asset('assets/images/coupon.svg'))
                          // Image.network(
                          //   "$BASE_API/files/${dataPaymentMethod['logo']}",
                          // ))
                          : SizedBox(),
                    ],
                  ),
                ),
                Divider(color: Colors.grey, height: 1),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            "${state.userState.getSelectedTrip.length > 0 ? Utils.capitalizeFirstofEach(state.userState.selectedMyTrip['pickup_point']['name'].length > 14 ? state.userState.selectedMyTrip['pickup_point']['name'].substring(0, 13) + "..." : state.userState.selectedMyTrip['pickup_point']['name']) : "-"} to ${state.userState.getSelectedTrip.length > 0 ? Utils.capitalizeFirstofEach(state.userState.selectedMyTrip['trip']['trip_group']['route']['destination_name'].length > 14 ? state.userState.selectedMyTrip['trip']['trip_group']['route']['destination_name'].substring(0, 13) + "..." : state.userState.selectedMyTrip['trip']['trip_group']['route']['destination_name']) : '-'} x 5",
                            color: ColorsCustom.generalText,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 1.8,
                          ),
                          CustomText(
                            "Rp${state.userState.getSelectedTrip.length > 0 ? Utils.currencyFormat.format(state.userState.selectedMyTrip['pickup_point']['price'] * 5) : "-"}",
                            color: ColorsCustom.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            height: 1.8,
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            "${state.userState.getSelectedTrip.length > 0 ? Utils.capitalizeFirstofEach(state.userState.selectedMyTrip['trip']['trip_group']['route']['destination_name'].length > 14 ? state.userState.selectedMyTrip['trip']['trip_group']['route']['destination_name'].substring(0, 13) + "..." : state.userState.selectedMyTrip['trip']['trip_group']['route']['destination_name']) : '-'} to ${state.userState.getSelectedTrip.length > 0 ? Utils.capitalizeFirstofEach(state.userState.selectedMyTrip['pickup_point']['name'].length > 14 ? state.userState.selectedMyTrip['pickup_point']['name'].substring(0, 13) + "..." : state.userState.selectedMyTrip['pickup_point']['name']) : "-"} x 5",
                            color: ColorsCustom.generalText,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 1.8,
                            overflow: true,
                          ),
                          CustomText(
                            "Rp${state.userState.getSelectedTrip.length > 0 ? Utils.currencyFormat.format(state.userState.selectedMyTrip['pickup_point']['price'] * 5) : "-"}",
                            color: ColorsCustom.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            height: 1.8,
                            overflow: true,
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            "${AppTranslations.of(context).text("voucher_discount")}",
                            color: ColorsCustom.primaryGreenHigh,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 1.8,
                          ),
                          CustomText(
                            "-Rp${Utils.currencyFormat.format(discount)}",
                            color: ColorsCustom.primaryGreenHigh,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            height: 1.8,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(color: Colors.grey, height: 1),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        "${AppTranslations.of(context).text("total_price")}",
                        color: ColorsCustom.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 1.8,
                      ),
                      CustomText(
                        "Rp${Utils.currencyFormat.format(state.userState.selectedMyTrip['invoice']['total_amount'] - discount)}",
                        color: ColorsCustom.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        height: 1.8,
                      ),
                    ],
                  ),
                ),
                widget.hideReceipt
                    ? SizedBox()
                    : Divider(color: Colors.grey, height: 1),
                widget.hideReceipt
                    ? SizedBox()
                    : Container(
                        width: double.infinity,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              )),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              //materialTapTargetSize:
                              //materialTapTargetSize.shrinkWrap,
                              // highlightColor:
                              //     ColorsCustom.black.withOpacity(0.12),
                            ),
                            onPressed: () {},
                            child: CustomText(
                              "${AppTranslations.of(context).text("download_receipt")}",
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: ColorsCustom.primary,
                            )),
                      )
              ]));
        });
  }
}
