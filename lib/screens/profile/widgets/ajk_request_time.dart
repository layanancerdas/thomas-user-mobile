import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class AjkRequestTime extends StatefulWidget {
  @override
  _AjkRequestTimeState createState() => _AjkRequestTimeState();
}

class _AjkRequestTimeState extends State<AjkRequestTime> {
  int permitTime = 0;

  Future<void> initPermitTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      permitTime = prefs.getInt('ajkPermitTime') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    initPermitTime();
  }

  @override
  Widget build(BuildContext context) {
    return permitTime > 0
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Card(
                elevation: 3,
                shadowColor: ColorsCustom.black.withOpacity(.35),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/images/hour_glass_red.svg",
                                width: 12.5,
                              ),
                              SizedBox(width: 12),
                              CustomText(
                                "AJK Request Processed",
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: ColorsCustom.black,
                              )
                            ],
                          ),
                          SizedBox(height: 3),
                          RichText(
                            text: new TextSpan(
                              text:
                                  "${AppTranslations.of(context).text("submission")}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  color: ColorsCustom.black,
                                  fontFamily: 'Poppins'),
                              children: <TextSpan>[
                                new TextSpan(
                                    text:
                                        '${Utils.formatterDateCompleted.format(DateTime.fromMillisecondsSinceEpoch(permitTime))}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    )),
                              ],
                            ),
                          )
                        ]))),
          )
        : SizedBox(height: 20);
  }
}
