import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/ajk_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/search_ajk_shuttle/widgets/choose_pickup_point.dart';
import './search_ajk_shuttle.dart';

abstract class SearchAjkShuttleViewModel extends State<SearchAjkShuttle> {
  Store<AppState> store;
  final TextEditingController searchController = TextEditingController();

  List routes = [];

  bool isLoading = true;

  void toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void onClear() {
    setState(() {
      searchController.text = "";
    });
  }

  void onSearchRoute(String value) {
    print("something");
    setState(() {});
    List _routesTemp = [];
    store.state.ajkState.routes.forEach((element) {
      element['pickup_points'].forEach((e) {
        if (e['name'].toLowerCase().contains(value.toLowerCase()) ||
            element['destination_name']
                .toLowerCase()
                .contains(value.toLowerCase())) {
          print("suaper");
          if (!_routesTemp.contains(element)) {
            _routesTemp.add(element);
          }
        }
      });
    });
    setState(() {
      routes = _routesTemp;
    });
  }

  void onClickResult(data) {
    store.dispatch(SetSelectedRoute(selectedRoute: data));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ChoosePickupPoint(), fullscreenDialog: true));
  }

  Future<void> getAllRoute() async {
    try {
      dynamic res = await Providers.getAjkRoute();
      List _data = res.data['data'] as List;

      List _temp = _data.where((element) => element['is_active']).toList();

      _temp.sort((a, b) => a['pickup_points'][0]['name']
          .compareTo(b['pickup_points'][0]['name']));

      store.dispatch(SetRoutes(routes: _temp));
    } catch (e) {
      print(e.toString());
    } finally {
      toggleLoading(false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
      getAllRoute();
    });
  }
}
