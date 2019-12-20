import 'package:simple_dart_web_widgets/widgets.dart';
import '../views.dart';


// StandartView - стандартный view c контрольной панелью
abstract class StandartView extends HVPanel with View {
  StandartView(this.parent) {
    vertical();
    fillContent();
    controlPanel
      ..addCssClasses([ViewsTheme.controlPanel])
      ..setPadding(5)
      ..height = '30px'
      ..setSpaceBetweenItems(5)
      ..varName('controlPanel')
      ..addCssClasses([ViewsTheme.viewBackground]);
    fillControlPanel(controlPanel);
    viewContent
      ..vertical()
      ..fillContent()
      ..varName('viewContent')
      ..scrollable();
    fillViewContent(viewContent);
    dartClassName('StandartView');
    addAll([controlPanel, viewContent]);
  }
  final View parent;
  final HVPanel controlPanel = HVPanel();
  final HVPanel viewContent = HVPanel();


  @override
  View getParentView() => parent;

  void fillControlPanel(HVPanel controlPanel) {}
  void fillViewContent(HVPanel viewContent) {}
}
