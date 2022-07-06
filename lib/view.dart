import 'dart:async';
import 'dart:html';

import 'package:simple_dart_web_widgets/abstract_component.dart';
import 'package:simple_dart_web_widgets/panel.dart';

import 'view_url_info.dart';

// Abstract View
abstract class View extends PanelComponent {
  View(String className) : super(className) {
    addCssClass('View');
    padding = '10px';
    stride = '5px';
    fillContent = true;
    fullSize();
  }

  String id = '';
  String caption = '';
  Map<String, String> params = <String, String>{};
  Map<String, String> urlStateMap = <String, String>{};

  Map<String, UrlStateComponent> urlStateComponents =
      <String, UrlStateComponent>{};

  View? parent;

  bool isChild = false;

  Future<void> init() async {}

  void beforeShow() {
    restoreState();
  }

  void afterShow() {}

  void initStateComponent(UrlStateComponent urlStateComponent) {
    urlStateComponents[urlStateComponent.varName] = urlStateComponent;
    urlStateComponent.onValueChange.listen((_) {
      final urlState = urlStateComponent.urlState;
      if (urlState.isNotEmpty) {
        saveUrlState(urlStateComponent.varName, urlStateComponent.urlState);
      }
    });
  }

  void restoreState() {
    urlStateComponents.forEach((varName, urlStateComponent) {
      if (urlStateMap.containsKey(varName)) {
        urlStateComponent.urlState = urlStateMap[varName]!;
      } else {
        urlStateComponent.urlState = '';
      }
    });
  }

  void initStateComponentList(List<UrlStateComponent> urlStateComponentList) {
    urlStateComponentList.forEach(initStateComponent);
  }

  void saveUrlState(String varName, String value) {
    final oldHash = window.location.hash;
    if (oldHash.contains(urlStateDivider)) {
      final split = oldHash.split(urlStateDivider);
      final urlInfo = ViewUrlInfo.fromUrl(oldHash);
      urlInfo.urlState[varName] = value;
      window.history.replaceState(
          {}, '', '${split.first}$urlStateDivider${urlInfo.urlStateString}');
    } else {
      final urlInfo = ViewUrlInfo();
      urlInfo.urlState[varName] = value;
      window.history.replaceState(
          {}, '', '$oldHash$urlStateDivider${urlInfo.urlStateString}');
    }
  }
}
