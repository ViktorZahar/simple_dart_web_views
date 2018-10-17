part of 'main.dart';

class HomeView extends View {
  Element nodeRoot;
  DialogExampleView dialogExampleView;

  HomeView() {
    HVPanel viewContnet = new HVPanel();
    viewContnet.vertical();
    nodeRoot = viewContnet.nodeRoot;
    HeadingElement header = HeadingElement.h1();
    header.text = 'Home';
    viewContnet.nodeRoot.children.add(header);
    HVPanel buttons = new HVPanel();
    SimpleButton dialogExampleButton = new SimpleButton();
    dialogExampleButton.caption = 'Dialog example';
    dialogExampleButton.onClick((event) {
      if (dialogExampleView == null) {
        dialogExampleView = new DialogExampleView(this);
      }
      mainWindow.openView(dialogExampleView);
    });
    buttons.add(dialogExampleButton);
    viewContnet.add(buttons);
  }

  @override
  Map<String, String> getChindrenCaptions() {
    LinkedHashMap<String, String> ret = new LinkedHashMap();
    ret[DialogExampleView.ID] = DialogExampleView.CAPTION;
    return ret;
  }

  @override
  String getId() {
    return '';
  }

  @override
  String getCaption() {
    return 'Home';
  }

  @override
  View getParentView() {
    return null;
  }

  @override
  void afterShow() {}

  @override
  Future<View> getChildViewById(String id) async {
    switch (id) {
      case DialogExampleView.ID:
        return new DialogExampleView(this);
        break;
    }
    throw new Exception("Unknown view");
  }
}
