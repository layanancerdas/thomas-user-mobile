import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/custom_tab_indicator.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/screens/lifecycle_manager/lifecycle_manager.dart';
import 'package:tomas/screens/my_trips/widgets/list_section.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';
import './my_trips_view_model.dart';
import 'widgets/active_section.dart';
import 'widgets/canceled_section.dart';
import 'widgets/completed_section.dart';
import 'widgets/pending_section.dart';

class MyTripsView extends MyTripsViewModel {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: index,
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: CustomText(
                "${AppTranslations.of(context).text("my_trips")}",
                color: ColorsCustom.black,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
              bottom: TabBar(
                unselectedLabelColor: ColorsCustom.generalText,
                labelColor: ColorsCustom.primary,
                labelPadding: EdgeInsets.all(0),
                unselectedLabelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ColorsCustom.primary,
                    fontFamily: "Poppins"),
                labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorsCustom.primary,
                    fontFamily: "Poppins"),
                indicator: CustomTabIndicator(
                    color: ColorsCustom.primary,
                    radius: 10,
                    width: 16,
                    height: 3),
                tabs: [
                  // Tab(
                  //   // text: "${AppTranslations.of(context).text("pending")}",
                  //   text: "List",
                  // ),
                  Tab(text: "${AppTranslations.of(context).text("active")}"),
                  Tab(
                    text: "${AppTranslations.of(context).text("completed")}",
                  ),
                  Tab(text: "${AppTranslations.of(context).text("canceled")}"),
                ],
              ),
            ),
            body: Stack(
              children: [
                TabBarView(
                  children: [
                    // ListSection(),
                    // PendingSection(),
                    ActiveSection(),
                    CompletedSection(),
                    CanceledSection()
                  ],
                ),
                StoreConnector<AppState, GeneralState>(
                    converter: (store) => store.state.generalState,
                    builder: (context, stateGeneral) {
                      return stateGeneral.isLoading
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
                          : SizedBox();
                    })
              ],
            )));
  }
}
