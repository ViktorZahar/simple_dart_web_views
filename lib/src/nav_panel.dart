import 'dart:html';

import 'nav_panel_button.dart';
import 'views_theme.dart';

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
