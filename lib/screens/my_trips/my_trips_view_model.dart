import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tomas/redux/app_state.dart';
import './my_trips.dart';

abstract class MyTripsViewModel extends State<MyTrips> {
  Store<AppState> store;

  int index = 0;

  @override
  void initState() {
    index = widget.index;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
    });
  }
}
