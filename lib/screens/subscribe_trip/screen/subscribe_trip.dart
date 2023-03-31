import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:redux/redux.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/custom_tab_indicator.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/ajk_state.dart';
import 'package:tomas/screens/subscribe_trip/controller/subcribe_trip_controller.dart';
import 'package:tomas/widgets/card_list.dart';
import 'package:tomas/widgets/card_list_subscribe_trip.dart';
import 'package:tomas/widgets/card_schedule.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/no_result_subscribe.dart';

class SubscribeTrip extends StatefulWidget {
  @override
  final String idRoute, pickupPointId;
  const SubscribeTrip({Key key, this.idRoute, this.pickupPointId})
      : super(key: key);
  @override
  State<SubscribeTrip> createState() => _SubscribeTripState();
}

class _SubscribeTripState extends State<SubscribeTrip> {
  Store<AppState> store;
  var controller = Get.put(SubscribeTripController());

  @override
  void initState() {
    // TODO: implement initState
    controller.getSubscribeByRoutesId(widget.idRoute, widget.pickupPointId);
    super.initState();
  }

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
                title: CustomText(
                  "Subscribe Trip",
                  color: ColorsCustom.black,
                ),
              ),
              body: Container(
                  color: Colors.white,
                  child: Obx(() => controller.isLoading.value
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
                      : controller.dataSubscribe.length == 0
                          ? Container(
                              height: screenSize.height / 1.3,
                              width: double.infinity,
                              child: NoResultSubscribe())
                          : ListView.builder(
                              padding: EdgeInsets.all(12),
                              itemCount: controller.dataSubscribe.length,
                              itemBuilder: (context, index) =>
                                  CardListSubscribeTrip(
                                    id: controller.dataSubscribe[index]['id'],
                                    addressA:
                                        state.selectedPickUpPoint['address'],
                                    addressB: controller.dataSubscribe[index]
                                        ['routes']['destination_address'],
                                    differenceAB:
                                        "${controller.dataSubscribe[index]['routes']['pickup_points'][0]['time_to_dest'] ~/ 60}h ${controller.dataSubscribe[index]['routes']['pickup_points'][0]['time_to_dest'] % 60}m",
                                    month: (controller.dataSubscribe[index]
                                                ['duration'] /
                                            30)
                                        .toStringAsFixed(0),
                                    name: controller.dataSubscribe[index]
                                        ['name'],
                                    pointA: state.selectedPickUpPoint['name'],
                                    pointB: controller.dataSubscribe[index]
                                        ['routes']['destination_name'],
                                    amount: controller.dataSubscribe[index]
                                        ['amount'],
                                  )))));
        });
  }
}
