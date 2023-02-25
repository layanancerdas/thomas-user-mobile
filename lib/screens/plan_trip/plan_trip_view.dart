import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/screens/plan_trip/widgets/card_plan_trip.dart';
import 'package:tomas/screens/search_trip/search_trip.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/no_plan_trip.dart';
import './plan_trip_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class PlanTripView extends PlanTripViewModel {
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
        title: CustomText(
          "${AppTranslations.of(context).text("plan_trip")}",
          color: ColorsCustom.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Container(
        color: ColorsCustom.border.withOpacity(0.32),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                        blurRadius: 24,
                        color: ColorsCustom.black.withOpacity(0.08))
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  )),
              child: Row(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: ColorsCustom.primary),
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 4),
                            child: SvgPicture.asset(
                              "assets/images/dotted-plan-trip.svg",
                              fit: BoxFit.fitHeight,
                            )),
                        SvgPicture.asset(
                          "assets/images/position.svg",
                          width: 16,
                          height: 16,
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  StoreConnector<AppState, GeneralState>(
                      converter: (store) => store.state.generalState,
                      builder: (context, state) {
                        return Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              constraints: BoxConstraints(minHeight: 50),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  padding: EdgeInsets.only(
                                      left: 5, bottom: 10, top: 10),
                                  // highlightColor:
                                  //     ColorsCustom.black.withOpacity(0.05),
                                ),
                                //materialTapTargetSize:
                                //materialTapTargetSize.shrinkWrap,

                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            SearchTrip(mode: "origin"))),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(
                                    "${state.searchOrigin['name'] ?? "-"}",
                                    color: ColorsCustom.black,
                                    fontWeight: state.searchOrigin['name'] ==
                                            'Your current location'
                                        ? FontWeight.w400
                                        : FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: ColorsCustom.border,
                            ),
                            Container(
                              width: double.infinity,
                              constraints: BoxConstraints(minHeight: 50),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  padding: EdgeInsets.only(
                                      left: 5, top: 10, bottom: 10),
                                  // highlightColor:
                                  //     ColorsCustom.black.withOpacity(0.05),
                                ),
                                //materialTapTargetSize:
                                //materialTapTargetSize.shrinkWrap,

                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            SearchTrip(mode: "destination"))),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(
                                    "${state.searchDestination.containsKey("name") ? state.searchDestination['name'] : "-"}",
                                    //  state.searchDestination['name'].length > 25 ? state.searchDestination['name'].substring(0, 24) + "..." :
                                    color: ColorsCustom.black,
                                    fontWeight:
                                        state.searchDestination['name'] ==
                                                'Your current location'
                                            ? FontWeight.w400
                                            : FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ));
                      }),
                  Center(
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () => onExhcange(),
                        child: SvgPicture.asset(
                          "assets/images/exchange-vertical.svg",
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: StoreConnector<AppState, GeneralState>(
                    converter: (store) => store.state.generalState,
                    builder: (context, state) {
                      return state.searchResult.length > 0
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, left: 16, right: 16),
                                    child: CustomText(
                                      "${AppTranslations.of(context).text("recommended_for_you")}",
                                      color: ColorsCustom.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    padding:
                                        EdgeInsets.fromLTRB(16, 16, 16, 40),
                                    shrinkWrap: true,
                                    itemCount: state.searchResult.length,
                                    itemBuilder: (BuildContext ctx, int i) {
                                      return CardPlanTrip(
                                        data: state.searchResult[i],
                                        onClick: onClick,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              width: double.infinity, child: NoPlanTrip());
                    }))
          ],
        ),
      ),
    );
  }
}
