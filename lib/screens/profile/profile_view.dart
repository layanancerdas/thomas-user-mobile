import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/profile/widgets/ajk_request_time.dart';
import 'package:tomas/screens/profile/widgets/profile_menu.dart';
import 'package:tomas/widgets/custom_text.dart';
import './profile_view_model.dart';
import 'package:tomas/localization/app_translations.dart';

class ProfileView extends ProfileViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (context, state) {
                  return Container(
                    margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/ProfileEdit");
                              },
                              child: Container(
                                  margin: EdgeInsets.only(right: 16),
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: ColorsCustom.disable),
                                  child: state.userState.userDetail['photo'] !=
                                          null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Image.network(
                                            "$BASE_API/files/${state.userState.userDetail['photo']}",
                                            fit: BoxFit.cover,
                                            height: 60,
                                            width: 60,
                                            // errorBuilder: (context, error,
                                            //         stackTrace) =>
                                            //     SvgPicture.asset(
                                            //         "assets/images/placeholder_user.svg"),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: SvgPicture.asset(
                                            'assets/images/placeholder_user.svg',
                                            fit: BoxFit.cover,
                                            height: 60,
                                            width: 60,
                                          ))),
                            ),
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        "${state.userState.userDetail.containsKey('name') ? state.userState.userDetail['name'] : "-"}",
                                        fontWeight: FontWeight.w600,
                                        color: ColorsCustom.black,
                                        fontSize: 20,
                                      ),
                                      SizedBox(height: 5),
                                      CustomText(
                                        "${state.userState.userDetail.containsKey('division') ? state.userState.userDetail['division']['division_name'] : "-"}",
                                        color: ColorsCustom.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16,
                                      ),
                                      SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () => onDetailBalance(),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/money.svg',
                                              width: 24,
                                            ),
                                            SizedBox(width: 8),
                                            RichText(
                                              text: new TextSpan(
                                                text: 'Balance: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 14,
                                                    color: ColorsCustom.black,
                                                    fontFamily: 'Poppins'),
                                                children: <TextSpan>[
                                                  new TextSpan(
                                                      text: 'Rp' +
                                                          Utils.currencyFormat
                                                              .format(state
                                                                  .transactionState
                                                                  .balances),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                                  SizedBox(
                                    width: 45,
                                    height: 45,
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () => Navigator.pushNamed(
                                            context, '/ProfileEdit'),
                                        child: Icon(Icons.edit)),
                                  ),
                                  SizedBox(width: 16)
                                ],
                              ),
                            )
                          ],
                        ),
                        AjkRequestTime(),
                        ProfileMenu(
                          divider: true,
                          icon: "user_outline.svg",
                          text:
                              "${AppTranslations.of(context).text("personal_information")}",
                          onPress: onPersonalInformationClick,
                        ),
                        ProfileMenu(
                          divider: true,
                          icon: "user_outline.svg",
                          text: "My Subscription",
                          onPress: onPersonalInformationClick,
                        ),
                        ProfileMenu(
                          divider: true,
                          icon: 'call_outline.svg',
                          text:
                              "${AppTranslations.of(context).text("contact_us")}",
                          onPress: () =>
                              Navigator.pushNamed(context, '/ContactUs'),
                        ),
                        ProfileMenu(
                          divider: true,
                          icon: 'help.svg',
                          text: "FAQ",
                          onPress: () => Navigator.pushNamed(context, '/Faq'),
                        ),
                        ProfileMenu(
                          divider: true,
                          icon: 'language.svg',
                          text:
                              "${AppTranslations.of(context).text("language")}",
                          onPress: () =>
                              Navigator.pushNamed(context, '/Language'),
                        ),
                        ProfileMenu(
                          divider: true,
                          icon: 'logout.svg',
                          text: "${AppTranslations.of(context).text("logout")}",
                          onPress: onDialogLogout,
                        ),
                      ],
                    ),
                  );
                }),
          ),
          Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Center(
                child: CustomText(
                  "App version $version",
                  color: ColorsCustom.black,
                  fontSize: 12,
                ),
              ))
        ],
      ),
    );
  }
}
