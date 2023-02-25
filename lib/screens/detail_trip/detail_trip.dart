import 'package:flutter/material.dart';
import './detail_trip_view.dart';

class DetailTrip extends StatefulWidget {
  final Map dataNotif;

  DetailTrip({this.dataNotif});

  @override
  DetailTripView createState() => new DetailTripView();

  static DetailTripView of(BuildContext context) =>
      context.findAncestorStateOfType<DetailTripView>();
}
