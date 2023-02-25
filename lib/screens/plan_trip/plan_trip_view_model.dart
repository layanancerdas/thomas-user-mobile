import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/ajk_action.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/helpers/custom_nomatim_service.dart' as nomatim;
import 'package:tomas/screens/round_trip/round_trip.dart';
import './plan_trip.dart';

abstract class PlanTripViewModel extends State<PlanTrip> {
  Store<AppState> store;
  bool isLoading = true;
  bool currentLocation = false;

  void toggleIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void onClick(Map data, Map dataPickupPoint) {
    store.dispatch(SetSelectedRoute(selectedRoute: data));
    store.dispatch(SetSelectedPickUpPoint(
        selectedPickUpPoint:
            dataPickupPoint)); // store.dispatch(SetSelectedPickUpPoint(sele: data));
    Navigator.push(context, MaterialPageRoute(builder: (_) => RoundTrip()));
  }

  Future<void> onExhcange() async {
    store.dispatch(ExchangeSearch());
    await getResult();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best) ??
          await Geolocator.getLastKnownPosition();
      List<Placemark> _placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (!store.state.generalState.searchOrigin.containsKey("name")) {
        store.dispatch(SetSearchOrigin(searchOrigin: {
          "name": "Your current location",
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
    } finally {
      getResult();
    }
  }

  Future<void> getResult() async {
    try {
      dynamic res = await Providers.getAjkRouteByLatLng(
          origin: store.state.generalState.searchOrigin['latLng'],
          destination: store.state.generalState.searchDestination['latLng'],
          radius: 10);
      store.dispatch(SetSearchResult(searchResult: res.data['data']));
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
      getCurrentLocation();
      getResult();
    });
  }
}
