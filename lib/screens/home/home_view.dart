import 'dart:convert';
import 'dart:io';
import 'package:tomas/localization/app_translations.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/screens/home/widgets/upcoming_trip.dart';
import 'package:tomas/screens/lifecycle_manager/lifecycle_manager.dart';
import 'package:tomas/screens/my_trips/my_trips.dart';
import 'package:tomas/widgets/custom_text.dart';
import './home_view_model.dart';
import 'widgets/button_menu.dart';
import 'widgets/voucher_popup.dart';

class HomeView extends HomeViewModel {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    return StoreConnector<AppState, GeneralState>(
        converter: (store) => store.state.generalState,
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: widget.tab != null
                ? MyTrips(index: widget.tab)
                : children[currentIndex]['name'] == 'Home'
                    ? getScaffold(context)
                    : children[currentIndex]['page'],
            bottomNavigationBar: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: state.disableNavbar ? 0 : 90,
                child:
                    // state.disableNavbar
                    //     ?
                    new BottomNavigationBar(
                  onTap: onTabTapped,
                  currentIndex: currentIndex,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: ColorsCustom.black,
                  backgroundColor: Colors.white,
                  elevation: 10,
                  unselectedFontSize: 11,
                  selectedFontSize: 11,
                  showUnselectedLabels: true,
                  unselectedItemColor: ColorsCustom.disable,
                  items: [
                    BottomNavigationBarItem(
                      // backgroundColor: Colors.white,
                      icon: currentIndex == 0
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: SvgPicture.asset(
                                  "assets/images/home_filled.svg"),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: SvgPicture.asset(
                                  "assets/images/home_outline.svg"),
                            ),
                      label: AppTranslations.of(context).currentLanguage == 'id'
                          ? '${HomeViewModel.bottomNavIn[0]['name']}'
                          : '${HomeViewModel.bottomNavEn[0]['name']}',
                    ),
                    BottomNavigationBarItem(
                      // backgroundColor: Colors.white,
                      icon: currentIndex == 1
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: SvgPicture.asset(
                                  "assets/images/bag_filled.svg"),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: SvgPicture.asset(
                                  "assets/images/bag_outline.svg"),
                            ),
                      label: AppTranslations.of(context).currentLanguage == 'id'
                          ? '${HomeViewModel.bottomNavIn[1]['name']}'
                          : '${HomeViewModel.bottomNavEn[1]['name']}',
                    ),
                    BottomNavigationBarItem(
                      // backgroundColor: Colors.white,
                      icon: currentIndex == 2
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: !isHaveNewNotif
                                  ? SvgPicture.asset(
                                      "assets/images/notifications_filled.svg")
                                  : SvgPicture.asset(
                                      "assets/images/new_notification_filled.svg"),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: !isHaveNewNotif
                                  ? SvgPicture.asset(
                                      "assets/images/notifications_outline.svg")
                                  : SvgPicture.asset(
                                      "assets/images/new_notification_outline.svg"),
                            ),
                      label: AppTranslations.of(context).currentLanguage == 'id'
                          ? '${HomeViewModel.bottomNavIn[2]['name']}'
                          : '${HomeViewModel.bottomNavEn[2]['name']}',
                    ),
                    BottomNavigationBarItem(
                      // backgroundColor: Colors.white,
                      icon: currentIndex == 3
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: SvgPicture.asset(
                                  "assets/images/user_filled.svg"),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: SvgPicture.asset(
                                  "assets/images/user_outline.svg"),
                            ),
                      label: AppTranslations.of(context).currentLanguage == 'id'
                          ? '${HomeViewModel.bottomNavIn[3]['name']}'
                          : '${HomeViewModel.bottomNavEn[3]['name']}',
                    ),
                  ],
                )
                // : SizedBox(),
                ),
          );
        });
  }

  Widget getScaffold(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: StoreConnector<AppState, UserState>(
            converter: (store) => store.state.userState,
            builder: (context, state) {
              return StoreConnector<AppState, GeneralState>(
                  converter: (store) => store.state.generalState,
                  builder: (context, stateGeneral) {
                    return Stack(
                      children: [
                        Container(
                            height: double.infinity, width: double.infinity),
                        Container(
                          width: screenSize.width,
                          height: screenSize.height / 3.2,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/bg_home_day.jpeg'),
                                  fit: BoxFit.cover)),
                          child: SafeArea(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/logo-tomaas-white.svg",
                                              height: 20,
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  CustomText(
                                                    "${placemark.length <= 0 ? "Loading..." : Platform.isIOS ? placemark[0].locality : placemark[0].subAdministrativeArea}",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Icon(Icons.location_on,
                                                      size: 14,
                                                      color: Colors.white),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        CustomText(
                                          "${AppTranslations.of(context).text("hi")}, ${state.userDetail['name']}!",
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ],
                                    ),
                                  ),
                                  //search prodduct home
                                  // Padding(
                                  //   padding: const EdgeInsets.only(bottom: 35),
                                  //   child: TextButton(
                                  //       style: TextButton.styleFrom(
                                  //         backgroundColor: Colors.white,
                                  //         shape: RoundedRectangleBorder(
                                  //           borderRadius:
                                  //               BorderRadius.circular(20),
                                  //         ),
                                  //         padding: EdgeInsets.symmetric(
                                  //             horizontal: 16, vertical: 10),
                                  //         //     highlightColor:
                                  //         //     Colors.black.withOpacity(0.01),
                                  //         // color: Colors.white,
                                  //       ),
                                  //       onPressed: () => Navigator.pushNamed(
                                  //           context, '/SearchTrip'),
                                  //       child: Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.spaceBetween,
                                  //         children: [
                                  //           CustomText(
                                  //             "${AppTranslations.of(context).text("where_are_you_going")}?",
                                  //             fontSize: 14,
                                  //             color: Color(0xFFA1A4A8),
                                  //             fontWeight: FontWeight.w400,
                                  //           ),
                                  //           SizedBox(
                                  //             height: 16,
                                  //             width: 16,
                                  //             child: Center(
                                  //               child: SvgPicture.asset(
                                  //                 "assets/images/search.svg",
                                  //               ),
                                  //             ),
                                  //           )
                                  //         ],
                                  //       )),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: screenSize.height / 3.5,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                                padding: EdgeInsets.only(top: 24),
                                decoration: BoxDecoration(
                                    color: Color(0xFFFAFAFA),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25))),
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    await initData();
                                    return Future<void>.delayed(
                                        const Duration(seconds: 0));
                                  },
                                  child: ListView(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          UpcomingTrip(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  "${AppTranslations.of(context).text("travel_by")}",
                                                  color: ColorsCustom.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                SizedBox(height: 16),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: ButtonMenu(
                                                      logo: 'school_bus.svg',
                                                      name: "ESS",
                                                      color: ColorsCustom
                                                          .primaryVeryLow,
                                                      onClick: () => !state
                                                                  .userDetail[
                                                              'permitted_ajk']
                                                          ? Utils
                                                              .permitCheckAndRequest(
                                                                  context,
                                                                  mode: 'home')
                                                          : Navigator.pushNamed(
                                                              context,
                                                              '/SearchAjkShuttle'),
                                                    )),
                                                    Expanded(
                                                      child: ButtonMenu(
                                                        logo: 'rental.svg',
                                                        name: "Rental",
                                                        color: ColorsCustom
                                                            .primaryGreenVeryLow,
                                                        onClick: () =>
                                                            showDialogComingSoon(),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ButtonMenu(
                                                        logo: 'nebeng.svg',
                                                        name: "Nebeng",
                                                        color: ColorsCustom
                                                            .primaryOrangeVeryLow,
                                                        onClick: () =>
                                                            showDialogComingSoon(),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ButtonMenu(
                                                        logo:
                                                            'electric_train.svg',
                                                        name: "Multimoda",
                                                        color: ColorsCustom
                                                            .primaryBlueVeryLow,
                                                        onClick: () =>
                                                            showDialogComingSoon(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          state.activeTrip.length <= 0 &&
                                                  stateGeneral.vouchers.length >
                                                      0
                                              ? Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 24),
                                                  child: VoucherPopUp())
                                              : SizedBox()
                                        ],
                                      ),
                                      SizedBox(height: 40),
                                    ],
                                  ),
                                ))),
                        // Positioned(
                        //     top: screenSize.height / 3.5 + 24,
                        //     left: 0,
                        //     right: 0,
                        //     child: Container(
                        //       height: 40,
                        //       decoration: const BoxDecoration(
                        //         gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           end: Alignment
                        //               .bottomCenter, // 10% of the width, so there are ten blinds.
                        //           colors: <Color>[
                        //             Colors.white,
                        //             Colors.white24
                        //           ], // red to yellow
                        //         ),
                        //       ),
                        //     )),
                        // StoreConnector<AppState, GeneralState>(
                        //     converter: (store) => store.state.generalState,
                        //     builder: (context, stateGeneral) {
                        //       return stateGeneral.vouchers.length > 0
                        //           ?
                        state.activeTrip.length > 0 &&
                                stateGeneral.vouchers.length > 0
                            ? Positioned(
                                bottom: 40,
                                right: 0,
                                left: 0,
                                child: VoucherPopUp())
                            : SizedBox(),
                        // : SizedBox();
                        // }),
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
                                          indicator:
                                              BallSpinFadeLoaderIndicator(),
                                        ),
                                      ),
                                    )
                                  : SizedBox();
                            })
                      ],
                    );
                  });
            }));
  }
}
