import 'package:simple_dart_web_views/views.dart';
import 'package:simple_dart_web_widgets/widgets.dart';

class DialogExampleView extends StandartView {
  DialogExampleView(parentView) : super(parentView) {
    dartClassName('DialogExampleView');
  }

  static const String id = 'dialogExample';
  static const String caption = 'Dialog example';

  CustomDialogWindow customDialogWindow = CustomDialogWindow();

  @override
  String getId() => id;

  @override
  String getCaption() => caption;

  @override
  void afterShow() {}

  @override
  void fillControlPanel(HVPanel controlPanel) {
    final openCustomDiapogButton = SimpleButton()
      ..caption = 'Open custom dialog'
      ..onClick(openCustomDiapog);
    controlPanel.add(openCustomDiapogButton);
  }

  @override
  void fillViewContent(HVPanel viewContent) {}

  void openCustomDiapog(event) {
    customDialogWindow.showDialog();
  }
}

class CustomDialogWindow extends DialogWindow {
  @override
  String caption() => 'Custom dialog window!';

  @override
  Component createDialogContent() {
    final hvPanel = HVPanel();
    final button = SimpleButton()..caption = 'wdwdwdwd';
    hvPanel.add(button);
    return hvPanel;
  }
}
