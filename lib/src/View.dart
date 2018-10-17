part of 'views.dart';

/**
 * View component
 */

abstract class View {
  Element get nodeRoot;

  String getId();

  String getCaption();

  View getParentView();

  Map<String, String> getChindrenCaptions() {
    return {};
  }

  Future<View> getChildViewById(String id) async {
    return null;
  }

  void afterShow() {}

  void beforeShow() {}
}
