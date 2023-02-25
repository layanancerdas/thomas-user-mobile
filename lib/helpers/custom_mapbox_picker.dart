import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:mapbox_search/mapbox_search.dart' as mapboxSearch;
import 'package:redux/redux.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/redux/app_state.dart';

import 'custom_map_page.dart';
import 'custom_nomatim_service.dart';

class CustomMapBoxLocationPicker extends StatefulWidget {
  CustomMapBoxLocationPicker({
    @required this.apiKey,
    this.onSelected,
    this.onChangeMarker,
    // this.onSearch,
    this.searchHint = 'Search',
    this.language = 'en',
    this.location,
    this.limit = 5,
    this.country,
    this.context,
    this.height,
    this.popOnSelect = false,
    this.awaitingForLocation = "Awaiting for you current location",
    this.customMarkerIcon,
    this.customMapLayer,
    this.initLocation,
    this.showCurrent = false,
    this.toggleShowCurrent,
  });

  //
  final TileLayer customMapLayer;

  //
  final Widget customMarkerIcon;

  /// API Key of the MapBox.
  final String apiKey;

  final String country;

  /// Height of whole search widget
  final double height;

  final String language;

  /// Limits the no of predections it shows
  final int limit;

  /// The point around which you wish to retrieve place information.
  final Location location;
  final Location initLocation;

  /// Language used for the autocompletion.
  ///
  /// Check the full list of [supported languages](https://docs.mapbox.com/api/search/#language-coverage) for the MapBox API

  ///Limits the search to the given country
  ///
  /// Check the full list of [supported countries](https://docs.mapbox.com/api/search/) for the MapBox API

  /// True if there is different search screen and you want to pop screen on select
  final bool popOnSelect;

  final bool showCurrent;

  ///Search Hint Localization
  final String searchHint;

  /// Waiting For Location Hint text
  final String awaitingForLocation;

  final toggleShowCurrent;

  @override
  _CustomMapBoxLocationPickerState createState() =>
      _CustomMapBoxLocationPickerState();

  ///To get the height of the page
  final BuildContext context;

  /// The callback that is called when one Place is selected by the user.
  final void Function(MapBoxPlace place) onSelected;

  final void Function(Map place) onChangeMarker;

  /// The callback that is called when the user taps on the search icon.
  // final void Function(MapBoxPlaces place) onSearch;
}

class _CustomMapBoxLocationPickerState extends State<CustomMapBoxLocationPicker>
    with SingleTickerProviderStateMixin {
  Store<AppState> store;

  var reverseGeoCoding;

  List _addresses = List();
  // SearchContainer height.

  Position _currentPosition;
  double _lat;
  double _lng;
  MapController _mapController;

  List<Marker> _markers;

  bool isLoading = true;
  bool firstLoadShowCurrent = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getCurrentLocation();
    _mapController = MapController();

    // _markers = [
    /*
      --- manage marker
    // */
    //   Marker(
    //     width: 50.0,
    //     height: 50.0,
    //     point: new LatLng(0.0, 0.0),
    //     builder: (ctx) => new Container(
    //         child: widget.customMarkerIcon == null
    //             ? Icon(
    //                 Icons.location_on,
    //                 size: 50.0,
    //               )
    //             : widget.customMarkerIcon),
    //   )
    // ];

    Timer.periodic(Duration(milliseconds: 200), (_) => getShowCurrent());

    super.initState();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  getShowCurrent() {
    if (mounted) {
      setState(() {
        if (widget.showCurrent) {
          Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
              .then((Position position) async {
            _lat = position.latitude;
            _lng = position.longitude;

            // await _animationController.animateTo(0.5);
            _animatedMapMove(LatLng(position.latitude, position.longitude), 15);
            // _mapController.move(
            //     LatLng(position.latitude, position.longitude), 15);
            widget.toggleShowCurrent(false);
            // _animationController.reverse();
          }).catchError((e) {
            print(e);
          });
        }
      });
    }
  }

  getCurrentLocation() {
    /*
    --- Função responsável por receber a localização atual do usuário
  */
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _getCurrentLocationMarker();
          // _getCurrentLocationDesc();
          getLocationWithLatLng("init");
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  _getCurrentLocationMarker() {
    /*
    --- Função responsável por atualizar o marcador para a localização atual do usuário
  */
    if (mounted) {
      setState(() async {
        _lat = widget.initLocation != null
            ? widget.initLocation.lat
            : _currentPosition.latitude;
        _lng = widget.initLocation != null
            ? widget.initLocation.lng
            : _currentPosition.longitude;

        isLoading = false;
      });
    }
  }

  void moveMarker(MapBoxPlace prediction) {
    if (mounted) {
      setState(() {
        _lat = prediction.geometry.coordinates.elementAt(1);
        _lng = prediction.geometry.coordinates.elementAt(0);

        _markers[0] = Marker(
          width: 50.0,
          height: 50.0,
          point: LatLng(_lat, _lng),
          builder: (ctx) => new Container(
              child: widget.customMarkerIcon == null
                  ? Icon(
                      Icons.location_on,
                      size: 50.0,
                    )
                  : widget.customMarkerIcon),
        );
      });
    }
  }

  Future<void> getLocationWithLatLng(String mode) async {
    dynamic res =
        await CustomNominatimService().getAddressLatLng("$_lat $_lng");
    if (mounted) {
      setState(() {
        _addresses = res;
      });
    }

    var geoCodingService = mapboxSearch.ReverseGeoCoding(
      apiKey: ACCESS_TOKEN,
      country: "ID",
      limit: 1,
    );

    var addresses = await geoCodingService.getAddress(mapboxSearch.Location(
      lat: mode == 'change' ? _lat : widget.initLocation.lat,
      lng: mode == 'change' ? _lng : widget.initLocation.lng,
    ));
    print(addresses);
    widget.onChangeMarker({..._addresses[0], "name": addresses[0]});
  }

  void onTapMarker(MapPosition position, bool hasGesture) {
    if (hasGesture &&
        _lat != position.center.latitude &&
        _lng != position.center.longitude) {
      setState(() {
        _lat = position.center.latitude;
        _lng = position.center.longitude;

        getLocationWithLatLng('change');
      });
    }
  }

  Widget mapContext(BuildContext context) {
    /*
    --- Widget responsável pela representação cartográfica da região, assim como seu ponto no espaço. 
  */
    while (isLoading) {
      return new Center(
        child: Loading(
          indicator: BallSpinFadeLoaderIndicator(),
        ),
      );
    }

    return new CustomMapPage(
        lat: _lat,
        lng: _lng,
        mapController: _mapController,
        onChanged: onTapMarker,
        // markers: _markers,
        apiKey: widget.apiKey,
        customMapLayer: widget.customMapLayer);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: <Widget>[
            Container(width: double.infinity, height: double.infinity),
            mapContext(context),
            isLoading
                ? SizedBox()
                : Positioned(
                    top: (screenSize.height / 4 * 1.5) - 67,
                    left: (screenSize.width / 2) - 27,
                    child: Container(
                      width: 54,
                      height: 67,
                      child: Center(child: widget.customMarkerIcon),
                    ),
                  )
          ],
        ));
  }
}
