import 'package:flutter/material.dart';
import './payment_confirmation_view.dart';

class PaymentConfirmation extends StatefulWidget {
  final bool goToFinish;

  PaymentConfirmation({ this.goToFinish: false});

  @override
  PaymentConfirmationView createState() => new PaymentConfirmationView();
}
