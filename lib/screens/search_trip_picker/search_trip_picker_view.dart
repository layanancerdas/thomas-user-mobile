import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/custom_mapbox_picker.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/widgets/custom_button.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'search_trip_picker_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class SearchTripPickerView extends SearchTripPickerViewModel {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: StoreConnector<AppState, GeneralState>(
            converter: (store) => store.state.generalState,
            builder: (context, state) {
              return Stack(
                children: [
                  Container(height: double.infinity),
                  Container(
                    height: (screenSize.height / 4) * 3,
                    width: double.infinity,
                    child: getLocationWithMapBox(),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 16,
                            child: GestureDetector(
                              onTap: () => getCurrentLocation(),
                              child: Container(
                                width: 36,
                                height: 36,
                                padding: EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                          blurRadius: 24,
                                          color: ColorsCustom.black
                                              .withOpacity(0.15))
                                    ],
                                    borderRadius: BorderRadius.circular(20)),
                                child: SvgPicture.asset(
                                    "assets/images/current_location.svg"),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                                minHeight: screenSize.height / 4),
                            margin: EdgeInsets.only(top: 52),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                      blurRadius: 24,
                                      color:
                                          ColorsCustom.black.withOpacity(0.08))
                                ],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomText(
                                        "${AppTranslations.of(context).text("set")} ${widget.mode == 'destination' ? Utils.inCaps(AppTranslations.of(context).text("destination")) : AppTranslations.of(context).text("no_location_found")}",
                                        color: ColorsCustom.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3.0),
                                            child: Icon(
                                              Icons.location_on,
                                              color: ColorsCustom.primaryBlue,
                                              size: 24,
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Flexible(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                "${widget.mode == 'destination' ? state.searchDestination['name'] : state.searchOrigin['name']}",
                                                fontWeight: FontWeight.w600,
                                                color: ColorsCustom.black,
                                                fontSize: 16,
                                              ),
                                              SizedBox(height: 4),
                                              CustomText(
                                                "${widget.mode == 'destination' ? state.searchDestination['address'] : state.searchOrigin['name']}",
                                                fontWeight: FontWeight.w400,
                                                color: ColorsCustom.black,
                                                fontSize: 14,
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                      SizedBox(height: 24),
                                    ],
                                  ),
                                ),
                                CustomButton(
                                  text:
                                      "${AppTranslations.of(context).text("next")}",
                                  textColor: Colors.white,
                                  bgColor: ColorsCustom.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  onPressed: () => onNext(),
                                ),
                                SizedBox(height: 17),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Positioned(
                    left: 16,
                    top: 40,
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          // color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          'assets/images/back_icon.svg',
                        ),
                      ),
                    ),
                  )
                ],
              );
            }));
  }

  Widget getLocationWithMapBox() {
    return StoreConnector<AppState, GeneralState>(
        converter: (store) => store.state.generalState,
        builder: (context, state) {
          return CustomMapBoxLocationPicker(
            popOnSelect: true,
            apiKey: ACCESS_TOKEN,
            limit: 1,
            language: 'id',
            customMarkerIcon: SvgPicture.asset(
              "assets/images/custom_marker.svg",
            ),
            customMapLayer: TileLayer(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/arsyadsr09/ckp949xg35dkw18oja7eiflza/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYXJzeWFkc3IwOSIsImEiOiJja29lbmUwcnEwYnZyMnBzM3dmcTJwaTd5In0.d5zvI-xGN_J_gXv3YkTTfw",
              additionalOptions: {
                'accessToken': ACCESS_TOKEN,
                'id': 'mapbox.mapbox-streets-v8',
              },
            ),
            showCurrent: showCurrent,
            toggleShowCurrent: toggleShowCurrent,
            initLocation: widget.mode == 'destination'
                ? state.searchDestination['latLng']
                : state.searchOrigin['latLng'],
            // onSelected: (place) {
            //   setState(() {
            //     // _pickedLocationText = place.geometry
            //     //     .coordinates; // Example of how to call the coordinates after using the Mapbox Location Picker
            //     print(place.geometry.coordinates);
            //   });
            // },
            onChangeMarker: onChangeMarker,
            context: context,
          );
        });
  }
}
