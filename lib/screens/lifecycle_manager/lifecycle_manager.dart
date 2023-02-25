import 'package:flutter/material.dart';
import './lifecycle_manager_view.dart';

class LifecycleManager extends StatefulWidget {
  final Widget child;

  LifecycleManager(this.child);

  @override
  LifecycleManagerView createState() => new LifecycleManagerView();
  
  static LifecycleManagerView of(BuildContext context) =>
      context.findAncestorStateOfType<LifecycleManagerView>();
}
