import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';

class ButtonMenu extends StatelessWidget {
  final String name, logo;
  final Color color;
  final onClick;

  ButtonMenu({this.logo, this.name, this.onClick, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 74,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: Offset(0, 8),
              spreadRadius: 0,
              blurRadius: 24,
              color: ColorsCustom.black.withOpacity(0.08))
        ]),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(bottom: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            //  color: Colors.white,
            elevation: 0,
          ),
          //materialTapTargetSize: //materialTapTargetSize.shrinkWrap,

          onPressed: onClick,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 74,
                width: 78,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(24)),
                child: Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: SvgPicture.asset('assets/images/$logo'),
                  ),
                ),
              ),
              SizedBox(height: 10),
              CustomText(
                "$name",
                textAlign: TextAlign.center,
                color: ColorsCustom.black,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
