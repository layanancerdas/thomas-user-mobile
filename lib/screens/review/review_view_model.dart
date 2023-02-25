import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/home/home.dart';
import 'package:tomas/screens/lifecycle_manager/lifecycle_manager.dart';
import 'package:tomas/widgets/custom_toast.dart';
import './review.dart';

abstract class ReviewViewModel extends State<Review> {
  Store<AppState> store;
  final ScrollController scrollController = ScrollController();
  TextEditingController descController = TextEditingController();
  int valueReview = 5;

  List<String> valueFastResponse = [];

  void toggleValueReview(int value) {
    setState(() {
      valueReview = value;
    });
  }

  void toggleFastResponse(String value) {
    print(value);
    print(valueFastResponse.contains(value));
    if (valueFastResponse.contains(value)) {
      setState(() {
        valueFastResponse.removeWhere((element) => element == value);
      });
    } else {
      setState(() {
        valueFastResponse.add(value);
      });
    }
    print(valueFastResponse);
  }

  String getFastResponse() {
    var concatenate = StringBuffer();
    valueFastResponse.forEach((item) {
      if (valueFastResponse.length > 1) {
        concatenate.write(item + ', ');
      }
    });

    return concatenate.toString();
  }

  Future<void> onDescTap() async {
    Timer(Duration(milliseconds: 100), () {
      print("onDesc");
      print(scrollController.position.maxScrollExtent);
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    });
  }

  void onFinish() {
    showDialog(
        context: context,
        barrierColor: Colors.white24,
        builder: (BuildContext context) {
          return CustomToast(
            image: "angel.svg",
            title: AppTranslations.of(context).currentLanguage == 'id'
                ? "Terima kasih! Ulasan Anda akan membantu meningkatkan layanan kami"
                : "Thank you! Your review will help improve our service",
            color: ColorsCustom.primaryGreen,
            duration: Duration(seconds: 3),
          );
        });
  }

  Future<void> onSubmit() async {
    store.dispatch(SetIsLoading(isLoading: true));
    try {
      dynamic res = await Providers.reviewBooking(
          bookingId: store.state.userState.selectedMyTrip['booking_id'],
          review: valueReview,
          desc:
              "${valueFastResponse.length > 0 ? getFastResponse() : ""}${descController.text}");
      print(res.data);
      if (res.data['message'] == 'SUCCESS') {
        print("isFromDetail: ${widget.isFromDetail}");
        await getBookingByGroupId();
        store.dispatch(SetIsLoading(isLoading: false));
        if (widget.isFromDetail) {
          Navigator.pop(context);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => Home(
                        index: 1,
                        tab: 1,
                        forceLoading: true,
                      )),
              (Route<dynamic> route) => false);
        }

        onFinish();
      }
    } catch (e) {
      print(e);
    } finally {
        store.dispatch(SetIsLoading(isLoading: false));
    }
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

  Future<void> getBookingDataNotif() async {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
      if (widget.dataNotif != null) {
        getBookingDataNotif();
      }
    });
  }
}
