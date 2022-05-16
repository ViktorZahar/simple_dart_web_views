import 'dart:async';

import 'package:simple_dart_web_widgets/panel.dart';

// Abstract View
abstract class View extends PanelComponent {
  View(String className) : super(className);

  String id = '';
  String caption = '';
  Map<String, String> params = <String, String>{};
  Map<String, String> state = <String, String>{};

  View? parent;

  bool isChild = false;

  Future<void> init() async {
  }

  void afterShow() {}

  void beforeShow() {}
}
