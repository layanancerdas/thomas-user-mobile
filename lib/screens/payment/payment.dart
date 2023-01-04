import 'package:flutter/material.dart';
import './payment_view.dart';

// ignore: must_be_immutable
class Payment extends StatefulWidget {
  final String mode;
  final int lastPrice;
  final bool goToFinish,  fromDeeplink;
  final Map dataNotif;

  Payment(
      {this.mode,
      this.goToFinish: false,
      this.fromDeeplink: false,
      this.dataNotif, this.lastPrice});

  @override
  PaymentView createState() => new PaymentView();
}
