import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/transaction_action.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/home/home.dart';
import 'package:tomas/screens/lifecycle_manager/lifecycle_manager.dart';
import 'package:tomas/screens/payment/payment.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/modal_payment_method.dart';
import './payment_confirmation.dart';

abstract class PaymentConfirmationViewModel extends State<PaymentConfirmation> {
  Store<AppState> store;
  final GlobalKey<ScaffoldState> paymentConfirmationKey =
      GlobalKey<ScaffoldState>();
  PersistentBottomSheetController bottomSheetController;

  Map dataPayment = {};

  String errorPaymentMethod = "";

  bool isLoading = false;
  bool errorPayment = false;

  void toggleLoading(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  void toggleUseBalance() {
    store.dispatch(UseBalance());
  }

  Future<void> onNext() async {
    toggleLoading(true);
    print("1");
    if (store.state.ajkState.selectedPickUpPoint['price'] > 0) {
      print("2");
      if (store.state.transactionState.selectedPaymentMethod == {}) {
        return onWalletClick();
      }

      if (store.state.transactionState.useBalance) {
        print("3");
        if (store.state.generalState.selectedVouchers
            .containsKey("voucher_id")) {
          if (store.state.generalState.selectedVouchers['discount_type'] ==
                  'AMOUNT' &&
              store.state.transactionState.balances <
                  store.state.ajkState.selectedPickUpPoint['price'] * 10 -
                      store.state.generalState
                          .selectedVouchers['discount_amount']) {
            return Utils.onLowBalance(context: context);
          } else if (store.state.transactionState.balances <
              store.state.ajkState.selectedPickUpPoint['price' * 10] -
                  (store.state.ajkState.selectedPickUpPoint['price'] *
                      10 *
                      (store.state.generalState
                              .selectedVouchers['discount_percentage'] *
                          100) ~/
                      100)) {
            return Utils.onLowBalance(context: context);
          } else if (store.state.transactionState.balances <
              store.state.ajkState.selectedPickUpPoint['price'] * 10) {
            return Utils.onLowBalance(context: context);
          }
        }
      } else {
        // if (widget.detail &&
        //     store.state.userState.selectedMyTrip['invoice']['total_amount'] <=
        //         0) {
        //   return await onZeroPricePay();
        // }

        print("4");
        int price = store.state.ajkState.selectedPickUpPoint['price'] * 10;
        int discount = 0;

        print("price: $price");
        print("discount: $discount");

        if (store.state.generalState.selectedVouchers
            .containsKey("voucher_id")) {
          print("5");
          discount = store
                      .state.generalState.selectedVouchers['discount_type'] ==
                  'AMOUNT'
              ? store.state.ajkState.selectedPickUpPoint['price'] * 10 -
                  store.state.generalState.selectedVouchers['discount_amount']
              : store.state.ajkState.selectedPickUpPoint['price'] *
                  10 *
                  (store.state.generalState
                          .selectedVouchers['discount_percentage'] *
                      100) ~/
                  100;

          print("discount-true:$discount");
        }
        print('6');
        print((price - discount) <= 0);
        if ((price - discount) <= 0) {
          print("7");
          return await onZeroPricePay();
        } else {
          print("8");
          await getBookingByGroupId();
          await getPaymentByInvoiceId();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => Payment(
                        mode: "unfinish",
                        // detail: widget.detail,
                        // goToFinish: widget.goToFinish,
                      )));
        }
      }
    } else {
      print("9");
      await onZeroPricePay();
    }
    print("10");
    toggleLoading(false);
  }

  Future<void> onZeroPricePay() async {
    toggleLoading(true);
    try {
      dynamic res = await Providers.paymentBooking(
          balanceAmount: store.state.transactionState.useBalance
              ? store.state.transactionState.balances
              : 0,
          invoiceId: store.state.userState.selectedMyTrip['invoice_id'],
          paymentMethodId:
              store.state.transactionState.selectedPaymentMethod['id'] ?? null,
          voucherId:
              store.state.generalState.selectedVouchers['voucher_id'] ?? null);
      print(res.data);
      if (res.data['code'] == 'SUCCESS') {
        // await store.dispatch(SetSelectedMyTrip(
        //     selectedMyTrip: res.data['data'][0],
        //     getSelectedTrip: res.data['data']));

        // await getBookingByGroupId();
        // await getPaymentByInvoiceId();

        // if (dataPayment != null && dataPayment != {}) {
        //   print(res.data['data']);

        //   if (dataPayment['status'] == 'SUCCESS') {

        await getBookingByGroupId();
        // await getPaymentByInvoiceId();
        // await LifecycleManager.of(context).getBookingData();

        toggleLoading(false);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Payment(
                      mode: "finish",
                      // detail: widget.detail,
                      // goToFinish: widget.goToFinish,
                    )));
        // } else {
        //   print('error');
        // }
        // } else {
        //   print("error2");
        // }
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

  Future<void> getPaymentByInvoiceId() async {
    try {
      // toggleIsLoading(true);
      dynamic res = await Providers.getPaymentByInvoiceId(
          invoiceId: store.state.userState.selectedMyTrip['invoice']
              ['invoice_id']);

      if (res.data['code'] == "SUCCESS") {
        setState(() {
          dataPayment =
              res.data['data'].length > 0 ? res.data['data'][0] : null;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      // toggleIsLoading(false);
    }
  }

  void onWalletClick() {
    setState(() {
      errorPaymentMethod = "";
    });
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: double.infinity,
              color: Colors.black.withOpacity(0.2),
              child: ModalPaymentMethod());
        },
        backgroundColor: Colors.black.withOpacity(0.2));
  }

  // Future<void> onClick() async {
  //   await getBookingByTripId();
  // }

  Future<void> getPaymentMethods() async {
    try {
      if (store.state.transactionState.paymentMethod.length <= 0) {
        dynamic res = await Providers.getPaymentMethods();
        store.dispatch(SetPaymentMethod(paymentMethod: res.data['data']));
      }
    } catch (e) {
      print("vouchers");
      print(e);
    }
  }

  Future<void> initData() async {
    toggleLoading(true);
    await LifecycleManager.of(context).getVouchers();
    await getPaymentMethods();
    if (store.state.ajkState.selectedPickUpPoint['price'] > 0) {
      await store.dispatch(SetSelectedPaymentMethod(
          selectedPaymentMethod:
              store.state.transactionState.paymentMethod[0]));
    }
    toggleLoading(false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
      initData();
    });
  }
}
