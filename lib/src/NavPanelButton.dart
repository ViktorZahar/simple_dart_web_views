part of 'views.dart';

class NavPanelButton {
  DivElement root = new DivElement();
  SpanElement spanElement = new SpanElement();

  NavPanelButton() {
    root.style
      ..width = '150px'
      ..height = '100%'
      ..textAlign = 'center'
      ..display = 'flex'
      ..cursor='pointer'
      ..alignItems = 'center'
      ..justifyContent = 'center';

    spanElement.style..color = 'white';
    root.children.add(spanElement);
  }

  set caption(String caption) {
    spanElement.text = caption;
  }

  get caption => spanElement.text;
}
