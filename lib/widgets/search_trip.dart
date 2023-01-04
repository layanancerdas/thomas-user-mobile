import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/helpers/colors_custom.dart';

class SearchTrip extends StatelessWidget {
  final TextEditingController controller;
  final Widget prefix;
  final String hint;
  final bool showDelete;
  final Color borderColor, iconColor;
  final onChange, onClear;

  SearchTrip(
      {this.controller,
      this.onChange,
      this.hint,
      this.borderColor,
      this.iconColor,
      this.prefix,
      this.onClear,
      this.showDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45,
        padding:
            prefix != null ? EdgeInsets.zero : EdgeInsets.fromLTRB(20, 0, 5, 0),
        decoration: BoxDecoration(
            border: borderColor != null ? Border.all(color: borderColor) : null,
            borderRadius: BorderRadius.circular(50),
            color: Colors.white),
        child: TextField(
          style: TextStyle(
              fontSize: 14,
              color: ColorsCustom.black,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins"),
          controller: controller,
          onChanged: (value) => onChange(value),
          cursorHeight: 17,
          cursorColor: Color(0xFFff4757),
          decoration: InputDecoration(
            prefixIcon: prefix != null ? prefix : null,
            suffixIcon: showDelete
                ? GestureDetector(
                    onTap: onClear,
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/images/clear.svg",
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 16,
                    width: 16,
                    child: Center(
                      child: SvgPicture.asset(
                        prefix == null
                            ? "assets/images/search.svg"
                            : "assets/images/search-grey.svg",
                      ),
                    ),
                  ),
            focusColor: Color(0xFFff4757),
            hoverColor: Color(0xFFff4757),
            contentPadding: EdgeInsets.symmetric(vertical: 11.5),
            fillColor: Color(0xFFced6e0),
            hintText: "$hint",
            hintStyle: TextStyle(
                fontSize: 14,
                color: Color(0xFFA1A4A8),
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins"),
            border: InputBorder.none,
          ),
        ));
  }
}
