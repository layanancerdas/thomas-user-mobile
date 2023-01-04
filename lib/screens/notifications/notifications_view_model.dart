import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/actions/general_action.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/lifecycle_manager/lifecycle_manager.dart';
import './notifications.dart';

abstract class NotificationsViewModel extends State<Notifications> {
  Store<AppState> store;
  List selected = List();

  bool disableShow = false;

  Future<void> onShowMore() async {
    try {
      dynamic res = await Providers.getNotifByUserId(
          limit: store.state.generalState.limitNotif + 10,
          offset: store.state.generalState.notifications.length);

      if (res.data['data'].length > 0 &&
          (res.data['code'] == '00' || res.data['code'] == 'SUCCESS')) {
        store.dispatch(SetNotifications(notifications: [
          ...store.state.generalState.notifications,
          ...res.data['data']
        ], limitNotif: store.state.generalState.limitNotif + 10));

        setState(() {
          disableShow = false;
        });
      } else {
        setState(() {
          disableShow = true;
        });
      }
    } catch (e) {
      print("vouchers");
      print(e);
    }
  }

  void onClearSelected() {
    setState(() {
      selected = [];
    });
  }

  Future<void> onUpdate(String type) async {
    store.dispatch(SetIsLoading(isLoading: true));
    try {
      List _temp = selected.map((e) {
        return {
          "notification_id": e['notification_id'],
          'is_read': true,
          'is_active': type == 'delete' ? false : true
        };
      }).toList();

      dynamic res = await Providers.updateNotif(notif: _temp);

      if (res.data['code'] == '00' || res.data['code'] == 'SUCCESS') {
        await LifecycleManager.of(context).getNotifications();
        setState(() {
          selected = [];
        });
        if (type != 'read') {
          store.dispatch(SetDisableNavbar(
              disableNavbar: !store.state.generalState.disableNavbar));
        }
      }
    } catch (e) {
      print(e);
    } finally {
      store.dispatch(SetIsLoading(isLoading: false));
    }
  }

  void onSelectAll() {
    setState(() {
      if (selected.length == store.state.generalState.notifications.length) {
        selected = [];
      } else {
        selected = store.state.generalState.notifications;
      }
    });
  }

  void onSelect(Map data) {
    setState(() {
      if (selected.contains(data)) {
        selected.remove(data);
      } else {
        selected.add(data);
      }
    });
  }

  void toggleMoreMode() {
    if (store.state.generalState.disableNavbar) {
      onClearSelected();
    }
    store.dispatch(SetDisableNavbar(
        disableNavbar: !store.state.generalState.disableNavbar));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
    });
  }
}
