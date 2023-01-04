import 'package:flutter/material.dart';
import './review_view.dart';

class Review extends StatefulWidget {
  final bool isFromDetail;
  final Map dataNotif;

  Review({this.isFromDetail: false, this.dataNotif});
  @override
  ReviewView createState() => new ReviewView();
}
