import 'dart:async';
import 'dart:html';

import 'package:simple_dart_web_views/views.dart';
import 'package:simple_dart_web_widgets/widgets.dart';

import 'dialog_example_view.dart';

class HomeView extends View {
  HomeView() {
    final viewContnet = HVPanel()..vertical();

    nodeRoot = viewContnet.nodeRoot;
    final header = HeadingElement.h1()..text = 'Home';
    viewContnet.nodeRoot.children.add(header);
    final buttons = HVPanel();
    final dialogExampleButton = SimpleButton()
      ..caption = 'Dialog example'
      ..onClick((event) {
        dialogExampleView ??= DialogExampleView(this);
        mainWindow.openView(dialogExampleView);
      });
    buttons.add(dialogExampleButton);
    viewContnet.add(buttons);
  }

  @override
  Element nodeRoot;
  DialogExampleView dialogExampleView;

  @override
  Map<String, String> getChindrenCaptions() {
    final ret = <String, String>{};
    ret[DialogExampleView.id] = DialogExampleView.caption;
    return ret;
  }

  @override
  String getId() => '';

  @override
  String getCaption() => 'Home';

  @override
  View getParentView() => null;

  @override
  void afterShow() {}

  @override
  Future<View> getChildViewById(String id) async {
    switch (id) {
      case DialogExampleView.id:
        return DialogExampleView(this);
        break;
    }
    throw Exception('Unknown view');
  }
}
