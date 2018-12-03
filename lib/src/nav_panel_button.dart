import 'dart:html';

class NavPanelButton {
  NavPanelButton() {
    root = DivElement();
    root.style
      ..padding = '5px'
      ..height = '100%'
      ..textAlign = 'center'
      ..display = 'flex'
      ..cursor = 'pointer'
      ..alignItems = 'center'
      ..justifyContent = 'center';
    imageElement = ImageElement()..style.height = '100%';
    spanElement = SpanElement()..style.color = 'white';
    root.children.add(imageElement);
    root.children.add(spanElement);
  }
  DivElement root;
  ImageElement imageElement;
  SpanElement spanElement;
  String _imagePath;

  set caption(String caption) => spanElement.text = '$caption';

  String get caption => spanElement.text;

  set image(String imagePath) {
    _imagePath = imagePath;
    imageElement.src = _imagePath;
    caption = '';
  }

  String get image => _imagePath;
}
