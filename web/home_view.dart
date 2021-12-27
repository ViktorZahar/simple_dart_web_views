import 'dart:async';

import 'package:simple_dart_web_views/views.dart';
import 'package:simple_dart_web_widgets/widgets.dart';

import 'dialog_example_view.dart';

class HomeView extends View {
  HomeView() {
    vertical();

    final buttons = HVPanel();
    final dialogExampleButton = SimpleButton()
      ..caption = 'Dialog example'
      ..onClick((event) {
        dialogExampleView = DialogExampleView(this);
        mainWindow.openView(dialogExampleView!);
      });
    buttons.add(dialogExampleButton);
    add(buttons);
  }

  DialogExampleView? dialogExampleView;

  @override
  Map<String, String> getChildrenCaptions() {
    final ret = <String, String>{};
    ret[DialogExampleView.id] = DialogExampleView.caption;
    return ret;
  }

  @override
  String getId() => '';

  @override
  String getCaption() => 'Home';

  @override
  View? getParentView() => null;

  @override
  void afterShow() {}

  @override
  Future<View?> getChildViewById(String id) async {
    switch (id) {
      case DialogExampleView.id:
        return DialogExampleView(this);
    }
    throw Exception('Unknown view');
  }
}
