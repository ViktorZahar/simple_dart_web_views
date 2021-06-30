import 'package:simple_dart_web_widgets/widgets.dart';

import 'nav_panel_button.dart';
import 'views_theme.dart';

class NavPanel extends HVPanel {
  NavPanel() {
    fullWidth();
    height = '50px';
    nodeRoot.classes.add(ViewsTheme.navPanel);
    varName('NavPanel');
  }

  NavPanelButton addButton(String caption, {bool isImage = false}) {
    final ret = NavPanelButton();
    if (isImage) {
      ret.image = caption;
    } else {
      ret.caption = caption;
    }
    add(ret);
    return ret;
  }
}
