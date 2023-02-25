import 'package:flutter/material.dart';
import './home_view.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  final int index;
  final bool forceLoading;
  int tab;

  Home({this.index: 0, this.tab, this.forceLoading: false});

  @override
  HomeView createState() => new HomeView();
  static HomeView of(BuildContext context) =>
      context.findAncestorStateOfType<HomeView>();
}
