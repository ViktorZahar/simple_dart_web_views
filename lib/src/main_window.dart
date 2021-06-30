import 'dart:async';
import 'dart:html';

import 'package:simple_dart_web_widgets/widgets.dart';

import '../views.dart';

MainWindow mainWindow = MainWindow();

class MainWindow extends HVPanel {
  MainWindow() {
    createUi();
  }

  NavPanel navPanel = NavPanel()
    ..fullWidth()
    ..fillContent();
  HVPanel mainButtonPanel = HVPanel()
    ..varName('mainButtonPanel')
    ..addCssClasses(['navPanel'])
    ..width = ''
    ..setPadding(2)
    ..setSpaceBetweenItems(2);
  HVPanel display = HVPanel()
    ..varName('display')
    ..vertical()
    ..fillContent()
    ..fullSize()
    ..nodeRoot.style.overflow = 'auto';
  BlockStateLabel blockStateLabel = BlockStateLabel()
    ..caption = ''
    ..hide();
  View? currentView;
  View? homeView;

  void createUi() {
    vertical();
    nodeRoot.children.add(blockStateLabel.backgroundElement);
    final topPanel = HVPanel()
      ..varName('topPanel')
      ..fullWidth()
      ..addAll([navPanel, mainButtonPanel]);
    addAll([topPanel, display]);
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
    refreshNavPanel();
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
    var pathView = homeView;
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

  void refreshNavPanel() {
    navPanel.clear();
    var parentView = currentView?.getParentView();
    final views = [];
    while (parentView != null) {
      views.insert(0, parentView);
      parentView = parentView.getParentView();
    }
    views.add(currentView);

    for (var idx = 0; idx < views.length; idx++) {
      final view = views[idx];
      final button =
      navPanel.addButton(view.getCaption(), isImage: view.captionIsImage());
      if (idx < views.length - 1) {
        button.caption = '${button.caption} \\';
      } else {
        button.spanElement.style.fontWeight = 'bold';
      }
      button.nodeRoot.onClick.listen((event) {
        openView(view);
      });
    }
  }

  void showFatalError(String err) {
    blockStateLabel.showText(err).then((e) {
      window.location.assign('/');
    });
  }
}
