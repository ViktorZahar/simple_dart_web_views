import 'package:simple_dart_web_widgets/abstract_component.dart';
import 'package:simple_dart_web_widgets/labels/simple_link.dart';
import 'package:simple_dart_web_widgets/mixins.dart';
import 'package:simple_dart_web_widgets/panel.dart';

import 'main_window.dart';
import 'view.dart';

class SimpleNavBar extends PanelComponent {
  SimpleNavBar() : super('SimpleNavBar') {
    fullHeight();
    stride = '5px';
    vertical = true;
  }

  void addView(View newView) {
    if (newView.isChild) {
      return;
    }
    if (newView is CustomNavBarView) {
      add(newView.getNavBarComponent());
    } else {
      final navBarButton = SimpleNavBarButton()
        ..viewPath = newView.id
        ..caption = newView.caption
        ..href = fullPathOfView(newView);
      add(navBarButton);
    }
  }

  void refreshNavBar(View currentView) {
    final viewPath = fullPathOfView(currentView);
    for (final navBarComponent in children) {
      if (navBarComponent is AbstractNavBarComponent) {
        navBarComponent.active =
            viewPath.startsWith('#${navBarComponent.viewPath}');
      }
    }
  }
}

abstract class AbstractNavBarComponent extends Component with MixinActivate {
  AbstractNavBarComponent(String className) : super(className);

  String get viewPath;
}

abstract class CustomNavBarView extends View {
  CustomNavBarView(String className) : super(className);

  AbstractNavBarComponent getNavBarComponent();
}

class SimpleNavBarButton extends SimpleLink implements AbstractNavBarComponent {
  SimpleNavBarButton() {
    addCssClass('SimpleNavBarButton');
  }

  @override
  String viewPath = '';
}
