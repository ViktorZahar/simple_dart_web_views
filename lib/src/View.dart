import 'dart:async';
import 'dart:html';

/// View component
mixin View {
  Element get nodeRoot;

  String getId();

  // getCaption возвращает заголовок
  String getCaption();

  bool captionIsImage() => false;

  View? getParentView();

  // getChindrenCaptions - возвращает мапу подчиненных вьюх {id, caption}
  Map<String, String> getChindrenCaptions() => {};

  Future<View?> getChildViewById(String id) async => null;

  void afterShow() {}

  void beforeShow() {}
}
