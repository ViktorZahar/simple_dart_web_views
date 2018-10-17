part of 'views.dart';

class NavPanel {
  DivElement root = new DivElement();

  NavPanel() {
    root.style
      ..flexDirection = 'row'
      ..flexShrink = '0'
      ..width = '100%'
      ..height = '50px';
    root.classes.add(ViewsTheme.navPanel);
    root.attributes["name"] = 'NavPanel';
  }

  NavPanelButton addButton(String caption) {
    NavPanelButton ret = new NavPanelButton();
    ret.caption = caption;
    root.children.add(ret.root);
    return ret;
  }

  void clear() {
    root.children.clear();
  }
}
