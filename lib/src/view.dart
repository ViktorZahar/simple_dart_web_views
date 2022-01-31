import 'dart:async';

import 'package:simple_dart_web_widgets/widgets.dart';

/// View component
abstract class View extends HVPanel {
  String getId();

  String getCaption();

  View? getParentView() => null;

  Map<String, String> getChildrenCaptions() => {};

  Future<View?> getChildViewById(String id) async => null;

  void afterShow() {}

  void beforeShow() {}

  Component getTitleComponent() => SimpleLink()
    ..caption = getCaption()
    ..addCssClasses(['titleComponent'])
    ..href = '#${getId()}';

  Component getNavMenuComponent() => SimpleLink()
    ..type = SimpleButtonType.noStyle
    ..caption = getCaption()
    ..href = '#${getId()}';
}
