import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/modal_detail_balance.dart';
import './profile.dart';
import 'package:tomas/localization/app_translations.dart';

abstract class ProfileViewModel extends State<Profile> {
  String version = '1.0.0';

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('jwtToken');
    Navigator.pushNamedAndRemoveUntil(context, '/Landing', (route) => false);
  }

  Future<bool> onDialogLogout() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: CustomText(
            AppTranslations.of(context).currentLanguage == 'id'
                ? "Konfirmasi"
                : 'Confirmation',
            color: ColorsCustom.black,
          ),
          content: CustomText(
            AppTranslations.of(context).currentLanguage == 'id'
                ? "Apakah Anda yakin ingin keluar dari aplikasi ini?"
                : 'Are you sure you want to log out this application?',
            color: ColorsCustom.generalText,
          ),
          actions: <Widget>[
            Container(
              height: 45,
              child: TextButton(
                style: TextButton.styleFrom(),
                //materialTapTargetSize: //materialTapTargetSize.shrinkWrap,
                onPressed: () {
                  logout();
                },
                child: CustomText(
                  AppTranslations.of(context).currentLanguage == 'id'
                      ? "Ya"
                      : 'Yes',
                  color: ColorsCustom.blueSystem,
                ),
              ),
            ),
            Container(
              height: 45,
              child: TextButton(
                style: TextButton.styleFrom(),
                //materialTapTargetSize: //materialTapTargetSize.shrinkWrap,
                onPressed: () => Navigator.pop(context),
                child: CustomText(
                  AppTranslations.of(context).currentLanguage == 'id'
                      ? "Tidak"
                      : 'No',
                  color: ColorsCustom.blueSystem,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
    return false;
  }

  void onPersonalInformationClick() {
    Navigator.pushNamed(context, "/ProfileEdit");
  }

  void onDetailBalance() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ModalDetailBalance();
        });
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    getVersion();
  }
}
