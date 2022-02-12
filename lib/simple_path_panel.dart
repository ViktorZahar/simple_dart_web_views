import 'package:simple_dart_web_widgets/abstract_component.dart';
import 'package:simple_dart_web_widgets/hv_panel.dart';
import 'package:simple_dart_web_widgets/labels/simple_label.dart';
import 'package:simple_dart_web_widgets/labels/simple_link.dart';

import 'view.dart';

class SimplePathPanel extends HVPanel {
  SimplePathPanel() {
    fullWidth();
    stride = '5px';
  }

  void refreshPathPanel(View currentView) {
    clear();
    var parentView = currentView.getParentView();
    final viewsPath = <View>[currentView];
    while (parentView != null) {
      viewsPath.add(parentView);
      parentView = parentView.getParentView();
    }

    var url = '#';
    for (final view in viewsPath.reversed) {
      if (children.isNotEmpty) {
        add(SimpleLabel()
          ..caption = '\\'
          ..width = '15px'
          ..horizontalAlign = 'center');
        url += '/';
      }
      // ignore:use_string_buffers
      url += view.getId();
      if (view is CustomPathPanelView) {
        add(view.getPathPanelComponent()..url = url);
      } else {
        add(SimplePathButton()
          ..url = url
          ..caption = view.getCaption());
      }
    }
  }
}

abstract class CustomPathPanelView extends View {
  AbstractPathPanelComponent getPathPanelComponent();
}

abstract class AbstractPathPanelComponent extends Component {
  String url = '';
}

class SimplePathButton extends SimpleLink
    implements AbstractPathPanelComponent {
  SimplePathButton() {
    fullHeight();
  }

  @override
  String get url => href;

  @override
  set url(String _url) {
    href = _url;
  }
}
