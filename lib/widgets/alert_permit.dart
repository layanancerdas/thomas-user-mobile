import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/localization/app_translations.dart';

class AlertPermit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserState>(
        converter: (store) => store.state.userState,
        builder: (context, stateUser) {
          return !stateUser.userDetail['permitted_ajk']
              ? GestureDetector(
                  onTap: () =>
                      Utils.permitCheckAndRequest(context, mode: 'picking'),
                  child: Container(
                    color: ColorsCustom.primaryVeryLow,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: SvgPicture.asset(
                            'assets/images/warning.svg',
                            height: 16,
                            width: 16,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: new TextSpan(
                                text:
                                    "${AppTranslations.of(context).text("cant_book")}",
                                style: TextStyle(
                                    color: ColorsCustom.black,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                    fontFamily: 'Poppins'),
                                children: <TextSpan>[
                                  new TextSpan(
                                      text:
                                          "${AppTranslations.of(context).text("here")} .",
                                      style: TextStyle(
                                        color: ColorsCustom.primary,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ))
              : SizedBox();
        });
  }
}
