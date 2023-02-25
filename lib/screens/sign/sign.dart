import 'package:flutter/material.dart';
import './sign_view.dart';

class Sign extends StatefulWidget {
  final String mode;

  Sign({this.mode});

  @override
  SignView createState() => new SignView();
}
