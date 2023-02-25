import 'package:flutter/material.dart';
import './search_trip_view.dart';

class SearchTrip extends StatefulWidget {
  final String mode;

  SearchTrip({this.mode});

  @override
  SearchTripView createState() => new SearchTripView();
}
