import 'dart:async';
import 'dart:html';

import 'package:simple_dart_web_widgets/labels/simple_label.dart';
import 'package:simple_dart_web_widgets/load_indicator.dart';
import 'package:simple_dart_web_widgets/modal_state_panel.dart';
import 'package:simple_dart_web_widgets/panel.dart';
import 'package:simple_dart_web_widgets/utils.dart';

import 'view.dart';
import 'view_url_info.dart';


class MainWindow extends PanelComponent {
  MainWindow() : super('MainWindow') {
    fullSize();
    fillContent = true;
  }

  Map<String, View> registeredViewsMap = <String, View>{};
  List<View> registeredViewsList = <View>[];

  Panel display = Panel()
    ..varName='display'
    ..vertical = true
    ..fillContent = true
    ..fullSize()
    ..nodeRoot.style.overflow = 'auto';

  View? currentView;
  View? homeView;

  bool insertedToPage = false;

  final StreamController<View> _onViewChange =
      StreamController<View>.broadcast();

  Stream<View> get onViewChange => _onViewChange.stream;

  LoadIndicator loadIndicator = LoadIndicator();

  void init(View homeView, List<View> views, {String nodeSelector = 'body'}) {
    this.homeView = homeView;
    registerView(homeView);
    views.forEach(registerView);
    window.onHashChange.listen((event) {
      if (event is HashChangeEvent) {
        var oldUrl = event.oldUrl ?? '';
        var newUrl = event.newUrl ?? '';
        if (oldUrl.contains(urlStateDivider)) {
          oldUrl = oldUrl.substring(0, oldUrl.indexOf(urlStateDivider));
        }
        if (newUrl.contains(urlStateDivider)) {
          newUrl = newUrl.substring(0, newUrl.indexOf(urlStateDivider));
        }
        if (newUrl != oldUrl) {
          openPath(window.location.hash.replaceFirst('#', ''));
        }
      }
    });
    if (window.location.hash.isEmpty) {
      openView(homeView);
    } else {
      final openUrl = window.location.hash.replaceFirst('#', '');
      openPath(openUrl);
    }
    if (!insertedToPage) {
      insertToPage(nodeSelector: nodeSelector);
    }
  }

  void insertToPage({String nodeSelector = 'body'}) {
    configureMainWindow();
    nodeRoot.children.add(modalStatePanel.nodeRoot);
    querySelector(nodeSelector)?.children.add(nodeRoot);
    insertedToPage = true;
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
    window.location.hash = fullPathOfView(view);
  }

  void openPath(String path) {
    getViewByPath(path)
        .then(_showView)
        .catchError((error, stackTrace) => showFatalError(error));
  }

  Future<View> getViewByPath(String path) async {
    if (path.isEmpty) {
      return homeView!;
    }
    final viewUrls = path.split('/');
    final firstUrl = viewUrls.removeAt(0);
    final firstViewUrlInfo = ViewUrlInfo.fromUrl(firstUrl);
    final firstView = registeredViewsMap[firstViewUrlInfo.id];
    if (firstView == null) {
      throw Exception('view "${firstViewUrlInfo.id}" is not registered');
    }
    firstView
      ..params = firstViewUrlInfo.params
      ..urlStateMap = firstViewUrlInfo.urlState;
    await firstView.init();
    var parentView = firstView;
    for (final viewUrl in viewUrls) {
      if (viewUrl.isNotEmpty) {
        final childViewUrlInfo = ViewUrlInfo.fromUrl(viewUrl);
        final childView = registeredViewsMap[childViewUrlInfo.id];
        if (childView == null) {
          throw Exception('view "${childViewUrlInfo.id}" is not registered');
        }
        childView
          ..parent = parentView
          ..params = childViewUrlInfo.params
          ..urlStateMap = childViewUrlInfo.urlState;
        await childView.init();
        parentView = childView;
      }
    }
    return parentView;
  }

  void showFatalError(Object errObj) {
    final errText = convertError(errObj);
    modalStatePanel.onClick.listen((event) {
      window.location.assign('/');
    });
    modalStatePanel.visible = true;
    modalStatePanel.add(SimpleLabel()..caption = errText);
  }

  String showError(Object errObj) {
    final errText = convertError(errObj);
    modalStatePanel.onClick.listen((event) {
      modalStatePanel.visible = false;
    });
    modalStatePanel.visible = true;
    modalStatePanel.add(SimpleLabel()..caption = errText);
    return errText;
  }

  void registerView(View view) {
    if (view.id.isEmpty) {
      showFatalError('error: register view without id ${view.runtimeType}');
      return;
    }
    registeredViewsMap[view.id] = view;
    registeredViewsList.add(view);
  }

  void close() {
    _onViewChange.close();
  }
}



String fullPathOfView(View lastView) {
  final encodedLastViewPath = _encodedPartOfPath(lastView);
  var lastParentView = lastView.parent;
  if (lastParentView == null) {
    return '#$encodedLastViewPath';
  }
  final viewsList = <View>[];
  while (lastParentView != null) {
    viewsList.add(lastParentView);
    lastParentView = lastParentView.parent;
  }
  final buffer = StringBuffer()..write('#');
  for (final view in viewsList.reversed) {
    final encodedViewPath = _encodedPartOfPath(view);
    buffer.write('$encodedViewPath/');
  }
  return buffer.toString() + encodedLastViewPath;
}

String _encodedPartOfPath(View view) {
  var result = view.id;
  if (view.params.isNotEmpty) {
    result += '?';
    var isFirst = true;
    view.params.forEach((key, value) {
      if (isFirst) {
        result += '$key=${Uri.encodeQueryComponent(value)}';
        isFirst = false;
      } else {
        result += '&$key=${Uri.encodeQueryComponent(value)}';
      }
    });
  }
  return result;
}
