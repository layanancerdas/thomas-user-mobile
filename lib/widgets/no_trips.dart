import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';

class NoTrips extends StatelessWidget {
  final String text;
  final Widget button;

  NoTrips({this.text, this.button});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/images/no_trips.svg"),
          CustomText(
            "$text",
            fontWeight: FontWeight.w300,
            fontSize: 14,
            color: ColorsCustom.black,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Center(child: button ?? SizedBox(height: 60)),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
