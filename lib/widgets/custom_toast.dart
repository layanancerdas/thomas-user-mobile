import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/helpers/colors_custom.dart';

import 'custom_text.dart';

class CustomToast extends StatefulWidget {
  final String image, title;
  final Color color;
  final Duration duration;

  CustomToast({this.image, this.title, this.color, this.duration});
  @override
  _CustomToastState createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(widget.duration, () => Navigator.pop(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Material(
        type: MaterialType.transparency,
        child: Stack(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: screenSize.width / 1.8,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                  color: widget.color ?? ColorsCustom.primaryGreen,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 8),
                        spreadRadius: 0,
                        blurRadius: 12,
                        color: ColorsCustom.black.withOpacity(0.2))
                  ],
                  borderRadius: BorderRadius.circular(16)),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Column(mainAxisSize: MainAxisSize.min, children: [
                  SvgPicture.asset(
                    'assets/images/${widget.image}',
                  ),
                  SizedBox(height: 16),
                  CustomText(
                    "${widget.title}",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  )
                ])
              ]),
            ),
          )
        ]));
  }
}
