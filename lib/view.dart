import 'dart:async';

import 'package:simple_dart_web_widgets/hv_panel.dart';

/// View component
abstract class View extends HVPanel {
  String getId();

  String getCaption();

  View? getParentView() => null;

  Map<String, String> getChildrenCaptions() => {};

  Future<View?> getChildViewById(String id) async => null;

  void afterShow() {}

  void beforeShow() {}
}
