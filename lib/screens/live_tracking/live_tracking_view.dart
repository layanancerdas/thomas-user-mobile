import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';
import './live_tracking_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class LiveTrackingView extends LiveTrackingViewModel {
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
          "${status ?? "-"}",
          // routeBuilt && !isNavigating ? "Clear Route" : "Build Route",
          color: ColorsCustom.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: StoreConnector<AppState, UserState>(
          converter: (store) => store.state.userState,
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage("assets/images/map-dummy.jpeg"),
                  //         fit: BoxFit.cover)),
                  // child: GoogleMap(
                  //   initialCameraPosition: initializePosition,
                  // )
                  // )
                  // MyApp())
                  // Image.network(getStaticImageWithPolyline()))
                  // child: MapBoxNavigationView(
                  //     options: options,
                  //     onRouteEvent: onEmbeddedRouteEvent,
                  //     onCreated:
                  //         (MapBoxNavigationViewController _controller) async {
                  //       controller = _controller;
                  //       _controller.initialize();
                  //       onCreated();
                  //     }),
                ),
                Positioned(
                    bottom: 30,
                    left: 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 24,
                                offset: Offset(0, 4),
                                color: Colors.black12)
                          ]),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 16),
                            child: Row(
                              children: [
                                SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: state.selectedMyTrip['details']
                                                ['driver']['photo'] !=
                                            null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                '${BASE_API + "/files/" + state.selectedMyTrip['details']['driver']['photo']}'),
                                          )
                                        : CircleAvatar(
                                            backgroundImage: AssetImage(
                                            'assets/images/placeholder_user.png',
                                          ))),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          "${AppTranslations.of(context).text("driver")}",
                                          color: ColorsCustom.generalText,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                        CustomText(
                                          "${subStatus ?? "-"}",
                                          color: ColorsCustom.generalText,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // CustomText(
                                        //   "${state.selectedMyTrip['details']['driver']['name'] ?? "-"}",
                                        //   color: ColorsCustom.generalText,
                                        //   fontWeight: FontWeight.w500,
                                        //   fontSize: 14,
                                        // ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomText(
                                              "ETA ",
                                              color: ColorsCustom.generalText,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                            CustomText(
                                              "15 mins",
                                              color: ColorsCustom.generalText,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey, height: 1),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      "${state.selectedMyTrip['details']['bus']['brand'] ?? "-"}",
                                      color: ColorsCustom.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                    SizedBox(height: 4),
                                    CustomText(
                                      "${state.selectedMyTrip['details']['bus']['license_plate'] ?? "-"}",
                                      color: ColorsCustom.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ],
                                )),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 18),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    // borderSide:
                                    //     BorderSide(color: ColorsCustom.primary),
                                  ),
                                  onPressed: () => onViewETicket(),
                                  child: CustomText(
                                    "${AppTranslations.of(context).text("view_e_ticket")}",
                                    color: ColorsCustom.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(width: 12),
                                SizedBox(
                                  height: 36,
                                  width: 36,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      padding: EdgeInsets.zero,
                                      // color: ColorsCustom.primary,
                                    ),
                                    onPressed: () {
                                      launch(
                                          "tel://${state.selectedMyTrip['details']['driver']['phone_number'] ?? "0"}");
                                    },
                                    child: SvgPicture.asset(
                                        "assets/images/call.svg"),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            );
          }),
    );
  }
}
