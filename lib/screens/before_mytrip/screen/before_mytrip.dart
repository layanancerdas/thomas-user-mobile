import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tomas/widgets/card_active.dart';
import 'package:tomas/widgets/card_complete.dart';
import 'package:tomas/widgets/card_list.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/card_active_checkin.dart';

class BeforeMyTrip extends StatelessWidget {
  const BeforeMyTrip({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              "Upcoming Trip",
              textAlign: TextAlign.center,
              // "${state.selectedMyTrip['details']['bus'] != null ? state.selectedMyTrip['details']['bus']['license_plate'] : "-"}",
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ]),
      ),
    );
  }
}
