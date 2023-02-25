import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/localization/app_translations.dart';
import 'custom_text.dart';

class ErrorPage extends StatefulWidget {
  final String mode;

  ErrorPage({this.mode: 'maintenance'});

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  final List errorModeIn = [
    {
      "title": "WKami sedang dalam pemeliharaan",
      "desc":
          "Kami sedang bekerja untuk menciptakan sesuatu yang lebih baik. Tidak akan lama.",
      "image": "maintenance.svg"
    },
    {
      "title": "Oops! No Internet Connection",
      "desc":
          "Harap periksa koneksi Wi Fi atau data seluler Anda dan coba lagi.",
      "image": "no_internet.svg"
    },
  ];
  final List errorModeEn = [
    {
      "title": "We were under maintenance",
      "desc":
          "We are working towards creating something better. Won’t be long.",
      "image": "maintenance.svg"
    },
    {
      "title": "Oops! No Internet Connection",
      "desc":
          "Please check your Wi Fi connection or mobile data and try again.",
      "image": "no_internet.svg"
    },
  ];

  Future<void> onRetry() async {
    try {
      final result = await InternetAddress.lookup('https://www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('connected');
        Navigator.pushNamedAndRemoveUntil(
            context, '/Home', (Route<dynamic> route) => false);
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: SvgPicture.asset(
            'assets/images/logo_tomaas.svg',
            height: 25,
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  SvgPicture.asset(
                      "assets/images/${widget.mode == "maintenance" ? errorModeIn[0]['image'] : errorModeIn[1]['image']}"),
                  SizedBox(height: 30),
                  CustomText(
                    AppTranslations.of(context).currentLanguage == 'id'
                        ? "${widget.mode == "maintenance" ? errorModeIn[0]['title'] : errorModeIn[1]['title']}"
                        : "${widget.mode == "maintenance" ? errorModeEn[0]['title'] : errorModeEn[1]['title']}",
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: ColorsCustom.black,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  CustomText(
                    AppTranslations.of(context).currentLanguage == 'id'
                        ? "${widget.mode == "maintenance" ? errorModeIn[0]['desc'] : errorModeIn[1]['desc']}"
                        : "${widget.mode == "maintenance" ? errorModeEn[0]['desc'] : errorModeEn[1]['desc']}",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: ColorsCustom.black,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            widget.mode == "internet"
                ? Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          //     color: ColorsCustom.primary,
                          // textColor: Colors.white,
                          elevation: 1,
                        ),
                        onPressed: () => onRetry(),
                        child: Text(
                          "${AppTranslations.of(context).text("retry")}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ));
  }
}
