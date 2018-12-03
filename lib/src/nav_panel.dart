import 'dart:html';

import 'package:simple_dart_web_views/src/nav_panel_button.dart';
import 'package:simple_dart_web_views/src/views_theme.dart';

class NavPanel {
  NavPanel() {
    root.style
      ..flexDirection = 'row'
      ..flexShrink = '0'
      ..width = '100%'
      ..height = '50px';
    root.classes.add(ViewsTheme.navPanel);
    root.attributes['name'] = 'NavPanel';
  }

  DivElement root = DivElement();

  NavPanelButton addButton(String caption, {bool image = false}) {
    final ret = NavPanelButton();
    if (image) {
      ret.image = caption;
    } else {
      ret.caption = caption;
    }
    root.children.add(ret.root);
    return ret;
  }

  void clear() {
    root.children.clear();
  }
}
