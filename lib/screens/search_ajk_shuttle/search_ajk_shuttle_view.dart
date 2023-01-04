import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/ajk_state.dart';
import 'package:tomas/widgets/alert_permit.dart';
import 'package:tomas/widgets/no_result_search_ajk.dart';
import 'package:tomas/screens/search_ajk_shuttle/widgets/result_ajk_shuttle.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/search_trip.dart';
import './search_ajk_shuttle_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class SearchAjkShuttleView extends SearchAjkShuttleViewModel {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
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
                "${AppTranslations.of(context).text("choose_ajk_route")}",
                color: ColorsCustom.black,
              ),
            ),
            body: Stack(
              children: [
                StoreConnector<AppState, AjkState>(
                    converter: (store) => store.state.ajkState,
                    builder: (context, state) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          children: [
                            AlertPermit(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: SearchTrip(
                                hint:
                                    "${AppTranslations.of(context).text("search_route")}",
                                borderColor: ColorsCustom.softGrey,
                                iconColor: ColorsCustom.softGrey,
                                controller: searchController,
                                onChange: onSearchRoute,
                                onClear: onClear,
                                showDelete: searchController.text.isNotEmpty,
                              ),
                            ),
                            Expanded(
                              child: state.routes.length > 0
                                  ? searchController.text.length > 0 &&
                                          routes.length == 0
                                      ? NoResultSearchAjk()
                                      : ListView.builder(
                                          padding: EdgeInsets.only(
                                              bottom: 20, left: 16, right: 16),
                                          itemCount:
                                              searchController.text.length > 0
                                                  ? routes.length
                                                  : state.routes.length,
                                          shrinkWrap: true,
                                          itemBuilder: (ctx, i) {
                                            if (searchController.text.length >
                                                0) {
                                              return ResultAjkShuttle(
                                                data: routes[i],
                                                onClick: onClickResult,
                                              );
                                            } else {
                                              return ResultAjkShuttle(
                                                data: state.routes[i],
                                                onClick: onClickResult,
                                              );
                                            }
                                          })
                                  : NoResultSearchAjk(),
                            )
                          ],
                        ),
                      );
                    }),
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
            )));
  }
}
