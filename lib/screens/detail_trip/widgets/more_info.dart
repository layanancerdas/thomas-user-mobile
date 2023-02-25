import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';

class MoreInfo extends StatefulWidget {
  final String title, icon, text;
  final List content;

  MoreInfo({this.title, this.content, this.icon, this.text});

  @override
  _MoreInfoState createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  bool stretch = false;

  void toggleStretch() {
    setState(() {
      stretch = !stretch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        margin: EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(minHeight: stretch ? 10 : 0),
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  spreadRadius: 1,
                  blurRadius: 4,
                  color: ColorsCustom.black.withOpacity(0.15))
            ]),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            // highlightColor: ColorsCustom.black.withOpacity(0.1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          onPressed: () => toggleStretch(),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/${widget.icon}.svg",
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(width: 12),
                      Flexible(
                        child: CustomText(
                          "${widget.title}",
                          color: ColorsCustom.black,
                          overflow: true,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/images/${stretch ? "arrow_up" : "arrow_down"}.svg",
                      height: 8,
                    ),
                  ),
                ),
              ],
            ),
            widget.content != null
                ? AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: stretch
                        ? EdgeInsets.symmetric(vertical: 8)
                        : EdgeInsets.zero,
                    child: stretch
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Divider(color: Colors.grey, height: 1),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: widget.content
                                    .map((e) => listPoint(e))
                                    .toList(),
                              ),
                            ],
                          )
                        : SizedBox())
                : SizedBox(),
            widget.text != null
                ? AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: stretch
                        ? EdgeInsets.only(top: 7, bottom: 14)
                        : EdgeInsets.zero,
                    child: stretch
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: Divider(color: Colors.grey, height: 1),
                              ),
                              CustomText(
                                "${widget.text}",
                                color: ColorsCustom.generalText,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                height: 1.8,
                              ),
                            ],
                          )
                        : SizedBox())
                : SizedBox()
          ]),
        ));
  }

  Widget listPoint(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            width: 4,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: Color(0xFF75C1D4),
                borderRadius: BorderRadius.circular(2)),
          ),
          SizedBox(width: 10),
          Flexible(
            child: CustomText(
              "$value",
              color: ColorsCustom.generalText,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
