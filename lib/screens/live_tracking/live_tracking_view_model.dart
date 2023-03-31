import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';
// import 'package:flutter_mapbox_navigation/library.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redux/redux.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/live_tracking/widgets/dialog_qr.dart';
import './live_tracking.dart';

abstract class LiveTrackingViewModel extends State<LiveTracking> {
  Store<AppState> store;
  var _streamDB;

  double duration = 0;
  String status;
  String subStatus;
  Map<MarkerId, Marker> markers = {};
  Map<CircleId, Circle> circles = {};
  Map<PolylineId, Polyline> polylines = {};
  GoogleMapController controller2;
  final CameraPosition initialLocation = CameraPosition(
    target: LatLng(-6.895160, 107.639285),
    zoom: 12,
  );
  void onViewETicket() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogQr();
        });
  }

  Future<void> getBookingByGroupId() async {
    store.dispatch(SetIsLoading(isLoading: true));
    try {
      dynamic res = await Providers.getBookingByBookingId(
          bookingId: store.state.userState.selectedMyTrip['booking_id']);
      if (res.data['code'] == 'SUCCESS') {
        getStatusText();

        print(res.data['data']);
        store.dispatch(SetSelectedMyTrip(
            selectedMyTrip: res.data['data'],
            getSelectedTrip: [res.data['data']]));
      }
      store.dispatch(SetIsLoading(isLoading: false));
    } catch (e) {
      print(e);
    } finally {
      store.dispatch(SetIsLoading(isLoading: false));
    }
  }

  void getStatusText() {
    setState(() {
      // print(store.state.userState.selectedMyTrip['status']);

      if (store.state.userState.selectedMyTrip['booking_note'] != null) {
        if (store.state.userState.selectedMyTrip['booking_note'] ==
            'DRIVER_ON_THE_WAY') {
          status = 'Driver On The Way';
        } else if (store.state.userState.selectedMyTrip['booking_note'] ==
            'DRIVER_HAS_ARRIVED') {
          status = "Driver Has Arrived";
        } else if (store.state.userState.selectedMyTrip['booking_note'] ==
            'ON_BOARD') {
          status = "On Board";
        }
      } else {
        status = "Loading...";
      }
    });
  }

  void getSubStatusText() {
    setState(() {
      // print(store.state.userState.selectedMyTrip['status']);

      if (store.state.userState.selectedMyTrip['booking_note'] != null) {
        if (store.state.userState.selectedMyTrip['booking_note'] ==
            'DRIVER_ON_THE_WAY') {
          subStatus = 'Your driver is coming';
        } else if (store.state.userState.selectedMyTrip['booking_note'] ==
            'DRIVER_HAS_ARRIVED') {
          subStatus = "Your driver has arrived";
        } else if (store.state.userState.selectedMyTrip['booking_note'] ==
            'ON_BOARD') {
          subStatus = "On board";
        }
      } else {
        subStatus = "Loading...";
      }
    });
  }

  // String platformVersion = 'Unknown';
  // String instruction = "";
  // // final origin = WayPoint(
  // //     name: "Way Point 1", latitude: -7.965176, longitude: 112.6571662);
  // // final stop1 = WayPoint(
  // //     name: "Way Point 2", latitude: -7.9715358, longitude: 112.6576904);
  // // final stop2 = WayPoint(
  // //     name: "Way Point 3",
  // //     latitude: 38.91040213277608,
  // //     longitude: -77.03848242759705);
  // // final stop3 = WayPoint(
  // //     name: "Way Point 4",
  // //     latitude: 38.909650771013034,
  // //     longitude: -77.03850388526917);
  // // final stop4 = WayPoint(
  // //     name: "Way Point 5",
  // //     latitude: 38.90894949285854,
  // //     longitude: -77.03651905059814);

  MapBoxNavigation directions;
  MapBoxOptions options;

  bool isMultipleStop = true;
  double distanceRemaining, durationRemaining;
  MapBoxNavigationViewController controller;
  bool routeBuilt = false;
  bool isNavigating = false;
  Map latlng;

  @override
  void initState() {
    super.initState();
    // initialize();
    // Timer.periodic(Duration(seconds: 5), (timer) {
    //   // getUserLocation();
    //   // if (mounted) getBookingByGroupId();
    // });
    onInitDB("no");
    listenDB();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
      getStatusText();
      getSubStatusText();
    });
  }

  @override
  void dispose() {
    _streamDB?.cancel();
    super.dispose();
  }

  Future<Uint8List> getMarker(String url) async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(url);
    return byteData.buffer.asUint8List();
  }

  Future<void> getUserLocation({bool initLocation: false}) async {
    Uint8List iconUser = await getMarker("assets/images/bus.png");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    if (initLocation) {
      controller2.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 17.00)));
      // generateMarker();
    }

    // readData();

    // if (isTripAvailable) {
    //   updateData(position.latitude, position.longitude);
    // } else {
    //   createData(position.latitude, position.longitude);
    // }
    addMarker(
        {LatLng position,
        String id,
        BitmapDescriptor descriptor,
        Offset anchor}) {
      MarkerId markerId = MarkerId(id);
      Marker marker = Marker(
          markerId: markerId,
          icon: descriptor,
          position: position,
          flat: true,
          anchor: anchor);
      setState(() {
        markers[markerId] = marker;
      });
    }

    addMarker(
        position: LatLng(position.latitude, position.longitude),
        id: "pickupPointBus",
        descriptor: BitmapDescriptor.fromBytes(iconUser),
        anchor: Offset(0.5, 0.5));

    // Map newData = {'lat': position.latitude, 'lng': position.longitude};
    // getRouteMap(newData);
    // generateMultiplePolylines(newData);
  }

  Future<void> onInitDB(String type) async {
    print('READ DATA MASUK LOGIC');
    // var tripOrderId =
    //     await store.state.userState.selectedMyTrip['details']['trip_order_id'];
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference
        .child("live_location/90194b90-f367-11eb-af3a-bb21b1d56abd")
        .once()
        .then((snapshot) {
      print('Data : ${snapshot}');
      if (snapshot != null) {
        print(snapshot);
        // setState(() {
        //   latlng = <Map>snapshot;
        // });
        if (type == "listen") {
          print("clear something");
          // controller
          //     .clearRoute()
          //     .whenComplete(() => print("clear completed"))
          //     .catchError((e) => print(e));
          // onRecreateRoute(snapshot.value);
        }
      }
    });
  }

  Future<void> listenDB() async {
    // var tripOrderId =
    //     await store.state.userState.selectedMyTrip["details"]['trip_order_id'];
    final databaseReference = FirebaseDatabase.instance.reference();
    setState(() {
      _streamDB = databaseReference
          .child("live_location/90194b90-f367-11eb-af3a-bb21b1d56abd")
          .onChildChanged
          .listen((snapshot) async {
        print("listen");
        await onInitDB("listen");
      });
    });
  }

  void onCreated() async {
    // controller = _controller;
    // _controller.initialize();

    List wayPoints = <WayPoint>[];

    final destination = WayPoint(
      name: store.state.userState.selectedMyTrip['trip']['trip_group']['route']
          ['destination_name'],
      latitude: store.state.userState.selectedMyTrip['trip']['trip_group']
          ['route']['destination_latitude'],
      longitude: store.state.userState.selectedMyTrip['trip']['trip_group']
          ['route']['destination_longitude'],
    );
    print(destination);
    List _tempPickupPoints = store.state.userState.selectedMyTrip['trip']
        ['trip_group']['route']['pickup_points'] as List;

    for (Map element in _tempPickupPoints) {
      wayPoints.add(WayPoint(
          name: element['name'],
          latitude: element['latitude'],
          longitude: element['longitude']));
    }
    // print("print" + "$latlng");

    // wayPoints.add(WayPoint(
    //     name: "Driver", latitude: latlng['lat'], longitude: latlng['lng']));

    // final destination =
    //     WayPoint(name: "Monas", latitude: -6.181087, longitude: 106.8225714);

    // // List _tempPickupPoints = store.state.userState.selectedMyTrip['trip']
    // //     ['trip_group']['route']['pickup_points'] as List;

    // // _tempPickupPoints.forEach((element) {
    // wayPoints
    //     .add(WayPoint(name: '3', latitude: -6.3423092, longitude: 107.111347));
    // wayPoints.add(WayPoint(
    //     name: 'MONAAASSS', latitude: -6.2467833, longitude: 107.033486));
    // wayPoints
    //     .add(WayPoint(name: '1', latitude: -6.2124727, longitude: 106.8950333));
    // // });

    wayPoints.add(destination);
    // wayPoints.add(stop1);
    controller.buildRoute(wayPoints: wayPoints);
  }

  // Future<void> onRecreateRoute(Map _latlng) async {
  //   try {
  //     print("recreate");
  //     // print(controller);
  //     // await controller.initialize();
  //     List wayPoints = <WayPoint>[];

  //     final destination = WayPoint(
  //       name: store.state.userState.selectedMyTrip['trip']['trip_group']
  //           ['route']['destination_name'],
  //       latitude: store.state.userState.selectedMyTrip['trip']['trip_group']
  //           ['route']['destination_latitude'],
  //       longitude: store.state.userState.selectedMyTrip['trip']['trip_group']
  //           ['route']['destination_longitude'],
  //     );

  //     wayPoints.add(WayPoint(
  //         name: "Driver", latitude: latlng['lat'], longitude: latlng['lng']));

  //     List _tempPickupPoints = store.state.userState.selectedMyTrip['trip']
  //         ['trip_group']['route']['pickup_points'] as List;

  //     for (Map element in _tempPickupPoints) {
  //       if (element['pickup_point_id'] ==
  //           store.state.userState.selectedMyTrip['pickup_point']
  //               ['pickup_point_id']) {
  //         if (status == "Driver On The Way") {
  //           wayPoints.add(WayPoint(
  //               name: element['name'],
  //               latitude: element['latitude'],
  //               longitude: element['longitude']));
  //         } else if (status == "On Board" || status == "Driver Has Arrived") {
  //           continue;
  //         }
  //       } else {
  //         wayPoints.add(WayPoint(
  //             name: element['name'],
  //             latitude: element['latitude'],
  //             longitude: element['longitude']));
  //       }
  //     }
  //     // print("print" + "$_latlng");

  //     // wayPoints.add(WayPoint(
  //     //     name: "Driver", latitude: _latlng['lat'], longitude: _latlng['lng']));

  //     // final destination =
  //     //     WayPoint(name: "Monas", latitude: -6.181087, longitude: 106.8225714);

  //     // // List _tempPickupPoints = store.state.userState.selectedMyTrip['trip']
  //     // //     ['trip_group']['route']['pickup_points'] as List;

  //     // // _tempPickupPoints.forEach((element) {
  //     // wayPoints.add(
  //     //     WayPoint(name: '3', latitude: -6.3423092, longitude: 107.111347));
  //     // wayPoints.add(WayPoint(
  //     //     name: 'MONAAASSS', latitude: -6.2467833, longitude: 107.033486));
  //     // wayPoints.add(
  //     //     WayPoint(name: '1', latitude: -6.2124727, longitude: 106.8950333));
  //     // // });
  //     wayPoints.add(destination);
  //     // wayPoints.add(stop1);
  //     controller
  //         .buildRoute(wayPoints: wayPoints)
  //         .whenComplete(() => print("build completed"))
  //         .catchError((e) => print(e));
  //     // controller.startNavigation();
  //     // print();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> onEmbeddedRouteEvent(e) async {
  //   distanceRemaining = await directions.distanceRemaining;
  //   durationRemaining = await directions.durationRemaining;
  //   // print("durationRemaining");
  //   // print(durationRemaining);

  //   switch (e.eventType) {
  //     case MapBoxEvent.progress_change:
  //       var progressEvent = e.data as RouteProgressEvent;
  //       if (progressEvent.currentStepInstruction != null)
  //         instruction = progressEvent.currentStepInstruction;
  //       break;
  //     case MapBoxEvent.route_building:
  //     case MapBoxEvent.route_built:
  //       setState(() {
  //         routeBuilt = true;
  //       });
  //       break;
  //     case MapBoxEvent.route_build_failed:
  //       setState(() {
  //         routeBuilt = false;
  //       });
  //       break;
  //     case MapBoxEvent.navigation_running:
  //       setState(() {
  //         isNavigating = true;
  //       });
  //       break;
  //     case MapBoxEvent.on_arrival:
  //       if (!isMultipleStop) {
  //         await Future.delayed(Duration(seconds: 3));
  //         await controller.finishNavigation();
  //       } else {}
  //       break;
  //     case MapBoxEvent.navigation_finished:
  //       await getBookingByGroupId();
  //       Navigator.pop(context);
  //       break;
  //     case MapBoxEvent.navigation_cancelled:
  //       setState(() {
  //         routeBuilt = false;
  //         isNavigating = false;
  //       });
  //       break;
  //     case MapBoxEvent.user_off_route:
  //       onRecreateRoute(latlng);
  //       break;
  //     default:
  //       break;
  //   }
  //   setState(() {});
  // }

  // Future<void> getDuration() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //             desiredAccuracy: LocationAccuracy.best) ??
  //         await Geolocator.getLastKnownPosition();
  //     // dynamic resCycling = await Providers.getDetailNavigation(
  //     //     origin: Location(lat: position.latitude, lng: position.longitude),
  //         // destination: Location(
  //         //     lat: pickupPoints[0]['latitude'],
  //         //     lng: pickupPoints[0]['longitude']),
  //         // mode: 'cycling');
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
