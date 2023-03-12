import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/configs/config.dart';
import 'package:tomas/helpers/custom_nomatim_service.dart' as nomatim;

class Providers {
  static String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$CLIENT_ID:$CLIENT_SECRET'));

  static Future signIn({String phoneNumber}) async {
    return Dio().post('$BASE_API/users/login',
        data: {'phone_number': phoneNumber},
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future signInWithLDAP(
      {String phoneNumber, String username, String password}) async {
    return Dio().post('$BASE_API/users/login/ldap',
        data: {
          'phone_number': phoneNumber,
          'username': username,
          'password': password
        },
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future signUp(
      {String name,
      String email,
      String divisionId,
      String mobileNo,
      String nip,
      String shiftType}) async {
    return Dio().post('$BASE_API/users',
        data: {
          "name": name,
          "email": email,
          "division_id": divisionId,
          "phone_number": mobileNo,
          "nip": nip,
          "shift_type": shiftType
        },
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future confirmOtp({String otp}) async {
    return Dio().post('$BASE_API/users/confirm_otp',
        data: {'otp': otp},
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future confirmLogin({String otp}) async {
    return Dio().post('$BASE_API/users/confirm_login',
        data: {'otp': otp},
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future uploadImage({File file}) async {
    String fileName = file.path.split('/').last;
    return Dio().post('$BASE_API/files',
        data: FormData.fromMap({
          "file": await MultipartFile.fromFile(file.path, filename: fileName),
        }),
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    return Dio().get('$BASE_API/users',
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getResolveDate() async {
    return Dio().get('$BASE_API/ajk/trips/resolve_date',
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future updateUser({String name, String photo, String nip}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    return Dio().put('$BASE_API/users',
        data: {"name": name, 'photo': photo, 'nip': nip},
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getDivision() async {
    return Dio().get('$BASE_API/users/divisions',
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getVouchers({int limit, int offset}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    return Dio().get('$BASE_API/payment/vouchers',
        queryParameters: {"limit": limit, "offset": offset},
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getVouchersById({String voucherId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    print('$BASE_API/payment/vouchers?voucher_id=$voucherId');

    return Dio().get('$BASE_API/payment/vouchers',
        queryParameters: {"voucher_id": voucherId},
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getAjkRoute() async {
    return Dio().get('$BASE_API/ajk/routes/all',
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getAjkRouteById({String routeId}) async {
    return Dio().get('$BASE_API/ajk/routes',
        queryParameters: {"route_id": routeId},
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getAjkRouteByLatLng(
      {nomatim.Location origin,
      nomatim.Location destination,
      double radius}) async {
    return Dio().get('$BASE_API/ajk/routes',
        queryParameters: {
          'origin_latitude': origin.lat,
          'origin_longitude': origin.lng,
          'radius': radius ?? 10,
          'destination_latitude': destination.lat,
          'destination_longitude': destination.lng,
        },
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getTripByRouteId({String id, startDate, endDate}) async {
    return Dio().get('$BASE_API/ajk/trips',
        queryParameters: {
          'route_id': id,
          'start_date': startDate,
          'end_date': endDate
        },
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future bookPackage({String tripGroupId, String pickupPointId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    return Dio().post('$BASE_API/ajk/booking',
        data: {
          "trip_group_id": tripGroupId,
          "pickup_point_id": pickupPointId,
          "voucher_id": null
        },
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future updateBooking({String bookingId, String status}) async {
    return Dio().put('$BASE_API/ajk/booking',
        data: {'booking_id': bookingId, 'status': status},
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future cancelBooking({String bookingId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    return Dio().put('$BASE_API/ajk/booking/cancel',
        data: {'booking_id': bookingId},
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getAllBooking({dynamic status, int limit, int offset}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    return Dio().get('$BASE_API/ajk/booking',
        queryParameters: {
          "status": status,
          "limit": limit,
          "offset": offset,
        },
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getBookingByTripId({String tripId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");
    return Dio().get('$BASE_API/ajk/booking',
        queryParameters: {"trip_id": tripId},
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getBookingByBookingId({String bookingId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");
    return Dio().get('$BASE_API/ajk/booking',
        queryParameters: {"booking_id": bookingId},
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future permitRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");
    print(jwtToken);

    return Dio().post('$BASE_API/ajk/permit_request',
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getPlaceMapbox(
      {String input,
      String language,
      int limit,
      Location location,
      String country}) {
    String url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$input.json?access_token=$ACCESS_TOKEN&cachebuster=1566806258853&autocomplete=true&language=$language&limit=$limit";
    if (location != null) {
      url += "&proximity=${location.lng}%2C${location.lat}";
    }
    if (country != null) {
      url += "&country=$country";
    }
    return Dio().get(url,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getDetailNavigation(
      {Location origin, Location destination, String mode}) {
    print(
        "https://api.mapbox.com/directions/v5/mapbox/$mode/${origin.lng},${origin.lat};${destination.lng},${destination.lat}?access_token=$ACCESS_TOKEN");
    return Dio().get(
        "https://api.mapbox.com/directions/v5/mapbox/$mode/${origin.lng},${origin.lat};${destination.lng},${destination.lat}?access_token=$ACCESS_TOKEN",
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getPaymentMethods({int limit: 50, int offset: 0}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    return Dio().get('$BASE_API/payment/payment_method',
        queryParameters: {"limit": limit, "offset": offset},
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getBalanceByUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    Map userData = JwtDecoder.decode(jwtToken);

    return Dio().get('$BASE_API/payment/balances',
        queryParameters: {"user_id": userData['user_id']},
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future reviewBooking(
      {String bookingId, int review, String desc}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    return Dio().put('$BASE_API/ajk/booking/give_review',
        data: {'booking_id': bookingId, 'rating': review, 'review': desc},
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getPaymentByInvoiceId({String invoiceId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    return Dio().get('$BASE_API/payment/pay',
        queryParameters: {"invoice_id": invoiceId},
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future paymentBooking(
      {String voucherId,
      String invoiceId,
      int balanceAmount,
      String paymentMethodId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    Map userData = JwtDecoder.decode(jwtToken);
    print(userData['user_id']);
    print({
      'user_id': userData['user_id'],
      'voucher_id': voucherId ?? null,
      'invoice_id': invoiceId,
      'balance_amount': balanceAmount,
      'pay_method': paymentMethodId
    });

    return Dio().post('$BASE_API/payment/pay',
        data: {
          'user_id': userData['user_id'],
          'voucher_id': voucherId ?? null,
          'invoice_id': invoiceId,
          'balance_amount': balanceAmount,
          'pay_method': paymentMethodId
        },
        options: Options(
            headers: {
              'authorization': basicAuth,
              'token': jwtToken,
              'service_secret_key': SERVICE_SECRET_KEY
            },
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future subscribeNotification(
      {String firebaseToken, String language}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    Map userData = JwtDecoder.decode(jwtToken);
    print({
      'user_id': userData['user_id'],
      'firebase_token': firebaseToken,
      'actor': "USER",
      'language': language ?? "ENGLISH"
    });

    return Dio().post('$BASE_API/notification/subscribers',
        data: {
          'user_id': userData['user_id'],
          'firebase_token': firebaseToken,
          'language': language ?? "ENGLISH"
        },
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getNotifByUserId({int limit, int offset}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    Map userData = JwtDecoder.decode(jwtToken);

    return Dio().get('$BASE_API/notification/notifications',
        queryParameters: {
          'user_id': userData['user_id'],
          "limit": limit ?? 10,
          "offset": offset ?? 0,
        },
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future updateNotif({List notif}) async {
    // Map on List model
    // String notifId, bool isRead, bool isActive

    return Dio().put('$BASE_API/notification/notifications',
        data: notif,
        options: Options(
            headers: {'authorization': basicAuth},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }

  static Future getTripOrderById({String tripOrderId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString("jwtToken");

    return Dio().get('$BASE_API/ajk/trip_order',
        queryParameters: {'trip_order_id': tripOrderId},
        options: Options(
            headers: {'authorization': basicAuth, 'token': jwtToken},
            followRedirects: false,
            validateStatus: (status) {
              return status < 1000;
            }));
  }
}
