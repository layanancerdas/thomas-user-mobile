import 'package:flutter/material.dart';
import './my_trips_view.dart';

class MyTrips extends StatefulWidget {
  final int index;

  MyTrips({this.index: 0});

  @override
  MyTripsView createState() => new MyTripsView();
}
