import 'package:simple_dart_web_widgets/abstract_component.dart';
import 'package:simple_dart_web_widgets/hv_panel.dart';
import 'package:simple_dart_web_widgets/labels/simple_link.dart';
import 'package:simple_dart_web_widgets/mixins.dart';

import 'view.dart';

class SimpleNavBar extends HVPanel {
  SimpleNavBar() {
    fullHeight();
    stride = '5px';
    vertical = true;
  }

  void addView(View newView) {
    if (newView is CustomNavBarView) {
      add(newView.getNavBarComponent());
    } else {
      final navBarButton = SimpleNavBarButton()
        ..viewId = newView.getId()
        ..caption = newView.getCaption()
        ..href = '#${newView.getId()}';
      add(navBarButton);
    }
  }

  void refreshNavBar(View currentView) {
    final viewId = currentView.getId();
    for (final navBarComponent in children) {
      if (navBarComponent is AbstractNavBarComponent) {
        navBarComponent.active = viewId == navBarComponent.viewId;
      }
    }
  }
}

abstract class AbstractNavBarComponent extends Component with MixinActivate {
  String get viewId;
}

abstract class CustomNavBarView extends View {
  AbstractNavBarComponent getNavBarComponent();
}

class SimpleNavBarButton extends SimpleLink implements AbstractNavBarComponent {
  @override
  String viewId = '';
}
