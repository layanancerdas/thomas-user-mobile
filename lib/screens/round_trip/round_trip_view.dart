import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/ajk_state.dart';
import 'package:tomas/screens/subscribe_trip/screen/subscribe_trip.dart';
import 'package:tomas/widgets/alert_permit.dart';
import 'package:tomas/widgets/card_round_trip.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/no_result_search_ajk.dart';
import './round_trip_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class RoundTripView extends RoundTripViewModel {
  @override
  bool isSubscribe = false;
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
              body: Stack(
                children: [
                  // SmartRefresher(
                  // enablePullDown: true,
                  // header: WaterDropMaterialHeader(),
                  // controller: refreshController,
                  // onRefresh: onRefresh,
                  // child:
                  ListView(padding: EdgeInsets.zero, children: [
                    AlertPermit(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                left: 16,
                                right: 8,
                              ),
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/images/calendar.svg',
                              )),
                          CustomText(
                            "${AppTranslations.of(context).text("travel_on")}",
                            color: ColorsCustom.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                          CustomText(
                            // "",
                            // "${state.resolveDate['start_date']}",
                            "${state.resolveDate.containsKey('start_date') ? Utils.formatterDate.format(DateTime.parse(state.resolveDate['start_date'])) : "-"}",
                            color: ColorsCustom.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          CustomText(
                            " - ",
                            color: ColorsCustom.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                          // Container(
                          //   width: 30,
                          //   margin: EdgeInsets.symmetric(horizontal: 5),
                          //   child: Image.asset('assets/images/arrow.png'),
                          // ),
                          CustomText(
                            // "",
                            // "${state.resolveDate['end_date']}",
                            "${state.resolveDate.containsKey('end_date') ? Utils.formatterDateWithYear.format(DateTime.parse(state.resolveDate['end_date'])) : "-"}",
                            color: ColorsCustom.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            isSubscribe
                                ? 'Subscribe active'
                                : 'Subscribe is not active',
                            color: isSubscribe
                                ? ColorsCustom.newGreen
                                : ColorsCustom.primary,
                            fontSize: 14,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(SubscribeTrip(
                                  idRoute: state.selectedRoute['route_id']));
                              setState(() {
                                isSubscribe = !isSubscribe;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorsCustom.primary,
                                  borderRadius: BorderRadius.circular(20)),
                              padding: EdgeInsets.all(12),
                              child: CustomText(
                                isSubscribe ? 'Subscribe Now' : 'Subscribe Now',
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    trips.length > 0
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: trips.length,
                            shrinkWrap: true,
                            itemBuilder: (ctx, i) {
                              return CardRoundtrip(
                                color: i == 0
                                    ? 'blue'
                                    : i == 1
                                        ? 'yellow'
                                        : 'green',
                                locationA: state.selectedPickUpPoint['name'],
                                locationB: trips[i]['route']
                                    ['destination_name'],
                                locationD: state.selectedPickUpPoint['name'],
                                locationC: trips[i]['route']
                                    ['destination_name'],
                                differenceAB:
                                    "${state.selectedPickUpPoint['time_to_dest'] ~/ 60}h ${state.selectedPickUpPoint['time_to_dest'] % 60}m",
                                differenceCD:
                                    "${state.selectedPickUpPoint['time_to_dest'] ~/ 60}h ${state.selectedPickUpPoint['time_to_dest'] % 60}m",
                                name: "${trips[i]['trip_group_name']}",
                                price: Utils.currencyFormat.format(
                                    state.selectedPickUpPoint['price'] * 10),
                                timeA: Utils.formatterTime.format(
                                    DateTime.parse(trips[i]['start_date'] +
                                        " " +
                                        trips[i]['departure_time'])),
                                timeB: Utils.formatterTime.format(
                                    DateTime.parse(trips[i]['start_date'] +
                                            " " +
                                            trips[i]['departure_time'])
                                        .add(Duration(
                                            minutes: state.selectedPickUpPoint[
                                                'time_to_dest']))),
                                timeC: Utils.formatterTime.format(
                                    DateTime.parse(trips[i]['start_date'] +
                                        " " +
                                        trips[i]['return_time'])),
                                timeD: Utils.formatterTime.format(
                                    DateTime.parse(trips[i]['start_date'] +
                                            " " +
                                            trips[i]['return_time'])
                                        .add(Duration(
                                            minutes: state.selectedPickUpPoint[
                                                'time_to_dest']))),
                                week: "${Utils.formatterDate.format(DateTime.parse(trips[i]['start_date'])) ?? "-"}" +
                                    " - " +
                                    "${Utils.formatterDateWithYear.format(DateTime.parse(trips[i]['end_date'])) ?? "-"}",
                                distance: '1',
                                data: trips[i],
                                onBook: onBook,
                                isActive: isSubscribe,
                              );
                            })
                        : Container(
                            height: screenSize.height / 1.8,
                            width: double.infinity,
                            child: NoResultSearchAjk())
                  ]),
                  // ),
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
        });
  }
}
