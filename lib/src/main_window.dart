import 'dart:async';
import 'dart:html';

import 'package:simple_dart_web_views/views.dart';

MainWindow mainWindow = MainWindow();

class MainWindow {
  MainWindow() {
    root = DivElement();
    root.style
      ..width = '100%'
      ..height = '100%'
      ..display = 'flex'
      ..justifyContent = 'center'
      ..flexDirection = 'column';

    navPanel = NavPanel();

    display = DivElement();
    display.style
      ..width = '100%'
      ..height = '100%'
      ..flexDirection = 'column';

    root.children.add(navPanel.root);
    root.children.add(display);
  }
  DivElement root;
  NavPanel navPanel;
  DivElement display;
  View currentView;
  View homeView;

  void init(View homeView) {
    this.homeView = homeView;
    window.onHashChange.listen((event) {
      final HashChangeEvent hashChangeEvent = event;
      if (hashChangeEvent.newUrl != hashChangeEvent.oldUrl) {
        openPath(window.location.hash.replaceFirst('#', ''));
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
      display.children.removeLast();
    }
    refreshNavPanel();
    view.beforeShow();
    display.children.add(view.nodeRoot);
    view.afterShow();
  }

  void openView(View view) {
    var newHash = '';
    var iterateView = view;
    while (iterateView.getParentView() != null) {
      if (newHash.isEmpty) {
        newHash = iterateView.getId();
      } else {
        newHash = '${iterateView.getId()}/$newHash';
      }
      iterateView = iterateView.getParentView();
    }
    window.location.hash = newHash;
  }

  void openPath(String path) {
    getViewByPath(path).then(_showView);
  }

  Future<View> getViewByPath(String path) async {
    final viewIds = path.split('/');
    var pathView = homeView;
    for (var viewId in viewIds) {
      if (pathView != null && viewId.isNotEmpty) {
        pathView = await pathView.getChildViewById(viewId);
      }
    }
    return pathView;
  }

  void refreshNavPanel() {
    navPanel.clear();
    var parentView = currentView.getParentView();
    final views = [];
    while (parentView != null) {
      views.insert(0, parentView);
      parentView = parentView.getParentView();
    }
    views.add(currentView);

    for (var idx = 0; idx < views.length; idx++) {
      final view = views[idx];
      final button =
          navPanel.addButton(view.getCaption(), image: view.captionIsImage());
      if (idx < views.length - 1) {
        button.caption = '${button.caption} \\';
      } else {
        button.spanElement.style.fontWeight = 'bold';
      }
      button.root.onClick.listen((event) {
        openView(view);
      });
    }
  }
}
