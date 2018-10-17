part of 'main.dart';

class DialogExampleView extends StandartView {
  static const String ID = 'dialogExample';
  static const String CAPTION = 'Dialog example';

  CustomDialogWindow customDialogWindow = new CustomDialogWindow();

  DialogExampleView(parentView) : super(parentView) {
    dartClassName('DialogExampleView');
  }

  String getId() {
    return ID;
  }

  @override
  String getCaption() {
    return CAPTION;
  }

  @override
  void afterShow() {}

  @override
  fillControlPanel(HVPanel controlPanel) {
    SimpleButton openCustomDiapogButton = new SimpleButton();
    openCustomDiapogButton.caption = 'Open custom dialog';
    openCustomDiapogButton.onClick(openCustomDiapog);
    controlPanel.add(openCustomDiapogButton);
  }

  @override
  fillViewContent(HVPanel viewContent) {}

  openCustomDiapog(event) {
    customDialogWindow.showDialog();
  }
}

class CustomDialogWindow extends DialogWindow {
  CustomDialogContent() {}

  @override
  String caption() {
    return 'Custom dialog window!';
  }

  @override
  Component createDialogContent() {
    HVPanel hvPanel = new HVPanel();
    SimpleButton button = new SimpleButton();
    button.caption = 'wdwdwdwd';
    hvPanel.add(button);
    return hvPanel;
  }
}
