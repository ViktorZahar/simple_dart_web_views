import 'dart:async';
import 'dart:html';

/// View component

abstract class View {
  Element get nodeRoot;

  String getId();

  String getCaption();

  bool captionIsImage() => false;

  View getParentView();

  Map<String, String> getChindrenCaptions() => {};

  Future<View> getChildViewById(String id) async => null;

  void afterShow() {}

  void beforeShow() {}
}
