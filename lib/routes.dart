import 'package:flutter/material.dart';

import 'screens/contact_us/contact_us.dart';
import 'screens/faq/faq.dart';
import 'screens/language/language.dart';
import 'screens/plan_trip/plan_trip.dart';
import 'screens/detail_trip/detail_trip.dart';
import 'screens/home/home.dart';
import 'screens/live_tracking/live_tracking.dart';
import 'screens/notifications/notifications.dart';
import 'screens/payment/payment.dart';
import 'screens/payment_confirmation/payment_confirmation.dart';
import 'screens/profile/profile.dart';
import 'screens/review/review.dart';
import 'screens/search_trip/search_trip.dart';
import 'screens/search_trip_picker/search_trip_picker.dart';
import 'screens/shuttle_details/shuttle_details.dart';
import 'screens/profile_edit/profile_edit.dart';
import 'screens/round_trip/round_trip.dart';
import 'screens/search_ajk_shuttle/search_ajk_shuttle.dart';
import 'screens/sign/sign.dart';
import 'screens/landing/landing.dart';
import 'screens/sign_up/sign_up.dart';
import 'screens/verify_otp/verify_otp.dart';
import 'screens/vouchers/vouchers.dart';

final Map<String, WidgetBuilder> routes = {
  '/Landing': (BuildContext context) => Landing(),
  '/Sign': (BuildContext context) => Sign(),
  '/SignUp': (BuildContext context) => SignUp(),
  '/VerifyOtp': (BuildContext context) => VerifyOtp(),
  '/Home': (BuildContext context) => Home(),
  '/Profile': (BuildContext context) => Profile(),
  '/ProfileEdit': (BuildContext context) => ProfileEdit(),
  '/SearchAjkShuttle': (BuildContext context) => SearchAjkShuttle(),
  '/RoundTrip': (BuildContext context) => RoundTrip(),
  '/ShuttleDetails': (BuildContext context) => ShuttleDetails(),
  '/PaymentConfirmation': (BuildContext context) => PaymentConfirmation(),
  '/Payment': (BuildContext context) => Payment(),
  '/ContactUs': (BuildContext context) => ContactUs(),
  '/DetailTrip': (BuildContext context) => DetailTrip(),
  '/LiveTracking': (BuildContext context) => LiveTracking(),
  '/Notifications': (BuildContext context) => Notifications(),
  '/Review': (BuildContext context) => Review(),
  '/Vouchers': (BuildContext context) => Vouchers(),
  '/SearchTrip': (BuildContext context) => SearchTrip(),
  '/SearchTripPicker': (BuildContext context) => SearchTripPicker(),
  '/PlanTrip': (BuildContext context) => PlanTrip(),
  '/Faq': (BuildContext context) => Faq(),
  '/Language': (BuildContext context) => Language(),
};
