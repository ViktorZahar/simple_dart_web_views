part of 'views.dart';

abstract class StandartView extends HVPanel with View {
  final View parent;
  HVPanel controlPanel;
  HVPanel viewContent;

  StandartView(this.parent) {
    vertical();
    fillContent();
    controlPanel = new HVPanel()
      ..addCssClasses([ViewsTheme.controlPanel])
      ..setPadding(5)
      ..height = '30px'
      ..setSpaceBetweenItems(5)
      ..varName("controlPanel")
      ..addCssClasses([ViewsTheme.viewBackground]);
    fillControlPanel(controlPanel);
    viewContent = new HVPanel()
      ..vertical()
      ..fillContent()
      ..varName("viewContent")
      ..scrollable();
    fillViewContent(viewContent);
    dartClassName('StandartView');
    addAll([controlPanel, viewContent]);
  }

  @override
  View getParentView() {
    return parent;
  }

  fillControlPanel(HVPanel controlPanel) {}
  fillViewContent(HVPanel viewContent) {}
}
