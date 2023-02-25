import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/helpers/custom_nomatim_service.dart' as nomatim;
import 'package:tomas/redux/app_state.dart';
import 'search_trip_picker.dart';

abstract class SearchTripPickerViewModel extends State<SearchTripPicker> {
  Store<AppState> store;
  bool showCurrent = false;

  void toggleShowCurrent(bool value) {
    setState(() {
      showCurrent = value;
    });
  }

  void onNext() {
    Navigator.pushReplacementNamed(context, "/PlanTrip");
  }

  void onChangeMarker(Map place) {
    toggleShowCurrent(false);
    if (widget.mode == 'destination') {
      store.dispatch(SetSearchDestination(searchDestination: {
        "name": place['name'],
        "address": place['description'],
        "latLng": nomatim.Location(
            lat: double.parse(place['lat']), lng: double.parse(place['lng']))
      }));
    } else {
      store.dispatch(SetSearchOrigin(searchOrigin: {
        "name": place['name'],
        "address": place['description'],
        "latLng": nomatim.Location(
            lat: double.parse(place['lat']), lng: double.parse(place['lng']))
      }));
    }
  }

  Future<void> getCurrentLocation() async {
    toggleShowCurrent(true);

    try {
      Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best) ??
          await Geolocator.getLastKnownPosition();
      List<Placemark> _placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // print(_placemark[0].name);
      // print(_placemark[0].administrativeArea);
      // print(_placemark[0].country);
      // print(_placemark[0].locality);
      // print(_placemark[0].postalCode);
      // print(_placemark[0].subAdministrativeArea);
      // print(_placemark[0].subLocality);
      // print(_placemark[0].subThoroughfare);
      // print(_placemark[0].thoroughfare);
      // print(_placemark[0].toJson());

      if (widget.mode == 'destination') {
        store.dispatch(SetSearchDestination(searchDestination: {
          "name": _placemark[0].name,
          "address": _placemark[0].name +
              ", " +
              _placemark[0].subLocality +
              ", " +
              _placemark[0].locality +
              ", " +
              _placemark[0].subAdministrativeArea +
              ", " +
              _placemark[0].administrativeArea +
              ", " +
              _placemark[0].country,
          "latLng":
              nomatim.Location(lat: position.latitude, lng: position.longitude)
        }));
      } else {
        store.dispatch(SetSearchOrigin(searchOrigin: {
          "name": _placemark[0].name,
          "address": _placemark[0].name +
              ", " +
              _placemark[0].subLocality +
              ", " +
              _placemark[0].locality +
              ", " +
              _placemark[0].subAdministrativeArea +
              ", " +
              _placemark[0].administrativeArea +
              ", " +
              _placemark[0].country,
          "latLng":
              nomatim.Location(lat: position.latitude, lng: position.longitude)
        }));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
    });
  }
}
