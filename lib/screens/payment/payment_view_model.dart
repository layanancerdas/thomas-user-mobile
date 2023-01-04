import 'dart:async';
import 'package:tomas/localization/app_translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:toast/toast.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/home/home.dart';
import 'package:tomas/screens/lifecycle_manager/lifecycle_manager.dart';
import 'package:tomas/screens/webview/webview.dart';
import 'package:tomas/widgets/custom_text.dart';
import './payment.dart';

abstract class PaymentViewModel extends State<Payment> {
  Store<AppState> store;
  final NumberFormat timeFormat = new NumberFormat("00");

  String mode = "";
  String countdown = "00:00:00";
  DateTime expiredTime = DateTime.now();

  Map dataPayment = {};
  Map dataPaymentMethod = {};

  bool isLoading = false;

  int saveBandwith = 20;
  int loadDataMax = 3;
  Timer timer;

  void toggleIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> toggleMode() async {
    // if (loadDataMax > 0) {
    //   setState(() {
    //     loadDataMax--;
    //   });
    // if (widget.goToFinish) {
    //   await getPaymentByInvoiceId();
    //   if (dataPayment['status'] == 'PAID') {
    //     widget.mode = 'finish';
    //   } else {
    //     return getPaymentByInvoiceId();
    //   }
    // } else {
    await getBookingByGroupId();
    await getPaymentByInvoiceId();
    // print(dataPayment['status']);
    if (dataPayment['status'] == 'SUCCESS') {
      setState(() {
        mode = 'finish';
      });
    } else {
      // Navigator.popUntil(context, ModalRoute.withName("/Home"));
      await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => Home(
                    index: 1,
                    tab: 1,
                    forceLoading: true,
                  )),
          (Route<dynamic> route) => false);

      await Navigator.pushNamed(context, "/DetailTrip");
    }
    store.dispatch(SetSelectedVoucher(selectedVoucher: {}));
    // }
    // } else {
    //   if (saveBandwith >= 20) {
    //     toggleBandwith();
    //   }
    //   showToast(
    //       "Check booking status have limit 3 times, please check after $saveBandwith seconds.",
    //       duration: Toast.LENGTH_LONG,
    //       gravity: Toast.BOTTOM);
    // }
  }

  void toggleBandwith() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(oneSec, (Timer timer) {
      if (mounted) {
        setState(() {
          if (saveBandwith < 1) {
            saveBandwith = 20;
            loadDataMax = 3;
          } else {
            saveBandwith--;
          }
        });
      }
    });
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(
      msg,
      duration: duration,
      gravity: gravity,
      backgroundColor: ColorsCustom.softGrey,
      // textColor: ColorsCustom.generalText
    );
  }

  void onFinish() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => Home(index: 1, tab: 1, forceLoading: true)),
        (Route<dynamic> route) => false);
  }

  // Future<void> onUpdateBooking() async {
  //   try {
  //     toggleIsLoading(true);
  //     dynamic resA = await Providers.updateBooking(
  //         bookingId:
  //             store.state.userState.selectedMyTrip['booking_id'].toString(),
  //         status: "ACTIVE");
  //     // dynamic resB = await Providers.updateBooking(
  //     //     bookingId:
  //     //         store.state.userState.getSelectedTrip[1]['booking_id'].toString(),
  //     //     status: "ACTIVE");
  //     // print(resB.data);
  //     if (resA.data['code'] == "SUCCESS") {
  //       await getBookingData();
  //     }
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     toggleIsLoading(false);

  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (_) => Home(index: 1, tab: 1)),
  //         (Route<dynamic> route) => false);
  //   }
  // }

  Future<void> onPay() async {
    toggleIsLoading(true);
    try {
      dynamic res = await Providers.paymentBooking(
          balanceAmount: store.state.transactionState.useBalance
              ? store.state.transactionState.balances
              : 0,
          invoiceId: store.state.userState.selectedMyTrip['invoice_id'],
          paymentMethodId:
              store.state.transactionState.selectedPaymentMethod['id'] ??
                  dataPaymentMethod['id'],
          voucherId:
              store.state.generalState.selectedVouchers['voucher_id'] ?? null);
      print(res.data);
      if (res.data['code'] == 'SUCCESS') {
        print(res.data['data']['deeplink_url']);

        if (res.data['data']['deeplink_url'] != null) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => Webview(
                        link: res.data['data']['deeplink_url'],
                        title: "Payment",
                      )));
          // await canLaunch(res.data['data']['deeplink_url'])
          //     ? await launch(res.data['data']['deeplink_url'])
          //     : throw 'Could not launch ${res.data['data']['deeplink_url']}';
        }
        await toggleMode();
      } else {
        await getBookingByGroupId();
        await getPaymentByInvoiceId();
        if (dataPayment != null && dataPayment != {}) {
          if (dataPayment['status'] == 'PENDING') {
            print(res.data['data']['deeplink_url']);
            if (res.data['data']['deeplink_url'] != null) {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Webview(
                            link: res.data['data']['deeplink_url'],
                            title: "Payment",
                          )));
            }

            await toggleMode();
            toggleIsLoading(false);
            // showDialogError('my_trips',
            //     "Your payment already process, please check your application for payment method");
          } else if (dataPayment['status'] == 'SUCCESS') {
            await toggleMode();
            toggleIsLoading(false);
            // showDialogError('my_trips',
            //     "You have already booked this trip, please check the details of your trip in the My Trips menu.");
          } else {
            await toggleMode();
            toggleIsLoading(false);
          }
        } else {
          showDialogError(
              'my_trips', "${res.data['message']}\nplease try again");
          // await onPay();
        }
      }
    } catch (e) {
      print("Payment");
      print(e.toString());
    } finally {
      toggleIsLoading(false);
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
                  ? "Pembayaran Gagal"
                  : 'Payment Failed',
              color: ColorsCustom.black),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomText(
              Utils.capitalizeFirstofEach(message),
              color: ColorsCustom.black,
              height: 2,
              fontSize: 12,
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
      print(res.data);
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
      print(res.data);

      if (res.data['code'] == "SUCCESS") {
        print(res.data['data']);
        if (res.data['data'].length > 0) {
          List payMethod;
          if (res.data['data'][0]['pay_method'] != null) {
            payMethod = store.state.transactionState.paymentMethod
                .where((element) =>
                    element['id'].toLowerCase() ==
                    res.data['data'][0]['pay_method'].toLowerCase())
                .toList();
          }
          setState(() {
            dataPayment =
                res.data['data'].length > 0 ? res.data['data'][0] : null;
            dataPaymentMethod = payMethod != null ? payMethod[0] : {};
          });
        }
      }
    } catch (e) {
      print(e);
    } finally {
      // toggleIsLoading(false);
    }
  }

  void getCountdown() {
    if (store.state.userState.selectedMyTrip.containsKey('invoice')) {
      if (store.state.userState.selectedMyTrip['invoice']['expired_at'] >
          DateTime.now().millisecondsSinceEpoch) {
        DateTime getExpiredTime = DateTime.fromMillisecondsSinceEpoch(
            store.state.userState.selectedMyTrip['invoice']['expired_at']);

        setState(() {
          expiredTime = getExpiredTime;
          countdown =
              "${timeFormat.format(getExpiredTime.difference(DateTime.now()).inHours % 24)}:${timeFormat.format(getExpiredTime.difference(DateTime.now()).inMinutes % 60)}:${timeFormat.format(getExpiredTime.difference(DateTime.now()).inSeconds % 60)}";
        });
      }
    }
  }

  Future<void> checkPaid() async {
    await getBookingByGroupId();
    await getPaymentByInvoiceId();
    print(dataPayment['status']);
    if (dataPayment.containsKey('status') &&
        dataPayment['status'] == 'SUCCESS') {
      setState(() {
        mode = 'finish';
      });
    }
    toggleIsLoading(false);
  }

  Future<void> getBookingFromNotif() async {
    try {
      dynamic res = await Providers.getBookingByBookingId(
          bookingId: widget.dataNotif['booking_id']);
      store.dispatch(SetSelectedMyTrip(
          selectedMyTrip: res.data['data'],
          getSelectedTrip: [res.data['data']]));
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    mode = widget.mode;
    super.initState();
    Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        // checkPaid();
        getCountdown();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
      getCountdown();
      if (widget.dataNotif != null) {
        getBookingFromNotif();
      } else {
        // checkPaid();
      }
    });
  }
}
