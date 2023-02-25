import 'package:flutter/material.dart';
import 'search_trip_picker_view.dart';

class SearchTripPicker extends StatefulWidget {
  final String mode;

  SearchTripPicker({this.mode});

  @override
  SearchTripPickerView createState() => new SearchTripPickerView();
}
