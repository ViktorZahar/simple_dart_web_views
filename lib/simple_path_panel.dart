import 'package:simple_dart_web_widgets/abstract_component.dart';
import 'package:simple_dart_web_widgets/labels/simple_label.dart';
import 'package:simple_dart_web_widgets/labels/simple_link.dart';
import 'package:simple_dart_web_widgets/panel.dart';

import 'main_window.dart';
import 'view.dart';

class SimplePathPanel extends PanelComponent {
  SimplePathPanel() : super('SimplePathPanel') {
    fullWidth();
    stride = '5px';
  }

  void refreshPathPanel(View currentView) {
    clear();
    var lastParentView = currentView.parent;
    final viewsList = <View>[currentView];
    while (lastParentView != null) {
      viewsList.add(lastParentView);
      lastParentView = lastParentView.parent;
    }

    for (final view in viewsList.reversed) {
      if (children.isNotEmpty) {
        add(SimpleLabel()
          ..caption = '\\'
          ..width = '15px'
          ..horizontalAlign = 'center');
      }
      if (view is CustomPathPanelView) {
        add((view as CustomPathPanelView).getPathPanelComponent()
          ..viewPath = fullPathOfView(view));
      } else {
        add(SimplePathButton()
          ..viewPath = fullPathOfView(view)
          ..caption = view.caption);
      }
    }
  }
}

// ignore: one_member_abstracts
abstract class CustomPathPanelView {
  AbstractPathPanelComponent getPathPanelComponent();
}

abstract class AbstractPathPanelComponent extends Component {
  AbstractPathPanelComponent(String className) : super(className);
  String viewPath = '';
}

class SimplePathButton extends SimpleLink
    implements AbstractPathPanelComponent {
  SimplePathButton() {
    addCssClass('SimplePathButton');
    fullHeight();
  }

  @override
  String get viewPath => href;

  @override
  set viewPath(String _url) {
    href = '$_url';
  }
}
