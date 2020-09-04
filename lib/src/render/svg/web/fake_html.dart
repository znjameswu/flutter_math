class ImageElement {
  ImageElement({String src, int height, int width});
  CssStyleDeclaration get style => CssStyleDeclaration();
}

class CssStyleDeclaration {
  // ignore: avoid_setters_without_getters
  set verticalAlign(String value) {}
}
