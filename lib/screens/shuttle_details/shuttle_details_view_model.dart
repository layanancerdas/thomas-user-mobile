import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/home/home.dart';
import 'package:tomas/screens/payment_confirmation/payment_confirmation.dart';
import 'package:tomas/screens/success_payment/screen/success_payment.dart';
import 'package:tomas/widgets/custom_dialog.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:uuid/uuid.dart';
import './shuttle_details.dart';
import 'package:tomas/localization/app_translations.dart';

abstract class ShuttleDetailsViewModel extends State<ShuttleDetails> {
  Store<AppState> store;

  Map dataPayment = {};
  List days = [];
  List includedDate = [];
  bool isLoading = false;

  void toggleLoading(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  void setOrderName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('ORDER_NAME', 'jakarta-bogor');
  }

  void setSubsId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('SUBS_ID', '');
  }

  void setOrderAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('ORDER_AMOUNT',
        (store.state.ajkState.selectedPickUpPoint['price'] * 10).toString());
  }

  void setDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('ORDER_DURATION', '0');
  }

  void setOrderID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uuid = Uuid();
    var v4 = await uuid.v4();
    prefs.setString('ORDER_ID', v4);
  }

  Future<void> onBooking() async {
    await setOrderID();
    await setOrderAmount();
    await setDuration();
    await setOrderName();
    await setSubsId();
    if (!store.state.userState.userDetail['permitted_ajk']) {
      permitCheckAndRequest();
    } else {
      toggleLoading(true);
      try {
        print(store.state.ajkState.selectedTrip['trip_group_id']);
        print(store.state.ajkState.selectedPickUpPoint['pickup_point_id']);
        dynamic res = await Providers.bookPackage(
          tripGroupId: store.state.ajkState.selectedTrip['trip_group_id'],
          pickupPointId:
              store.state.ajkState.selectedPickUpPoint['pickup_point_id'],
        );
        print(res.data);
        if (res.data['code'] == 'SUCCESS') {
          if (res.data['data'][0]['status'] == 'SUCCESS') {
            toggleLoading(false);
            showDialogError('my_trips',
                "You have already booked this trip, please check the details of your trip in the My Trips menu.");
          }

          await store.dispatch(SetSelectedMyTrip(
              selectedMyTrip: res.data['data'][0],
              getSelectedTrip: res.data['data']));
          print("1");
          toggleLoading(false);
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => PaymentConfirmation()));
        } else if (res.data['message'].toLowerCase().contains("already")) {
          // await store.dispatch(SetSelectedMyTrip(
          //     selectedMyTrip: res.data['data'][0],
          //     getSelectedTrip: res.data['data']));
          await getBookingByGroupId();
          await getPaymentByInvoiceId();
          if (dataPayment['status'] == 'SUCCESS') {
            toggleLoading(false);
            showDialogError('my_trips',
                "You have already booked this trip, please check the details of your trip in the My Trips menu.");
          } else if (!dataPayment.containsKey('status') ||
              dataPayment['status'] == 'PENDING') {
            print("3");
            toggleLoading(false);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => PaymentConfirmation()));
          }
        } else {
          // toggleLoading(false);
          print(res.data['message']);
          // await onBooking();
          showDialogError('error', "${res.data['message']}, please try again");
        }
      } catch (e) {
        print("Booking");
        print(e);
      }
    }
  }

  getDaysInBetween(DateTime startDate, DateTime endDate) async {
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      await days.add(
          DateFormat('yyyy-MM-dd').format(startDate.add(Duration(days: i))));
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

  Future<void> getPaymentByInvoiceId() async {
    try {
      // toggleIsLoading(true);
      dynamic res = await Providers.getPaymentByInvoiceId(
          invoiceId: store.state.userState.selectedMyTrip['invoice']
              ['invoice_id']);
      print(res.data);
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

  void setIncludedDate() async {
    toggleLoading(true);
    Timer.periodic(Duration(seconds: 1), (timer) {
      for (var i = 0; i < days.length; i++) {
        if (store.state.ajkState.selectedTrip['excluded_dates']
            .contains(days[i])) {
          if (i == days.length - 1) {
            toggleLoading(false);
            timer.cancel();
          }
        } else {
          includedDate.add(days[i]);
          if (i == days.length - 1) {
            toggleLoading(false);
            timer.cancel();
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);

      getUserDetail();
      getVouchers();
      resetSelectedMyTrip();
      getDaysInBetween(
          DateTime.parse(store.state.ajkState.selectedTrip['start_date']),
          DateTime.parse(store.state.ajkState.selectedTrip['end_date']));
      setIncludedDate();
    });
  }
}
