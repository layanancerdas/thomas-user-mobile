import 'package:flutter/material.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';

class ResultSearch extends StatelessWidget {
  final Map data;
  final onPress;

  ResultSearch({this.data, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: ColorsCustom.border, width: 1))),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          // highlightColor: ColorsCustom.black.withOpacity(0.05),
        ),
        onPressed: () => onPress(data),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Icon(
                Icons.location_on,
                color: ColorsCustom.disable,
                size: 18,
              ),
            ),
            SizedBox(width: 16),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "${data['name'] ?? "-"}",
                  fontWeight: FontWeight.w600,
                  color: ColorsCustom.black,
                  fontSize: 14,
                ),
                SizedBox(height: 4),
                CustomText(
                  "${data['address'] ?? "-"}",
                  fontWeight: FontWeight.w400,
                  color: ColorsCustom.black,
                  fontSize: 12,
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
