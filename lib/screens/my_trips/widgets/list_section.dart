import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/user_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/redux/modules/user_state.dart';
import 'package:tomas/widgets/card_list.dart';
import 'package:tomas/widgets/card_trips.dart';
import 'package:tomas/widgets/no_trips.dart';
import 'package:tomas/localization/app_translations.dart';

class ListSection extends StatefulWidget {
  @override
  _ListSectionState createState() => _ListSectionState();
}

class _ListSectionState extends State<ListSection> {
  Store<AppState> store;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<void> onLoading() async {
    try {
      dynamic res = await Providers.getAllBooking(
          status: "PENDING",
          limit: store.state.userState.limitPendingTrip + 10,
          offset: store.state.userState.pendingTrip.length);

      if (res.data['data'].length > 0 &&
          (res.data['code'] == '00' || res.data['code'] == 'SUCCESS')) {
        await store.dispatch(SetPendingTrip(pendingTrip: [
          ...store.state.userState.pendingTrip,
          ...res.data['data']
        ], limitPendingTrip: store.state.userState.limitPendingTrip + 10));
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (e) {
      print("onLoading Pending:");
      print(e);
    }
  }

  Future<void> onRefresh() async {
    try {
      dynamic res = await Providers.getAllBooking(
          status: "PENDING", limit: 10, offset: 0);

      if (res.data['data'].length > 0 &&
          (res.data['code'] == '00' || res.data['code'] == 'SUCCESS')) {
        await store.dispatch(SetPendingTrip(
            pendingTrip: res.data['data'], limitPendingTrip: 10));
        refreshController.refreshCompleted();
      } else {
        refreshController.refreshToIdle();
      }
    } catch (e) {
      print("onRefresh Pending:");
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

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: refreshController,
        // enablePullUp: state.pendingTrip.length > 0 ?? false,
        enablePullDown: true,
        onLoading: onLoading,
        onRefresh: onRefresh,
        header: ClassicHeader(),
        footer: ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            CardList(
              pointA: 'terminal',
              pointB: 'kantor',
            ),
            CardList(
              pointA: 'terminal',
              pointB: 'kantor',
            ),
          ],
        ));
  }
}
