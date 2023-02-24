import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/screens/subscribe_trip/screen/subscribe_trip.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/localization/app_translations.dart';

class NoResultSubscribeTrip extends StatelessWidget {
  final String idRoute;
  const NoResultSubscribeTrip({Key key, this.idRoute}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        SvgPicture.asset("assets/images/no_search_ajk.svg"),
        CustomText(
          "${AppTranslations.of(context).text("no_shuttle")}",
          fontWeight: FontWeight.w300,
          fontSize: 14,
          color: ColorsCustom.black,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        InkWell(
          onTap: () {
            Get.to(SubscribeTrip(idRoute: idRoute));
          },
          child: Container(
            decoration: BoxDecoration(
                color: ColorsCustom.primary,
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(20),
            child: CustomText(
              'Subscribe Now',
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
