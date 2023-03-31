import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/localization/app_translations.dart';

import 'custom_text.dart';

class ModalNoLocation extends StatefulWidget {
  final String mode;

  ModalNoLocation({this.mode: 'service'});

  @override
  _ModalNoLocationState createState() => _ModalNoLocationState();
}

class _ModalNoLocationState extends State<ModalNoLocation> {
  Future<void> onEnableLocation() async {
    if (widget.mode == 'service') {
      await Geolocator.openLocationSettings();
    } else {
      await Geolocator.requestPermission();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.white.withOpacity(0.20),
      child: Stack(
        children: [
          Container(
            height: screenSize.height,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                )),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/enable_location.svg"),
                SizedBox(height: 30),
                CustomText(
                  "${widget.mode == 'permission' ? 'Allow your permission location' : 'Enable your location'}",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: ColorsCustom.black,
                  // textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                CustomText(
                  "${AppTranslations.of(context).text("no_location")}",
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.justify,
                  fontSize: 14,
                  color: ColorsCustom.black,
                  // textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                //   color: ColorsCustom.primary,
                // textColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 1,
              ),
              onPressed: () => onEnableLocation(),
              child: Text(
                AppTranslations.of(context).currentLanguage == 'id'
                    ? "${widget.mode == 'permission' ? "Berikan izin" : "Aktifkan Lokasi"}"
                    : "${widget.mode == 'permission' ? "Allow Permission" : "Enable Location"}",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                "assets/images/close.svg",
                width: 16,
                height: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
