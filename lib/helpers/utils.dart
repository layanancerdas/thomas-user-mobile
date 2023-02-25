import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/widgets/custom_dialog.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/error_page.dart';
import 'package:tomas/widgets/modal_no_internet.dart';

import 'colors_custom.dart';

class Utils {
  static DateFormat formatterTime = DateFormat('HH:mm');
  static DateFormat formatterDate = DateFormat('E, dd MMM');
  static DateFormat formatterDateMonth = DateFormat('dd MMM');
  static DateFormat formatterDateWithYear = DateFormat('E, dd MMM yyyy');
  static DateFormat formatterDateLong = DateFormat('E, dd MMMM, HH:mm a');
  static DateFormat formatterDateCompleted =
      DateFormat('E, dd MMMM yyyy, HH:mm a');
  static DateFormat formatterDateFirst = DateFormat('MMM, dd yyyy');
  static DateFormat formatterDateGeneral = DateFormat('dd MMM yyyy');
  static DateFormat formatterDateVertical = DateFormat('E,\ndd MMM');
  static NumberFormat currencyFormat = new NumberFormat("#,##0", "en_US");

  static String inCaps(String value) =>
      '${value[0].toUpperCase()}${value.substring(1)}';
  static String allInCaps(String value) => value.toUpperCase();
  static String capitalizeFirstofEach(String value) => value
      .split(" ")
      .map((str) => str[0].toUpperCase() + str.substring(1))
      .join(" ");

  static onErrorConnection(type, {BuildContext context}) {
    if (type == 'modal_connection') {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ModalNoInternet();
          });
    } else if (type == 'fullpage_connection') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ErrorPage(mode: "connection"),
              fullscreenDialog: true));
    } else if (type == 'fullpage_maintenance') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ErrorPage(mode: "maintenance"),
              fullscreenDialog: true));
    }
  }

  static onLowBalance({BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ModalNoInternet();
        });
  }

  static Future<void> permitCheckAndRequest(BuildContext context,
      {String mode}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("ajkPermitTime") == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: CustomText('Attention', color: ColorsCustom.black),
            content: CustomText(
              'Sorry, you are not registered as an eligible AJK user. Please request approval from admin to use AJK.',
              color: ColorsCustom.generalText,
            ),
            actions: mode == 'home'
                ? <Widget>[
                    Container(
                      height: 45,
                      child: TextButton(
                        style: TextButton.styleFrom(),
                        onPressed: () {
                          Navigator.popAndPushNamed(
                              context, '/SearchAjkShuttle');
                        },
                        //materialTapTargetSize: //materialTapTargetSize.shrinkWrap,
                        child: CustomText(
                          'View Route',
                          color: ColorsCustom.blueSystem,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      child: TextButton(
                        style: TextButton.styleFrom(),
                        onPressed: () => onRequestPermit(context, mode: mode),
                        //materialTapTargetSize: //materialTapTargetSize.shrinkWrap,
                        child: CustomText(
                          'Send Request',
                          fontWeight: FontWeight.w600,
                          color: ColorsCustom.blueSystem,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ]
                : <Widget>[
                    Container(
                      child: TextButton(
                        style: TextButton.styleFrom(),
                        // height: 45,
                        onPressed: () => onRequestPermit(context, mode: mode),
                        //materialTapTargetSize: //materialTapTargetSize.shrinkWrap,
                        child: CustomText(
                          'Send Request',
                          fontWeight: FontWeight.w600,
                          color: ColorsCustom.blueSystem,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      child: TextButton(
                        style: TextButton.styleFrom(),
                        onPressed: () => Navigator.pop(context),
                        child: CustomText(
                          'Cancel',
                          color: ColorsCustom.blueSystem,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: CustomText(
                mode == 'home' || mode == 'picking'
                    ? 'Information'
                    : 'Booking Failed',
                color: ColorsCustom.black),
            content: CustomText(
              'Please wait 48 hours (max) for admin approval. We will contact you by email.',
              color: ColorsCustom.generalText,
            ),
            actions: <Widget>[
              Container(
                height: 45,
                child: TextButton(
                  style: TextButton.styleFrom(),
                  onPressed: () => mode == 'home'
                      ? Navigator.popAndPushNamed(context, '/SearchAjkShuttle')
                      : Navigator.pop(context),
                  //materialTapTargetSize: //materialTapTargetSize.shrinkWrap,
                  child: CustomText(
                    mode == 'home' ? "View Route" : 'OK',
                    color: ColorsCustom.blueSystem,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  static Future<void> onRequestPermit(BuildContext context,
      {String mode}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dynamic res = await Providers.permitRequest();
      print(res.data);
      if (res.data['code'] == 'SUCCESS') {
        prefs.setInt('ajkPermitTime', DateTime.now().millisecondsSinceEpoch);
        // Navigator.pop(context);
        showSuccessDialog(context, mode: mode);
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  static void showSuccessDialog(BuildContext context, {String mode}) {
    showDialog(
        context: context,
        builder: (_) => CustomDialog(
            image: "success_icon.svg",
            title: "Your Request Has Been Sent",
            desc:
                "${mode == 'picking' ? "If within 48 hours after submission you don’t receive any information, please contact us." : "Please wait 48 hours (max) for admin approval. We will contact you by email."}",
            onClick: () => mode == 'home'
                ? {Navigator.pop(context), Navigator.pop(context)}
                : Navigator.pushNamedAndRemoveUntil(
                    context, '/Home', (route) => false)));
  }
}
