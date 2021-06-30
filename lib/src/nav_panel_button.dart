import 'dart:html';

import 'package:simple_dart_web_widgets/widgets.dart';

class NavPanelButton extends Component {
  NavPanelButton() {
    nodeRoot.style
      ..padding = '5px'
      ..height = '100%'
      ..textAlign = 'center'
      ..display = 'flex'
      ..cursor = 'pointer'
      ..alignItems = 'center'
      ..justifyContent = 'center';
    nodeRoot.children..add(imageElement)..add(spanElement);
  }

  @override
  DivElement nodeRoot = DivElement();
  ImageElement imageElement = ImageElement()..style.height = '100%';
  SpanElement spanElement = SpanElement()..style.color = 'white';
  String? _imagePath;

  set caption(String caption) => spanElement.text = '$caption';

  String get caption => spanElement.text ?? '';

  set image(String imagePath) {
    _imagePath = imagePath;
    imageElement.src = _imagePath;
    caption = '';
  }

  String get image => _imagePath ?? '';
}
