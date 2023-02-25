import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redux/redux.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/localization/app_translations.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/screens/detail_trip/detail_trip.dart';
import 'package:tomas/screens/lifecycle_manager/lifecycle_manager.dart';
import 'package:tomas/screens/payment/payment.dart';
import 'package:tomas/screens/review/review.dart';
import 'package:tomas/widgets/custom_text.dart';

class NotifList extends StatefulWidget {
  final Map data;
  final List listSelected;
  final onSelected, onUpdate;

  NotifList({this.data, this.onSelected, this.listSelected, this.onUpdate});

  @override
  _NotifListState createState() => _NotifListState();
}

class _NotifListState extends State<NotifList> {
  Store<AppState> store;

  String formatTime() {
    if (DateTime.fromMillisecondsSinceEpoch(
                int.parse(widget.data['created_date']))
            .day ==
        DateTime.now().day) {
      return Utils.formatterTime.format(DateTime.fromMillisecondsSinceEpoch(
          int.parse(widget.data['created_date'])));
    } else if (DateTime.fromMillisecondsSinceEpoch(
                int.parse(widget.data['created_date']))
            .day ==
        DateTime.now().day - 1) {
      return 'Yesterday';
    } else {
      return Utils.formatterDateMonth.format(
          DateTime.fromMillisecondsSinceEpoch(
              int.parse(widget.data['created_date'])));
    }
  }

  Future<void> getBookingByGroupId() async {
    store.dispatch(SetIsLoading(isLoading: true));
    try {
      Map data = await jsonDecode(widget.data['data']);

      dynamic res =
          await Providers.getBookingByBookingId(bookingId: data['booking_id']);
      print(res.data['data']);
      store.dispatch(SetSelectedMyTrip(
          selectedMyTrip: res.data['data'],
          getSelectedTrip: [res.data['data']]));
      store.dispatch(SetIsLoading(isLoading: false));
    } catch (e) {
      print(e);
    } finally {
      store.dispatch(SetIsLoading(isLoading: false));
    }
  }

  Future<void> onClick() async {
    await widget.onSelected(widget.data);
    await widget.onUpdate("read");
    String typeNotif = widget.data['type'];

    Map data = await jsonDecode(widget.data['data']);

    if (typeNotif.toLowerCase() == 'waiting_payment') {
      await getBookingByGroupId();
      if (store.state.userState.selectedMyTrip['status'] == 'ACTIVE') {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => DetailTrip(dataNotif: data)));
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => Payment(
                    goToFinish: true,
                    mode: 'unfinish',
                    dataNotif: data,
                  )));
    } else if (typeNotif.toLowerCase() == 'reminder_upcoming_trip' ||
        typeNotif.toLowerCase() == 'order_canceled' ||
        typeNotif.toLowerCase() == 'driver_on_the_way' ||
        typeNotif.toLowerCase() == 'driver_has_arrived' ||
        typeNotif.toLowerCase() == 'arrived_at_destination' ||
        typeNotif.toLowerCase() == 'you_missed_trip') {
      await getBookingByGroupId();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DetailTrip(
                    dataNotif: data,
                  )));
    } else if (typeNotif.toLowerCase() == 'payment_confirmed') {
      await getBookingByGroupId();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => Payment(
                    mode: 'finish',
                    dataNotif: data,
                    // fromDeeplink: true,
                    // dataNotif: data,
                  )));
    } else if (typeNotif.toLowerCase() == 'reminder_for_feedback') {
      await getBookingByGroupId();
      if (store.state.userState.selectedMyTrip['rating'] == null &&
          store.state.userState.selectedMyTrip['review'] == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Review(
                      dataNotif: data,
                    ),
                fullscreenDialog: true));
      }
    } else if (typeNotif.toLowerCase() == 'request_ajk_accepted') {
      Navigator.pushNamed(context, '/SearchAjkShuttle');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GeneralState>(
        converter: (store) => store.state.generalState,
        builder: (context, state) {
          return Row(
            children: [
              state.disableNavbar
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 14),
                      width: 24,
                      height: 24,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.zero,
                          ),
                          //materialTapTargetSize:
                          //materialTapTargetSize.shrinkWrap,

                          onPressed: () => widget.onSelected(widget.data),
                          child: widget.listSelected.contains(widget.data)
                              ? SvgPicture.asset('assets/images/check.svg')
                              : SvgPicture.asset(
                                  "assets/images/rectangle.svg")),
                    )
                  : SizedBox(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        //   highlightColor: Colors.black12,
                        // color: widget.data['is_read']
                        //     ? Colors.white
                        //     : ColorsCustom.primaryVeryLow,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: state.disableNavbar
                            ? RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ))
                            : null,
                      ),
                      onPressed: () => onClick(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color:
                                    ColorsCustom.primaryLow.withOpacity(0.64),
                                borderRadius: BorderRadius.circular(10)),
                            child: SvgPicture.asset(
                              'assets/images/school_bus.svg',
                              height: 14,
                              width: 14,
                            ),
                          ),
                          SizedBox(width: 16),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      // "${Utils.capitalizeFirstofEach(widget.data['type'])}",
                                      "AJK",
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: ColorsCustom.generalText,
                                    ),
                                    CustomText(
                                      "${formatTime()}",
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: ColorsCustom.generalText,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                CustomText(
                                  "${AppTranslations.of(context).currentLanguage == 'id' ? Utils.capitalizeFirstofEach(widget.data['title_id']) : Utils.capitalizeFirstofEach(widget.data['title_en'])}",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsCustom.black,
                                ),
                                SizedBox(height: 4),
                                CustomText(
                                  "${AppTranslations.of(context).currentLanguage == 'id' ? Utils.capitalizeFirstofEach(widget.data['message_id']) : Utils.capitalizeFirstofEach(widget.data['message_en'])}",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: ColorsCustom.black,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: ColorsCustom.border,
                      width: double.infinity,
                      margin: state.disableNavbar
                          ? EdgeInsets.only(left: 16)
                          : EdgeInsets.zero,
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}
