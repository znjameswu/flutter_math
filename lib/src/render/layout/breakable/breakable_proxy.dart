import 'package:flutter/rendering.dart';

import 'breakable_box.dart';

class RenderProxyBreakableBox extends RenderBreakableBox
    with
        RenderObjectWithChildMixin<RenderBox>,
        RenderProxyBreakableBoxMixin<RenderBox> {}

mixin RenderProxyBreakableBoxMixin<T extends RenderBox>
    on RenderBreakableBox, RenderObjectWithChildMixin<T> {
  // TODO
}
