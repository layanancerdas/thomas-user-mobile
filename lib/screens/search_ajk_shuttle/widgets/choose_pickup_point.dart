import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:redux/redux.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/redux/actions/ajk_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/ajk_state.dart';
import 'package:tomas/screens/subscribe_trip/screen/subscribe_trip.dart';
import 'package:tomas/widgets/alert_permit.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class ChoosePickupPoint extends StatefulWidget {
  @override
  _ChoosePickupPointState createState() => _ChoosePickupPointState();
}

class _ChoosePickupPointState extends State<ChoosePickupPoint> {
  Store<AppState> store;

  Map selectedPickUpPoints = {};

  void selectPickUpPoint(Map value) {
    setState(() {
      selectedPickUpPoints = value;
    });
  }

  void onNext() {
    store.dispatch(
        SetSelectedPickUpPoint(selectedPickUpPoint: selectedPickUpPoints));
    Navigator.pushNamed(context, '/RoundTrip');
    // Get.to(SubscribeTrip());
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
    return Scaffold(
        appBar: AppBar(
          leading: TextButton(
            style: TextButton.styleFrom(),
            onPressed: () => Navigator.pop(context),
            child: SvgPicture.asset(
              'assets/images/back_icon.svg',
            ),
          ),
          centerTitle: true,
          title: CustomText(
            "Select Pick Up Point",
            color: ColorsCustom.black,
          ),
        ),
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  AlertPermit(),
                  Expanded(
                      child: StoreConnector<AppState, AjkState>(
                          converter: (store) => store.state.ajkState,
                          builder: (context, state) {
                            return ListView.builder(
                                itemCount:
                                    state.selectedRoute['pickup_points'].length,
                                itemBuilder: (BuildContext ctx, int i) {
                                  return selectorPoint(context,
                                      state.selectedRoute['pickup_points'][i]);
                                });
                          }))
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom == 0 ? 30 : 10,
              left: 0,
              right: 0,
              child: CustomButton(
                text: "${AppTranslations.of(context).text("next")}",
                textColor: Colors.white,
                bgColor: selectedPickUpPoints.containsKey('pickup_point_id')
                    ? ColorsCustom.primary
                    : ColorsCustom.disable,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                padding: EdgeInsets.symmetric(vertical: 14),
                onPressed: () =>
                    selectedPickUpPoints.containsKey('pickup_point_id')
                        ? onNext()
                        : {},
              ),
            ),
          ],
        ));
  }

  Widget selectorPoint(BuildContext context, Map data) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: ColorsCustom.border))),
      child: TextButton(
        style: TextButton.styleFrom(
          // color: Colors.white,
          padding: EdgeInsets.all(16),
        ),
        onPressed: () => selectPickUpPoint(data),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              "${data['name']}",
              color: ColorsCustom.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            Container(
              width: 24,
              height: 24,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1, color: ColorsCustom.primary)),
              child: selectedPickUpPoints['pickup_point_id'] ==
                      data['pickup_point_id']
                  ? Container(
                      decoration: BoxDecoration(
                        color: ColorsCustom.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    )
                  : SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
