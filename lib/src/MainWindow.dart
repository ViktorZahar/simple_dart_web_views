part of 'views.dart';

MainWindow mainWindow = new MainWindow();

class MainWindow {
  DivElement root = new DivElement();
  NavPanel navPanel = new NavPanel();
  DivElement display = new DivElement();
  View currentView;
  View homeView;

  MainWindow() {
    root.style
      ..width = '100%'
      ..height = '100%'
      ..display = 'flex'
      ..justifyContent = 'center'
      ..flexDirection = 'column';

    display.style
      ..width = '100%'
      ..height = '100%'
      ..flexDirection = 'column';

    root.children.add(navPanel.root);
    root.children.add(display);
  }

  void init(View homeView) {
    this.homeView = homeView;
    window.onHashChange.listen((event) {
      HashChangeEvent hashChangeEvent = event;
      if (hashChangeEvent.newUrl != hashChangeEvent.oldUrl) {
        this.openPath(window.location.hash.replaceFirst('#', ''));
      }
    });
    if (window.location.hash.isEmpty) {
      _showView(homeView);
    } else {
      var openUrl = window.location.hash.replaceFirst('#', '');
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
    String newHash = '';
    View iterateView = view;
    while (iterateView.getParentView() != null) {
      if (newHash.isEmpty) {
        newHash = iterateView.getId();
      } else {
        newHash = iterateView.getId() + "/" + newHash;
      }
      iterateView = iterateView.getParentView();
    }
    window.location.hash = newHash;
  }

  void openPath(String path) {
    getViewByPath(path).then(this._showView);
  }

  Future<View> getViewByPath(String path) async {
    var viewIds = path.split('/');
    View pathView = homeView;
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
    List<View> views = [];
    while (parentView != null) {
      views.insert(0, parentView);
      parentView = parentView.getParentView();
    }
    views.add(currentView);
    views.forEach((v) {
      var button = navPanel.addButton(v.getCaption());
      button.root.onClick.listen((event) {
        openView(v);
      });
    });
  }
}
