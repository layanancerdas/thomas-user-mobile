import 'dart:async';
import 'package:tomas/localization/app_translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/ajk_action.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/home/home.dart';
import 'package:tomas/screens/lifecycle_manager/lifecycle_manager.dart';
import 'package:tomas/screens/payment/payment.dart';
import 'package:tomas/screens/payment_confirmation/payment_confirmation.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/custom_toast.dart';
import './detail_trip.dart';

abstract class DetailTripViewModel extends State<DetailTrip> {
  Store<AppState> store;
  ScrollController scrollController = ScrollController();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  NumberFormat timeFormat = new NumberFormat("00");

  bool onBottom = false;
  Map dataPayment = {};

  List tripHistory = [];

  bool isLoading = false;

  String status = "";
  String countdown = "00:00:00";

  void toggleIsLoading(bool value) {
    if (mounted)
      setState(() {
        isLoading = value;
      });
  }

  void getCountdown() {
    if (store.state.userState.selectedMyTrip.containsKey('invoice')) {
      if (store.state.userState.selectedMyTrip['invoice']['expired_at'] >
          DateTime.now().millisecondsSinceEpoch) {
        DateTime getExpiredTime = DateTime.fromMillisecondsSinceEpoch(
            store.state.userState.selectedMyTrip['invoice']['expired_at']);

        setState(() {
          countdown =
              "${timeFormat.format(getExpiredTime.difference(DateTime.now()).inHours % 24)}:${timeFormat.format(getExpiredTime.difference(DateTime.now()).inMinutes % 60)}:${timeFormat.format(getExpiredTime.difference(DateTime.now()).inSeconds % 60)}";
        });
      }
    }
  }

  void getStatusText() {
    String pickupPoint =
        '${store.state.userState.selectedMyTrip['trip']['type'] == 'RETURN' ? store.state.userState.selectedMyTrip['trip']['trip_group']['route']['destination_name'] : store.state.userState.selectedMyTrip['pickup_point']['name']}';
    setState(() {
      // print(store.state.userState.selectedMyTrip['status']);

      if (store.state.userState.selectedMyTrip['status'] == "PENDING") {
        status = "${AppTranslations.of(context).text("waiting_for_payment")}";
      } else if (store.state.userState.selectedMyTrip['status'] ==
          "COMPLETED") {
        status = "${AppTranslations.of(context).text("completed")}";
      } else if (store.state.userState.selectedMyTrip['status'] == "CANCELED") {
        status = "${AppTranslations.of(context).text("canceled")}";
      } else if (store.state.userState.selectedMyTrip['status'] == "MISSED") {
        status = "${AppTranslations.of(context).text("missed_trip")}";
      } else if (store.state.userState.selectedMyTrip['status'] == "ACTIVE") {
        if (store.state.userState.selectedMyTrip['booking_note'] != null) {
          if (store.state.userState.selectedMyTrip['booking_note'] ==
              'DRIVER_ON_THE_WAY') {
            status =
                '${AppTranslations.of(context).text("driver_on_the_way")} ${AppTranslations.of(context).text("at")} $pickupPoint';
          } else if (store.state.userState.selectedMyTrip['booking_note'] ==
              'DRIVER_HAS_ARRIVED') {
            status =
                "${AppTranslations.of(context).text("driver_has_arrived")} ${AppTranslations.of(context).text("at")} $pickupPoint";
          } else if (store.state.userState.selectedMyTrip['booking_note'] ==
                  'ON_BOARD' ||
              store.state.userState.selectedMyTrip['attended']) {
            status = "${AppTranslations.of(context).text("on_board")}";
          }
        } else {
          status = "${AppTranslations.of(context).text("booking_confirmed")}";
        }
      } else {
        status = "Loading...";
      }
    });
  }

  Color getColorTypeText() {
    if (status == "${AppTranslations.of(context).text("driver_has_arrived")}" ||
        status == "${AppTranslations.of(context).text("driver_on_the_way")}") {
      return ColorsCustom.primaryGreenHigh;
    } else if (status ==
        "${AppTranslations.of(context).text("waiting_for_payment")}") {
      return ColorsCustom.primaryOrangeHigh;
    } else if (status == "${AppTranslations.of(context).text("canceled")}" ||
        status == "${AppTranslations.of(context).text("missed_trip")}") {
      return ColorsCustom.primaryHigh;
    } else if (status ==
        "${AppTranslations.of(context).text("booking_confirmed")}") {
      return ColorsCustom.primaryBlueHigh;
    } else if (status == "${AppTranslations.of(context).text("completed")}") {
      return ColorsCustom.generalText;
    } else {
      return Colors.black;
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
          dataPayment = res.data['data'][0] ?? {};
        });
      }
    } catch (e) {
      print(e);
    } finally {
      // toggleIsLoading(false);
    }
  }

  Future<void> onRefresh() async {
    await getBookingByGroupId();
    await getRouteById();
    // await getBookingByGroupId();

    refreshController.refreshCompleted();
  }

  // Future<void> getTripOrderId() async {
  //   if (store.state.userState.selectedMyTrip['details'] != null) {
  //     try {
  //       dynamic res = await Providers.getTripOrderById(
  //           tripOrderId: store.state.userState.selectedMyTrip['details']
  //               ['trip_order_id']);
  //       List _temp = res.data['data']['trip_histories'] as List;

  //       setState(() {
  //         tripHistory = _temp
  //             .where((element) =>
  //                 element['pickup_point_id'] ==
  //                 store.state.userState.selectedMyTrip['pickup_point']
  //                     ['pickup_point_id'])
  //             .toList();
  //       });
  //       // print(tripOrder);
  //     } catch (e) {
  //       print(e);
  //     } finally {
  //       getStatusText();
  //     }
  //   } else {
  //     getStatusText();
  //   }
  // }

  Future<void> getBookingByGroupId() async {
    try {
      dynamic res = await Providers.getBookingByBookingId(
          bookingId: store.state.userState.selectedMyTrip['booking_id']);
      print('booking id');
      print(res.data['data']);
      store.dispatch(SetSelectedMyTrip(
          selectedMyTrip: res.data['data'],
          getSelectedTrip: [res.data['data']]));
      store.dispatch(SetSelectedPickUpPoint(
          selectedPickUpPoint: res.data['data']['pickup_point']));
      store.dispatch(SetSelectedTrip(
          selectedTrip: res.data['data']['trip']['trip_group']));
    } catch (e) {
      print('booking id');
      print(e);
    }
  }

  Future<void> getRouteById() async {
    try {
      dynamic res = await Providers.getAjkRouteById(
          routeId: store.state.userState.selectedMyTrip['trip']['trip_group']
              ['route_id']);
      print('route id');
      // print(res.data['data']);
      store.dispatch(SetSelectedRoute(selectedRoute: res.data['data']));
    } catch (e) {
      print('route id');

      print(e);
    }
  }

  Future<void> onPaymentInstructionsClick() async {
    toggleIsLoading(true);
    await getPaymentByInvoiceId();
    if (dataPayment.containsKey('invoice_id')) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => Payment(
                    goToFinish: true,
                    // detail: true,
                    mode: 'unfinish',
                  )));
      toggleIsLoading(false);
    } else {
      await getBookingByGroupId();
      await getRouteById();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => PaymentConfirmation(
                    goToFinish: true,
                    // detail: true,
                  )));
      toggleIsLoading(false);
    }
  }

  void onConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: CustomText(
            AppTranslations.of(context).currentLanguage == 'id'
                ? "Konfirmasi"
                : 'Confirmation',
            color: ColorsCustom.black,
          ),
          content: CustomText(
            AppTranslations.of(context).currentLanguage == 'id'
                ? 'Apakah Anda yakin ingin membatalkan pemesanan ini?'
                : 'Are you sure you want cancel this booking?',
            color: ColorsCustom.generalText,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                onCancelBooking();
              },
              child: CustomText(
                AppTranslations.of(context).currentLanguage == 'id'
                    ? "Ya"
                    : 'Yes',
                color: ColorsCustom.blueSystem,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(),
              onPressed: () => Navigator.pop(context),
              child: CustomText(
                  AppTranslations.of(context).currentLanguage == 'id'
                      ? "Tidak"
                      : 'No',
                  color: ColorsCustom.blueSystem,
                  fontWeight: FontWeight.w600),
            ),
          ],
        );
      },
    );
  }

  void onCopy(String value) {
    Clipboard.setData(ClipboardData(text: value));
    showDialog(
        context: context,
        barrierColor: Colors.white24,
        builder: (BuildContext context) {
          return CustomToast(
            image: "success_icon_white.svg",
            title: AppTranslations.of(context).currentLanguage == 'id'
                ? "ID Pemesanan Di Salin"
                : "Booking ID Copied",
            color: ColorsCustom.primaryGreen,
            duration: Duration(seconds: 1),
          );
        });
  }

  Future<void> onShowDialogCancel() async {
    showDialog(
        context: context,
        barrierColor: Colors.white24,
        builder: (BuildContext context) {
          return CustomToast(
            image: "success_icon_white.svg",
            title: AppTranslations.of(context).currentLanguage == 'id'
                ? "Pemesanan Berhasil Dibatalkan"
                : "Booking Cancelled Successfully",
            color: ColorsCustom.primaryGreen,
            duration: Duration(seconds: 3),
          );
        });
  }

  Future<void> onCancelBooking() async {
    try {
      dynamic res = await Providers.cancelBooking(
        bookingId: store.state.userState.selectedMyTrip['booking_id'],
      );
      if (res.data['code'] == "SUCCESS") {
        await LifecycleManager.of(context).getBookingData();
        await getBookingByGroupId();
        Navigator.pushNamedAndRemoveUntil(
            context, '/Home', (Route<dynamic> route) => false);
      }
    } catch (e) {
      print(e);
    } finally {
      await onShowDialogCancel();
    }
  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        onBottom = true;
      });
    } else {
      setState(() {
        onBottom = false;
      });
    }
  }

  Future<bool> onWillPop() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => Home(
                  index: 1,
                  tab: 1,
                  forceLoading: true,
                )),
        (Route<dynamic> route) => false);
    return false;
  }

  Future<void> initData() async {
    // await getTripOrderId();
    getStatusText();
    print(status);
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
    super.initState();
    Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        getCountdown();
        getStatusText();
      }
    });

    // Timer.periodic(Duration(seconds: 5), (_) {
    //   // getBookingByGroupId();
    //   LifecycleManager.of(context).getBookingData();
    // });

    // Timer.periodic(Duration(seconds: 3), (_) {
    //   getTripOrderId();
    // });

    scrollController.addListener(() => scrollListener());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
      getCountdown();
      // getBookingByGroupId();
      // getTripOrderId();
      getStatusText();
      LifecycleManager.of(context).getBookingData();
      initData();
      if (widget.dataNotif != null) {
        getBookingFromNotif();
      }
    });
  }
}
