import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/screens/failed_payment/screen/failed_payment.dart';
import 'package:tomas/screens/home/home.dart';
import 'package:crypto/crypto.dart';
import 'package:tomas/screens/success_payment/screen/success_payment.dart';
import 'package:uuid/uuid.dart';

class SubscribeTripController extends GetxController {
  // Store<AppState> store;
  List dataSubscribe = [].obs;
  RxBool isLoading = false.obs;

  toggleLoading(bool value) {
    isLoading.value = value;
  }

  Future<void> getSubscribeByRoutesId(routesId) async {
    // print(store.state.ajkState.selectedRoute['route_id']);
    toggleLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");
    Dio dio = Dio();
    var url = BASE_API + "/ajk/subscription";
    var params = {"routes_id": routesId};
    final response = await dio.get(
      url,
      queryParameters: params,
      options: Options(
        headers: {'authorization': Providers.basicAuth, 'token': jwtToken},
        followRedirects: false,
        validateStatus: (status) {
          return status <= 500;
        },
      ),
    );
    print(response.data);
    if (response.data['code'] == 'SUCCESS') {
      dataSubscribe = response.data['data']['data'];
      toggleLoading(false);
    } else {
      toggleLoading(false);
    }
  }
}
