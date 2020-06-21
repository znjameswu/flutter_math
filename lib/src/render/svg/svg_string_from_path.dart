String svgStringFromPath(String path, List<double> viewPort, List<double> viewBox) {
  return '''<svg width= "${viewPort[0]}" height="${viewPort[1]}" viewBox="${viewBox[0]} ${viewBox[1]} ${viewBox[2]} ${viewBox[3]} "><path fill="black" d="$path"></path></svg>''';
}