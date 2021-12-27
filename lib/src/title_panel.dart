import 'package:simple_dart_web_widgets/widgets.dart';

import '../views.dart';
import 'views_theme.dart';

class TitlePanel extends HVPanel {
  TitlePanel() {
    fullWidth();
    height = '40px';
    nodeRoot.classes.add(ViewsTheme.titlePanel);
    align='center';
    setPadding(5);
    setSpaceBetweenItems(5);
    varName('titlePanel');
  }

  void addTitleButton(Component viewTitleComponent) {
    add(viewTitleComponent);
  }
}
