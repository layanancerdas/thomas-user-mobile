import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';

import 'package:mapbox_search/mapbox_search.dart';
import 'package:redux/redux.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/ajk_action.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/search_trip_picker/search_trip_picker.dart';
import 'package:tomas/widgets/modal_no_location.dart';
import './search_trip.dart';

abstract class SearchTripViewModel extends State<SearchTrip> {
  Store<AppState> store;
  final TextEditingController searchController = TextEditingController();

  Predictions predictions;

  bool isLoading = true;
  bool error = false;

  Timer _debounce;

  void toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void onClear() {
    setState(() {
      searchController.text = "";
      predictions = Predictions.empty();
    });
  }

  void onSearchRoute(String value) {
    setState(() {
      error = false;
    });
    if (value.length > 0) {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce =
          Timer(const Duration(milliseconds: 500), () => getPlaceMapbox(value));
    } else {
      setState(() {
        predictions = Predictions.empty();
      });
    }
  }

  void onPressResult(Map data) {
    if (widget.mode == 'origin') {
      store.dispatch(SetSearchOrigin(searchOrigin: data));
    } else {
      store.dispatch(SetSearchDestination(searchDestination: data));
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                SearchTripPicker(mode: widget.mode ?? 'destination')));
  }

  Future listenForPermissionStatus() async {
    try {
      LocationPermission permission;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ModalNoLocation(
                mode: 'permission',
              );
            });
        //   return Future.error(
        //       'Location permissions are permantly denied, we cannot request permissions.');
      }
      print(permission.toString());
      if (permission == LocationPermission.denied) {
        // permission = await Geolocator.requestPermission();
        // if (permission != LocationPermission.whileInUse &&
        //     permission != LocationPermission.always) {
        //   }
        await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ModalNoLocation(
                mode: 'permission',
              );
            });
      }
    } catch (e) {
      print(e);
    } finally {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ModalNoLocation();
            });
      }
    }
  }

  Future<void> getAllRoute() async {
    try {
      dynamic res = await Providers.getAjkRoute();
      List _temp = res.data['data'];

      _temp.sort((a, b) => a['pickup_points'][0]['name']
          .compareTo(b['pickup_points'][0]['name']));

      store.dispatch(SetRoutes(routes: _temp));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getPlaceMapbox(String value) async {
    try {
      dynamic res = await Providers.getPlaceMapbox(
          limit: 5, country: 'ID', input: value, language: 'en');
      // print(res.data);

      setState(() {
        predictions = Predictions.fromRawJson(res.data);
        error = predictions.features.length <= 0 ? true : false;
      });
    } catch (e) {
      setState(() {
        error = true;
      });
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    predictions = Predictions.empty();
    listenForPermissionStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
      getAllRoute();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
