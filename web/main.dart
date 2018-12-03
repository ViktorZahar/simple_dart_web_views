import 'dart:html';

import 'package:simple_dart_web_views/views.dart';

import 'home_view.dart';

export 'dialog_example_view.dart';

void main() {
  mainWindow.init(HomeView());
  querySelector('body').children.add(mainWindow.root);
}
