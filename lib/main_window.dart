import 'dart:async';
import 'dart:html';

import 'package:simple_dart_web_widgets/hv_panel.dart';
import 'package:simple_dart_web_widgets/labels/simple_label.dart';
import 'package:simple_dart_web_widgets/modal_state_panel.dart';

import 'view.dart';

class MainWindow extends HVPanel {
  MainWindow() {
    fullSize();
    fillContent();
  }

  Map<String, View> registeredViewsMap = <String, View>{};
  List<View> registeredViewsList = <View>[];

  HVPanel display = HVPanel()
    ..varName('display')
    ..vertical = true
    ..fillContent()
    ..fullSize()
    ..nodeRoot.style.overflow = 'auto';

  View? currentView;
  View? homeView;

  // ignore:close_sinks
  final StreamController<View> _onViewChange = StreamController<View>();

  // ignore:close_sinks
  final StreamController<View> _onRegisterView = StreamController<View>();

  Stream<View> get onViewChange => _onViewChange.stream;

  Stream<View> get onRegisterView => _onRegisterView.stream;

  void switchTheme(String themeName) {
    final linkElements = querySelectorAll('link');
    final headElement = querySelector('head')!;
    final themeElement = linkElements.singleWhere((element) {
      if (element is LinkElement) {
        if (element.href.endsWith('_theme.css')) {
          return true;
        }
      }
      return false;
    }, orElse: () {
      final newElem = LinkElement()..rel = 'stylesheet';
      headElement.children.add(newElem);
      return newElem;
    });
    if (themeElement is LinkElement) {
      themeElement.href = '${themeName}_theme.css';
    }
  }

  void init(View homeView, {theme = 'default', nodeSelector = 'body'}) {
    this.homeView = homeView;
    configureMainWindow();
    switchTheme(theme);
    window.onHashChange.listen((event) {
      if (event is HashChangeEvent) {
        if (event.newUrl != event.oldUrl) {
          openPath(window.location.hash.replaceFirst('#', ''));
        }
      }
    });
    if (window.location.hash.isEmpty) {
      _showView(homeView);
    } else {
      final openUrl = window.location.hash.replaceFirst('#', '');
      openPath(openUrl);
    }
    nodeRoot.children.add(modalStatePanel.nodeRoot);
    querySelector(nodeSelector)?.children.add(nodeRoot);
  }

  void configureMainWindow() {}

  void _showView(View view) {
    currentView = view;
    if (display.children.isNotEmpty) {
      display.clear();
    }
    _onViewChange.sink.add(view);
    view.beforeShow();
    display.add(view);
    view.afterShow();
  }

  void openView(View view) {
    var newHash = '';
    var iterateView = view;
    var parentView = iterateView.getParentView();
    while (parentView != null) {
      if (newHash.isEmpty) {
        newHash = iterateView.getId();
      } else {
        newHash = '${iterateView.getId()}/$newHash';
      }
      iterateView = parentView;
      parentView = iterateView.getParentView();
    }
    window.location.hash = newHash;
  }

  void openPath(String path) {
    getViewByPath(path).then(_showView);
  }

  Future<View> getViewByPath(String path) async {
    final viewIds = path.split('/');
    final rootId = viewIds.removeAt(0);
    final rootView = registeredViewsMap[rootId];
    var pathView = rootView;
    for (final viewId in viewIds) {
      if (pathView != null && viewId.isNotEmpty) {
        pathView = await pathView.getChildViewById(viewId);
      }
    }
    if (pathView == null) {
      throw Exception('View by path "$path" not found');
    }
    return pathView;
  }

  void showFatalError(String err) {
    modalStatePanel.onClick.listen((event) {
      window.location.assign('/');
    });
    modalStatePanel.visible = true;
    modalStatePanel.add(SimpleLabel()..caption = err);
  }

  void showError(String err) {
    modalStatePanel.onClick.listen((event) {
      modalStatePanel.visible = false;
    });
    modalStatePanel.visible = true;
    modalStatePanel.add(SimpleLabel()..caption = err);
  }

  void registerView(View view) {
    registeredViewsMap[view.getId()] = view;
    registeredViewsList.add(view);
    _onRegisterView.sink.add(view);
  }
}
