import 'dart:async';
import 'dart:html';

import 'package:simple_dart_web_widgets/labels/simple_label.dart';
import 'package:simple_dart_web_widgets/load_indicator.dart';
import 'package:simple_dart_web_widgets/modal_state_panel.dart';
import 'package:simple_dart_web_widgets/panel.dart';
import 'package:simple_dart_web_widgets/utils.dart';

import 'view.dart';

class MainWindow extends PanelComponent {
  MainWindow() : super('MainWindow') {
    fullSize();
    fillContent = true;
  }

  Map<String, View> registeredViewsMap = <String, View>{};
  List<View> registeredViewsList = <View>[];

  Panel display = Panel()
    ..varName('display')
    ..vertical = true
    ..fillContent = true
    ..fullSize()
    ..nodeRoot.style.overflow = 'auto';

  View? currentView;
  View? homeView;

  bool insertedToPage = false;

  final StreamController<View> _onViewChange = StreamController<View>();

  Stream<View> get onViewChange => _onViewChange.stream;

  LoadIndicator loadIndicator = LoadIndicator();

  void switchTheme(String themeName) {
    loadIndicator.show(this);
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
    loadIndicator.hide();
  }

  void updateStateValue(String varName, String value) {
    final oldHash = window.location.hash;
    if (oldHash.contains('~')) {
      final split = oldHash.split('~');
      final currentStateStr = split.last;
      final urlInfo = ViewUrlInfo.fromUrl(currentStateStr);
      urlInfo.state[varName] = value;
      // window.location.hash = '${split.first}~${urlInfo.stateString}';
      // window.location.replace('${split.first}~${urlInfo.stateString}');
      window.history
          .replaceState({}, '', '${split.first}~${urlInfo.stateString}');
    } else {
      final urlInfo = ViewUrlInfo();
      urlInfo.state[varName] = value;
      // window.location.hash='$oldHash~${urlInfo.stateString}' ;
      // window.location.replace('$oldHash~${urlInfo.stateString}');
      window.history.replaceState({}, '', '$oldHash~${urlInfo.stateString}');
    }
  }

  void init(View homeView,
      {String theme = 'default', String nodeSelector = 'body'}) {
    this.homeView = homeView;
    window.onHashChange.listen((event) {
      if (event is HashChangeEvent) {
        var oldUrl = event.oldUrl ?? '';
        var newUrl = event.newUrl ?? '';
        if (oldUrl.contains('~')) {
          oldUrl = oldUrl.substring(0, oldUrl.indexOf('~'));
        }
        if (newUrl.contains('~')) {
          newUrl = newUrl.substring(0, newUrl.indexOf('~'));
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
      insertToPage(theme: theme, nodeSelector: nodeSelector);
    }
  }

  void insertToPage({String theme = 'default', String nodeSelector = 'body'}) {
    configureMainWindow();
    switchTheme(theme);
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
      ..state = firstViewUrlInfo.state;
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
          ..state = childViewUrlInfo.state;
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

  void registerViews(List<View> views) {
    views.forEach(registerView);
  }

  void close() {
    _onViewChange.close();
  }
}

class ViewUrlInfo {
  ViewUrlInfo();

  factory ViewUrlInfo.fromUrl(String url) {
    final res = ViewUrlInfo();
    var id = '';
    var params = <String, String>{};
    var state = <String, String>{};
    if (url.contains('~')) {
      final split = url.split('~');
      url = split.first;
      state = Uri.splitQueryString(split.last);
    }
    if (url.contains('?')) {
      final split = url.split('?');
      id = split.first;
      params = Uri.splitQueryString(split.last);
    } else {
      id = url;
    }
    res
      ..id = id
      ..params = params
      ..state = state;
    return res;
  }

  String id = '';
  Map<String, String> params = <String, String>{};
  Map<String, String> state = <String, String>{};

  String get stateString =>
      state.entries.map((e) => '${e.key}=${e.value}').join('&');
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
