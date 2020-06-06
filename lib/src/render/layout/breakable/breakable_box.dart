//ignore_for_file: lines_longer_than_80_chars

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'breakable_constraints.dart';
import 'breakable_offset.dart';
import 'breakable_size.dart';

class BreakableBoxParentData extends ParentData implements BoxParentData {
  BreakableOffset _offset;
  BreakableOffset get offset => _offset;

  @override
  set offset(Offset value) {
    _offset = BreakableOffset([value]);
  }

  @override
  String toString() => 'breakableOffset: $offset';
}

class ContainerBreakableBoxParentData<ChildType extends RenderObject>
    extends BreakableBoxParentData
    with ContainerParentDataMixin<ChildType>
    implements ContainerBoxParentData<ChildType> {}

abstract class RenderBreakableBox extends RenderBox {
  @override
  void setupParentData(RenderObject child) {
    if (child is RenderBreakableBox) {
      if (child.parentData is! BreakableBoxParentData) {
        child.parentData = BreakableBoxParentData();
      }
    } else {
      super.setupParentData(child);
    }
  }

  @override
  bool get hasSize => _size != null;

  BreakableSize _size;

  @override
  BreakableSize get size {
    assert(hasSize, 'RenderBox was not laid out: ${toString()}');
    // assert(() {
    //   final Size _size = this._size;
    //   if (_size is _DebugSize) {
    //     assert(_size._owner == this);
    //     if (RenderObject.debugActiveLayout != null) {
    //       // We are always allowed to access our own size (for print debugging
    //       // and asserts if nothing else). Other than us, the only object that's
    //       // allowed to read our size is our parent, if they've said they will.
    //       // If you hit this assert trying to access a child's size, pass
    //       // "parentUsesSize: true" to that child's layout().
    //       assert(debugDoingThisResize || debugDoingThisLayout ||
    //              (RenderObject.debugActiveLayout == parent && _size._canBeUsedByParent));
    //     }
    //     assert(_size == this._size);
    //   }
    //   return true;
    // }());
    return _size;
  }

  @override
  set size(Size value) {
    assert(!(debugDoingThisResize && debugDoingThisLayout));
    assert(sizedByParent || !debugDoingThisResize);
    assert(() {
      if ((sizedByParent && debugDoingThisResize) ||
          (!sizedByParent && debugDoingThisLayout)) return true;
      assert(!debugDoingThisResize);
      final information = <DiagnosticsNode>[
        ErrorSummary('RenderBox size setter called incorrectly.'),
      ];
      if (debugDoingThisLayout) {
        assert(sizedByParent);
        information.add(ErrorDescription(
            'It appears that the size setter was called from performLayout().'));
      } else {
        information.add(ErrorDescription(
            'The size setter was called from outside layout (neither performResize() nor performLayout() were being run for this object).'));
        if (owner != null && owner.debugDoingLayout) {
          information.add(ErrorDescription(
              'Only the object itself can set its size. It is a contract violation for other objects to set it.'));
        }
      }
      if (sizedByParent) {
        information.add(ErrorDescription(
            'Because this RenderBox has sizedByParent set to true, it must set its size in performResize().'));
      } else {
        information.add(ErrorDescription(
            'Because this RenderBox has sizedByParent set to false, it must set its size in performLayout().'));
      }
      throw FlutterError.fromParts(information);
    }());
    // assert(() {
    //   value = debugAdoptSize(value);
    //   return true;
    // }());
    _size = (value is BreakableSize) ? value : BreakableSize.fromSize(value);
    assert(() {
      debugAssertDoesMeetConstraints();
      return true;
    }());
  }

  // @override
  // Size debugAdoptSize(Size value) {
  //   if (value is BreakableSize) {
  //     var result = value;
  //     assert(() {
  //       if (value is _DebugBreakableSize) {
  //         if (value._owner != this) {
  //           if (value._owner.parent != this) {
  //             throw FlutterError.fromParts(<DiagnosticsNode>[
  //               ErrorSummary(
  //                   'The size property was assigned a size inappropriately.'),
  //               describeForError('The following render object'),
  //               value._owner
  //                   .describeForError('...was assigned a size obtained from'),
  //               ErrorDescription(
  //                   'However, this second render object is not, or is no longer, a '
  //                   'child of the first, and it is therefore a violation of the '
  //                   'RenderBox layout protocol to use that size in the layout of the '
  //                   'first render object.'),
  //               ErrorHint(
  //                   'If the size was obtained at a time where it was valid to read '
  //                   'the size (because the second render object above was a child '
  //                   'of the first at the time), then it should be adopted using '
  //                   'debugAdoptSize at that time.'),
  //               ErrorHint(
  //                   'If the size comes from a grandchild or a render object from an '
  //                   'entirely different part of the render tree, then there is no '
  //                   'way to be notified when the size changes and therefore attempts '
  //                   'to read that size are almost certainly a source of bugs. A different '
  //                   'approach should be used.'),
  //             ]);
  //           }
  //           if (!value._canBeUsedByParent) {
  //             throw FlutterError.fromParts(<DiagnosticsNode>[
  //               ErrorSummary(
  //                   "A child's size was used without setting parentUsesSize."),
  //               describeForError('The following render object'),
  //               value._owner.describeForError(
  //                   '...was assigned a size obtained from its child'),
  //               ErrorDescription(
  //                   'However, when the child was laid out, the parentUsesSize argument '
  //                   'was not set or set to false. Subsequently this transpired to be '
  //                   'inaccurate: the size was nonetheless used by the parent.\n'
  //                   'It is important to tell the framework if the size will be used or not '
  //                   'as several important performance optimizations can be made if the '
  //                   'size will not be used by the parent.'),
  //             ]);
  //           }
  //         }
  //       }
  //       result = _DebugBreakableSize(value, this, debugCanParentUseSize);
  //       return true;
  //     }());
  //     return result;
  //   } else {
  //     return super.debugAdoptSize(value);
  //   }
  // }

  @override
  Rect get semanticBounds => constraints is BreakableBoxConstraints
      ? size.formRect(Offset.zero, constraints as BreakableBoxConstraints)
      : Offset.zero & size;

  Map<TextBaseline, double> _cachedEndBaselines;
  static bool _debugDoingEndBaseline = false;
  static bool _debugSetDoingEndBaseline(bool value) {
    _debugDoingEndBaseline = value;
    return true;
  }

  double getDistanceToEndBaseline(TextBaseline baseline,
      {bool onlyReal = false}) {
    assert(!_debugDoingEndBaseline,
        'Please see the documentation for computeDistanceToActualBaseline for the required calling conventions of this method.');
    assert(!debugNeedsLayout);
    assert(() {
      final parent = this.parent as RenderObject;
      if (owner.debugDoingLayout) {
        return (RenderObject.debugActiveLayout == parent) &&
            parent.debugDoingThisLayout;
      }
      if (owner.debugDoingPaint) {
        return ((RenderObject.debugActivePaint == parent) &&
                parent.debugDoingThisPaint) ||
            ((RenderObject.debugActivePaint == this) && debugDoingThisPaint);
      }
      assert(parent == this.parent);
      return false;
    }());
    assert(_debugSetDoingEndBaseline(true));
    final result = getDistanceToActualEndBaseline(baseline);
    assert(_debugSetDoingEndBaseline(false));
    if (result == null && !onlyReal) {
      return size.height;
    }
    return result;
  }

  @protected
  @mustCallSuper
  double getDistanceToActualEndBaseline(TextBaseline baseline) {
    // assert(_debugDoingBaseline, 'Please see the documentation for computeDistanceToActualBaseline for the required calling conventions of this method.');
    _cachedEndBaselines ??= <TextBaseline, double>{};
    _cachedEndBaselines.putIfAbsent(
        baseline, () => computeDistanceToActualBaseline(baseline));
    return _cachedEndBaselines[baseline];
  }

  @protected
  double computeDistanceToActualEndBaseline(TextBaseline baseline) {
    assert(_debugDoingEndBaseline,
        'Please see the documentation for computeDistanceToActualBaseline for the required calling conventions of this method.');
    //ignore: avoid_returning_null
    return null;
  }

  @override
  void debugAssertDoesMeetConstraints() {
    // TODO: implement debugAssertDoesMeetConstraints
    // super.debugAssertDoesMeetConstraints();
  }

  @override
  void markNeedsLayout() {
    if (_cachedEndBaselines != null && _cachedEndBaselines.isNotEmpty) {
      // If we have cached data, then someone must have used our data.
      // Since the parent will shortly be marked dirty, we can forget that they
      // used the baseline and/or intrinsic dimensions. If they use them again,
      // then we'll fill the cache again, and if we get dirty again, we'll
      // notify them again.
      _cachedEndBaselines?.clear();
      if (parent is RenderObject) {
        markParentNeedsLayout();
        return;
      }
    }
    super.markNeedsLayout();
  }

  @override
  void performResize() {
    super.performResize();
  }

  // @override
  // bool hitTest(BoxHitTestResult result, {Offset position}) {
  //   // TODO: implement hitTest
  //   return super.hitTest(result, position);
  // }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    // TODO: implement applyPaintTransform
    super.applyPaintTransform(child, transform);
  }

  @override
  Rect get paintBounds => throw UnimplementedError();

  // @override
  // void debugPaint(PaintingContext context, Offset offset) {
  //   super.debugPaint(context, offset);
  // }

  @override
  void debugPaintSize(PaintingContext context, Offset offset) {
    assert(() {
      final constraints = this.constraints;
      final rect = constraints is BreakableBoxConstraints
          ? size.formRect(offset, constraints)
          : offset & size;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = const Color(0xFF00FFFF);
      context.canvas.drawRect(rect.deflate(0.5), paint);
      return true;
    }());
  }

  @override
  void debugPaintBaselines(PaintingContext context, Offset offset) {
    if (offset is BreakableOffset && size.lineSizes.length > 1) {
      assert(() {
        final firstOffset = offset.lineOffsets[0];
        final lastOffset = offset.lineOffsets.length >= size.lineSizes.length
            ? offset.lineOffsets[size.lineSizes.length - 1]
            : Offset.zero;
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.25;
        Path path;
        // ideographic baseline
        final baselineI =
            getDistanceToBaseline(TextBaseline.ideographic, onlyReal: true);
        if (baselineI != null) {
          paint.color = const Color(0xFFFFD000);
          path = Path();
          path.moveTo(firstOffset.dx, firstOffset.dy + baselineI);
          path.lineTo(firstOffset.dx + size.lineSizes.first.width,
              firstOffset.dy + baselineI);
          context.canvas.drawPath(path, paint);
        }
        // alphabetic baseline
        final baselineA =
            getDistanceToBaseline(TextBaseline.alphabetic, onlyReal: true);
        if (baselineA != null) {
          paint.color = const Color(0xFF00FF00);
          path = Path();
          path.moveTo(firstOffset.dx, firstOffset.dy + baselineA);
          path.lineTo(firstOffset.dx + size.lineSizes.first.width,
              firstOffset.dy + baselineA);
          context.canvas.drawPath(path, paint);
        }
        // ideographic baseline at the end
        final baselineEI =
            getDistanceToEndBaseline(TextBaseline.ideographic, onlyReal: true);
        if (baselineEI != null) {
          paint.color = const Color(0xFFFFD000);
          path = Path();
          path.moveTo(lastOffset.dx, firstOffset.dy + baselineEI);
          path.lineTo(lastOffset.dx + size.lineSizes.last.width,
              firstOffset.dy + baselineEI);
          context.canvas.drawPath(path, paint);
        }
        // alphabetic baseline at the end
        final baselineEA =
            getDistanceToEndBaseline(TextBaseline.alphabetic, onlyReal: true);
        if (baselineEA != null) {
          paint.color = const Color(0xFF00FF00);
          path = Path();
          path.moveTo(lastOffset.dx, firstOffset.dy + baselineEA);
          path.lineTo(lastOffset.dx + size.lineSizes.last.width,
              firstOffset.dy + baselineEA);
          context.canvas.drawPath(path, paint);
        }
        return true;
      }());
    } else {
      super.debugPaintBaselines(context, offset);
    }
  }

  @override
  void debugPaintPointers(PaintingContext context, Offset offset) {
    // TODO: implement debugPaintPointers
    super.debugPaintPointers(context, offset);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<Size>('breakableSize', _size, missingIfNull: true));
  }
}
