import 'dart:async';

import 'package:simple_dart_web_widgets/widgets.dart';

/// View component
abstract class View extends HVPanel {
  String getId();

  // getCaption возвращает заголовок
  String getCaption();

  bool captionIsImage() => false;

  View? getParentView();

  // getChindrenCaptions - возвращает мапу подчиненных вьюх {id, caption}
  Map<String, String> getChildrenCaptions() => {};

  Future<View?> getChildViewById(String id) async => null;

  void afterShow() {}

  void beforeShow() {}
}
