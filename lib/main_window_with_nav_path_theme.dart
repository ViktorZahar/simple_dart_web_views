import 'package:simple_dart_web_widgets/fields/select_field.dart';
import 'package:simple_dart_web_widgets/labels/simple_label.dart';
import 'package:simple_dart_web_widgets/panel.dart';
import 'package:simple_dart_web_widgets/theme_controller.dart';

import 'main_window.dart';
import 'simple_nav_bar.dart';
import 'simple_path_panel.dart';

class MainWindowWithNavPathTheme extends MainWindow {
  Panel topPanel = Panel()
    ..addCssClass('SimplePathPanel')
    ..fullWidth()
    ..stride = '5px'
    ..height = '45px'
    ..padding = '5px'
    ..align = 'center';
  SimpleNavBar simpleNavBar = SimpleNavBar();
  SimplePathPanel simplePathPanel = SimplePathPanel()..fillContent = true;
  SelectField selectTheme = SelectField()
    ..initOptions(themeController.themeList)
    ..height = '23px';

  @override
  void configureMainWindow() {
    add(simpleNavBar);
    final verticalPanel = Panel()
      ..vertical = true
      ..fullSize()
      ..fillContent = true;
    add(verticalPanel);
    registeredViewsList.forEach((view) {
      simpleNavBar.addView(view);
    });
    onViewChange.listen((currentView) {
      simpleNavBar.refreshNavBar(currentView);
      simplePathPanel.refreshPathPanel(currentView);
    });
    topPanel.addAll(
        [simplePathPanel, SimpleLabel()..caption = 'theme', selectTheme]);
    verticalPanel.addAll([topPanel, display]);

    selectTheme.onValueChange.listen((event) {
      themeController.switchTheme(event.newValue.first.replaceAll(' ', '_'));
    });
    themeController.loadLocalTheme();
    selectTheme.value = [themeController.currentTheme.replaceAll('_', ' ')];
  }
}
