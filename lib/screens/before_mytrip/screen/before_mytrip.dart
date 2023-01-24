import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tomas/widgets/card_list.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/detail_card_trips2.dart';

class BeforeMyTrip extends StatelessWidget {
  const BeforeMyTrip({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(children: [
        CardList(
          title: 'Test',
          type: 'Type test',
          pointA: 'terminal',
          pointB: 'kantor',
        ),
        DetailCardTrips2(
          dateA: DateTime.parse('2022-04-01'),
          dateB: DateTime.parse('2022-04-01'),
          title: 'Test',
          type: 'Type test',
          pointA: 'terminal',
          pointB: 'kantor',
          timeA: '08:00',
          timeB: '19:00',
          differenceAB: '1.2 Kilometer',
          addressA: 'Jalan Cicaheum',
          addressB: 'Jalan Cikutra',
        ),
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
    );
  }
}
