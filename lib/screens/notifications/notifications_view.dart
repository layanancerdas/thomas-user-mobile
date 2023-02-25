import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/general_state.dart';
import 'package:tomas/screens/lifecycle_manager/lifecycle_manager.dart';
import 'package:tomas/screens/notifications/widgets/notif_list.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/no_notifications.dart';
import './notifications_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class NotificationsView extends NotificationsViewModel {
  @override
  Widget build(BuildContext context) {
    // Replace this with your build function
    return StoreConnector<AppState, GeneralState>(
        converter: (store) => store.state.generalState,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: CustomText(
                "${AppTranslations.of(context).text("notification")}",
                color: ColorsCustom.black,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
              actions: state.notifications.length > 0
                  ? [
                      Center(
                        child: SizedBox(
                          height: 32,
                          width: 32,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                // color: ColorsCustom.softGrey,
                                // highlightColor: Colors.black12,
                              ),
                              onPressed: () => toggleMoreMode(),
                              child: state.disableNavbar
                                  ? SvgPicture.asset(
                                      'assets/images/close_grey.svg')
                                  : SvgPicture.asset(
                                      'assets/images/more_grey.svg')),
                        ),
                      ),
                      SizedBox(width: 16),
                    ]
                  : [],
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: state.notifications.length > 0
                          ? ListView(
                              shrinkWrap: true,
                              children: [
                                ListView.builder(
                                  itemCount: state.notifications.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    // if (state.notifications[index]
                                    //     ['is_active']) {
                                    return NotifList(
                                      data: state.notifications[index],
                                      listSelected: selected,
                                      onSelected: onSelect,
                                      onUpdate: onUpdate,
                                    );
                                    // } else {
                                    //   return SizedBox();
                                    // }
                                  },
                                ),
                                disableShow || state.notifications.length <= 10
                                    ? SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 24, horizontal: 16),
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 14),
                                            // borderSide: BorderSide(
                                            //     color: ColorsCustom.primary,
                                            //     width: 1),
                                          ),
                                          onPressed: () => onShowMore(),
                                          child: CustomText(
                                            "Show More",
                                            color: ColorsCustom.primary,
                                          ),
                                        ),
                                      )
                              ],
                            )
                          : NoNotifications(),
                    ),
                    AnimatedContainer(
                      duration: !state.disableNavbar
                          ? Duration(milliseconds: 200)
                          : Duration(milliseconds: 500),
                      height: state.disableNavbar ? 100 : 0,
                      padding: EdgeInsets.only(bottom: 30),
                      width: double.infinity,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 24,
                            spreadRadius: 0,
                            color: Colors.black.withOpacity(0.08))
                      ]),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () => onSelectAll(),
                            child: CustomText(
                              "${AppTranslations.of(context).text("select_all")}",
                              color: ColorsCustom.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                          Expanded(
                              child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () => onUpdate('read'),
                            child: CustomText(
                              "${AppTranslations.of(context).text("mark_as_read")}",
                              color: ColorsCustom.disable,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                          Expanded(
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () => onUpdate('delete'),
                                child: CustomText(
                                  "${AppTranslations.of(context).text("delete")}",
                                  color: ColorsCustom.disable,
                                  fontWeight: FontWeight.w500,
                                )),
                          )
                        ],
                      ),
                    )
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
            ),
          );
        });
  }
}
