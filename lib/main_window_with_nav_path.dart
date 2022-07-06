import 'package:simple_dart_web_widgets/panel.dart';

import 'main_window.dart';
import 'simple_nav_bar.dart';
import 'simple_path_panel.dart';

class MainWindowWithNavPath extends MainWindow {
  SimpleNavBar simpleNavBar = SimpleNavBar();
  SimplePathPanel simplePathPanel = SimplePathPanel();

  @override
  void configureMainWindow() {
    add(simpleNavBar);
    final verticalPanel = Panel()
      ..vertical = true
      ..fullSize()
      ..fillContent = true;
    add(verticalPanel);
    refreshNavPanel();
    onViewChange.listen((currentView) {
      simpleNavBar.refreshNavBar(currentView);
      simplePathPanel.refreshPathPanel(currentView);
    });
    verticalPanel.addAll([simplePathPanel, display]);
  }

  void refreshNavPanel() {
    registeredViewsList.forEach((view) {
      simpleNavBar.addView(view);
    });
  }
}
