import 'dart:async';
import 'dart:html';

import 'package:simple_dart_web_widgets/widgets.dart';

import '../views.dart';

MainWindow mainWindow = MainWindow();

class MainWindow extends HVPanel {
  MainWindow() {
    createUi();
  }

  Map<String, View> registeredViewsMap = <String, View>{};
  List<View> registeredViewsList = <View>[];

  HVPanel navMenuPanel = HVPanel()
    ..varName('navMenu')
    ..addCssClasses(['navMenu'])
    ..visible = false
    ..setPadding(5)
    ..setSpaceBetweenItems(5)
    ..vertical();

  HVPanel centralVerticalPanel = HVPanel()
    ..varName('centralVerticalPanel')
    ..fillContent()
    ..fullSize()
    ..vertical();

  TitlePanel titlePanel = TitlePanel()
    ..fullWidth()
    ..fillContent();
  HVPanel titleRightButtonsPanel = HVPanel()
    ..varName('titleRightButtonsPanel')
    ..addCssClasses(['titlePanel'])
    ..width = ''
    ..setPadding(2)
    ..setSpaceBetweenItems(2);

  HVPanel display = HVPanel()
    ..varName('display')
    ..vertical()
    ..fillContent()
    ..fullSize()
    ..nodeRoot.style.overflow = 'auto';

  View? currentView;
  View? homeView;

  void createUi() {
    nodeRoot.children.add(modalStatePanel.nodeRoot);
    final topPanel = HVPanel()
      ..varName('topPanel')
      ..fullWidth()
      ..addAll([titlePanel, titleRightButtonsPanel]);
    centralVerticalPanel.addAll([topPanel, display]);
    addAll([navMenuPanel, centralVerticalPanel]);
  }

  void init(View homeView) {
    this.homeView = homeView;
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
  }

  void _showView(View view) {
    currentView = view;
    if (display.children.isNotEmpty) {
      display.clear();
    }
    refreshTitlePanel();
    refreshLeftVerticalPanel();
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

  void refreshTitlePanel() {
    titlePanel.clear();
    var parentView = currentView!.getParentView();
    final views = <View>[currentView!];
    while (parentView != null) {
      views.add(parentView);
      parentView = parentView.getParentView();
    }

    for (final view in views.reversed) {
      titlePanel.addTitleButton(view.getTitleComponent());
    }
  }

  void refreshLeftVerticalPanel() {
    navMenuPanel.clear();
    for (final view in registeredViewsList) {
      final navMenuComponent = view.getNavMenuComponent();
      if (view == currentView) {
        navMenuComponent.addCssClasses(['navMenuSelected']);
      } else {
        navMenuComponent.addCssClasses(['navMenuButton']);
      }
      navMenuPanel.add(navMenuComponent);
    }
  }

  void showFatalError(String err) {
    modalStatePanel.onClick = () {
      window.location.assign('/');
    };
    modalStatePanel.visible = true;
    modalStatePanel.add(SimpleLabel()
      ..caption = err
      ..fontSize = 16);
  }

  void showError(String err) {
    modalStatePanel.onClick = () {
      modalStatePanel.visible = false;
    };
    modalStatePanel.visible = true;
    modalStatePanel.add(SimpleLabel()
      ..caption = err
      ..fontSize = 16);
  }

  void registerView(View view) {
    registeredViewsMap[view.getId()] = view;
    registeredViewsList.add(view);
  }
}
