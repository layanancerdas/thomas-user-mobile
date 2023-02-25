import 'package:flutter/material.dart';
import 'package:tomas/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final EdgeInsets padding, margin;
  final Color textColor, bgColor;
  final double fontSize, width;
  final BorderRadius borderRadius;
  final FontWeight fontWeight;
  final bool isLoading, flat;
  final onPressed;

  CustomButton(
      {this.text,
      this.textColor,
      this.bgColor,
      this.onPressed,
      this.width,
      this.padding,
      this.fontSize,
      this.fontWeight,
      this.borderRadius,
      this.isLoading: false,
      this.margin,
      this.flat: false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: width ?? null,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: Offset(0, 8),
            color: bgColor != null
                ? bgColor.withOpacity(0.15)
                : Colors.transparent,
            blurRadius: 24,
            spreadRadius: 0)
      ]),
      child: flat
          ? TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(16)),
                padding: padding,
              ),

              onPressed: onPressed,
              // color: bgColor,
              child: Center(
                child: isLoading
                    ? SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : CustomText(
                        "$text",
                        color: textColor,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
              ),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                //   color: bgColor,
                // disabledColor: bgColor,
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(16)),
                padding: padding,
              ),
              onPressed: onPressed,
              child: Center(
                child: isLoading
                    ? SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : CustomText(
                        "$text",
                        color: textColor,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
              ),
            ),
    );
  }
}
