String urlStateDivider = '::';

class ViewUrlInfo {
  ViewUrlInfo();

  factory ViewUrlInfo.fromUrl(String url) {
    final res = ViewUrlInfo();
    var id = '';
    var params = <String, String>{};
    var urlState = <String, String>{};
    if (url.contains(urlStateDivider)) {
      final split = url.split(urlStateDivider);
      url = split.first;
      urlState = Uri.splitQueryString(split.last);
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
      ..urlState = urlState;
    return res;
  }

  String id = '';
  Map<String, String> params = <String, String>{};
  Map<String, String> urlState = <String, String>{};

  String get urlStateString {
    final keys = urlState.keys.toList()..sort();
    final res = <String>[];
    for (final key in keys) {
      final value = urlState[key]!;
      res.add('${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}');
    }
    return res.join('&');
  }
}
