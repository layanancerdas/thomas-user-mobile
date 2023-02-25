import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/widgets/custom_text.dart';

class ResultAjkShuttle extends StatelessWidget {
  final Map data;
  final onClick;

  ResultAjkShuttle({this.onClick, this.data});

  @override
  Widget build(BuildContext context) {
    // print(data);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            ),
            onPressed: () => onClick(data),
            child: Row(
              children: [
                Container(
                  height: 23,
                  width: 23,
                  child: SvgPicture.asset('assets/images/school_bus.svg'),
                ),
                SizedBox(width: 16),
                CustomText(
                  "${Utils.capitalizeFirstofEach(data['pickup_points'][0]['name']) ?? "-"}",
                  color: ColorsCustom.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                Container(
                  width: 30,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: SvgPicture.asset('assets/images/exchange.svg'),
                ),
                CustomText(
                  "${Utils.capitalizeFirstofEach(data['destination_name']) ?? "-"}",
                  color: ColorsCustom.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                )
              ],
            )),
        Container(
          color: Color(0xFFE8E8E8),
          height: 1,
          width: double.infinity,
        )
      ],
    );
  }
}
