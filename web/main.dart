import 'dart:async';
import 'dart:collection';
import 'dart:html';

import 'package:simple_dart_web_views/src/views.dart';
import 'package:simple_dart_web_widgets/src/widgets.dart';

part 'HomeView.dart';
part 'DialogExampleView.dart';

void main() {
  mainWindow.init(HomeView());
  querySelector('body').children.add(mainWindow.root);
}
