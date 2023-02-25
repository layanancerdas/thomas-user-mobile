import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/custom_nomatim_service.dart';
import 'package:tomas/screens/search_trip/widgets/result_search.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/search_trip.dart';
import './search_trip_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class SearchTripView extends SearchTripViewModel {
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
              // elevation: 3,
              title: CustomText(
                "${widget.mode == 'origin' ? '${AppTranslations.of(context).text("set_up_pickup_point")}' : "${AppTranslations.of(context).text("where_are_you_going")}?"}",
                color: ColorsCustom.black,
              ),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  SizedBox(height: 10),
                  SearchTrip(
                    hint:
                        "${AppTranslations.of(context).text("search_for")} ${widget.mode == 'origin' ? '${AppTranslations.of(context).text("origin")}' : '${AppTranslations.of(context).text("destination")}'}",
                    borderColor: ColorsCustom.softGrey,
                    iconColor: ColorsCustom.softGrey,
                    controller: searchController,
                    onChange: onSearchRoute,
                    onClear: onClear,
                    showDelete: searchController.text.isNotEmpty,
                    prefix: SizedBox(
                      height: 16,
                      width: 16,
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/images/location_blue.svg",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: predictions.features.length > 0
                        ? ListView.builder(
                            padding: EdgeInsets.only(bottom: 40),
                            shrinkWrap: true,
                            itemCount: predictions.features.length,
                            itemBuilder: (BuildContext ctx, int i) {
                              return ResultSearch(
                                data: {
                                  "name": predictions.features[i].text ?? '-',
                                  "address": predictions.features[i].placeName,
                                  "latLng": Location(
                                      lat: predictions.features[i].center[1],
                                      lng: predictions.features[i].center[0])
                                },
                                onPress: onPressResult,
                              );
                            },
                          )
                        : error
                            ? Container(
                                margin: EdgeInsets.only(top: 16),
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/keyword_not_found.svg",
                                      width: 48,
                                      height: 48,
                                    ),
                                    SizedBox(width: 16),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomText(
                                            "${AppTranslations.of(context).text("no_location_found")}",
                                            color: ColorsCustom.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                          SizedBox(height: 4),
                                          CustomText(
                                            "${AppTranslations.of(context).text("change_location")}",
                                            color: ColorsCustom.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(),
                  )
                ]))));
  }
}
