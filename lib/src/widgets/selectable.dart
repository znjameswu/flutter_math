import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../ast/options.dart';
import '../ast/syntax_tree.dart';
import '../parser/tex/parse_error.dart';
import '../parser/tex/parser.dart';
import '../parser/tex/settings.dart';
import '../render/layout/line_editable.dart';
import 'controller.dart';
import 'flutter_math.dart';
import 'selection/gesture_detector_builder_selectable.dart';
import 'selection/overlay.dart';
import 'selection/selection_manager.dart';

const defaultSelection = TextSelection.collapsed(offset: -1);

class MathSelectable extends StatelessWidget {
  const MathSelectable({
    Key key,
    this.ast,
    this.cursorColor,
    this.cursorRadius,
    this.focusNode,
    @required this.options,
    @required this.onErrorFallback,
    this.parseError,
    this.style,
    this.textSelectionControls,
  }) : super(key: key);

  final SyntaxTree ast;

  final Color cursorColor;

  final Radius cursorRadius;

  final FocusNode focusNode;

  final Options options;

  final OnErrorFallback onErrorFallback;

  final String parseError;

  final TextStyle style;

  final TextSelectionControls textSelectionControls;

  // final ToolbarOptions toolbarOptions;

  factory MathSelectable.tex(
    String expression, {
    Options options = Options.displayOptions,
    Settings settings = const Settings(),
    TextSelectionControls textSelectionControls,
    OnErrorFallback onErrorFallback,
  }) {
    try {
      final ast =
          SyntaxTree(greenRoot: TexParser(expression, settings).parse());
      return MathSelectable(
        ast: ast,
        options: options,
        onErrorFallback: onErrorFallback,
        textSelectionControls: textSelectionControls,
      );
    } on ParseError catch (e) {
      return MathSelectable(
        parseError: 'Parse Error: ${e.message}',
        onErrorFallback: onErrorFallback,
        options: options,
        textSelectionControls: textSelectionControls,
      );
    } on dynamic catch (e) {
      return MathSelectable(
        parseError: e.toString(),
        onErrorFallback: onErrorFallback,
        options: options,
        textSelectionControls: textSelectionControls,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (parseError != null) {
      return onErrorFallback(parseError);
    }
    try {
      final child = ast.buildWidget(options);
    } on dynamic catch (err) {
      return onErrorFallback(err.toString());
    }

    final theme = Theme.of(context);
    final selectionTheme = TextSelectionTheme.of(context);

    TextSelectionControls textSelectionControls;
    bool paintCursorAboveText;
    bool cursorOpacityAnimates;
    Offset cursorOffset;
    var cursorColor = this.cursorColor;
    Color selectionColor;
    var cursorRadius = this.cursorRadius;
    bool forcePressEnabled;

    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        forcePressEnabled = true;
        textSelectionControls = cupertinoTextSelectionControls;
        paintCursorAboveText = true;
        cursorOpacityAnimates = true;
        if (theme.useTextSelectionTheme) {
          cursorColor ??= selectionTheme.cursorColor ??
              CupertinoTheme.of(context).primaryColor;
          selectionColor = selectionTheme.selectionColor ??
              CupertinoTheme.of(context).primaryColor;
        } else {
          cursorColor ??= CupertinoTheme.of(context).primaryColor;
          selectionColor = theme.textSelectionColor;
        }
        cursorRadius ??= const Radius.circular(2.0);
        cursorOffset = Offset(
            iOSHorizontalOffset / MediaQuery.of(context).devicePixelRatio, 0);
        break;

      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        forcePressEnabled = false;
        textSelectionControls = materialTextSelectionControls;
        paintCursorAboveText = false;
        cursorOpacityAnimates = false;
        if (theme.useTextSelectionTheme) {
          cursorColor ??=
              selectionTheme.cursorColor ?? theme.colorScheme.primary;
          selectionColor =
              selectionTheme.selectionColor ?? theme.colorScheme.primary;
        } else {
          cursorColor ??= theme.cursorColor;
          selectionColor = theme.textSelectionColor;
        }
        break;
    }

    var effectiveTextStyle = this.style;
    if (this.style == null || this.style.inherit) {
      effectiveTextStyle = DefaultTextStyle.of(context).style.merge(this.style);
    }
    if (MediaQuery.boldTextOverride(context)) {
      effectiveTextStyle = effectiveTextStyle
          .merge(const TextStyle(fontWeight: FontWeight.bold));
    }

    return _SelectableMath(
      ast: ast,
      cursorColor: cursorColor,
      cursorRadius: cursorRadius,
      focusNode: focusNode,
      forcePressEnabled: forcePressEnabled,
      options: options,
      onErrorFallback: onErrorFallback,
      parseError: parseError,
      textSelectionControls: textSelectionControls,
    );
  }
}

class _SelectableMath extends StatefulWidget {
  const _SelectableMath({
    Key key,
    @required this.ast,
    @required this.cursorColor,
    @required this.cursorRadius,
    @required this.focusNode,
    @required this.forcePressEnabled,
    @required this.options,
    @required this.onErrorFallback,
    @required this.parseError,
    @required this.textSelectionControls,
  }) : super(key: key);

  final SyntaxTree ast;

  final Color cursorColor;

  final Radius cursorRadius;

  final FocusNode focusNode;

  final bool forcePressEnabled;

  final Options options;

  final OnErrorFallback onErrorFallback;

  final dynamic parseError;

  final TextSelectionControls textSelectionControls;

  @override
  __SelectableMathState createState() => __SelectableMathState();
}

class __SelectableMathState extends State<_SelectableMath>
    with AutomaticKeepAliveClientMixin, MathSelectionManager {
  final _toolbarLayerLink = LayerLink();
  final _startHandleLayerLink = LayerLink();
  final _endHandleLayerLink = LayerLink();

  FocusNode _focusNode;
  FocusNode get focusNode => widget.focusNode ?? (_focusNode ??= FocusNode());

  bool get _hasFocus => focusNode.hasFocus;

  MathController controller;

  MathSelectionOverlay _selectionOverlay;

  MathSelectableSelectionGestureDetectorBuilder
      _selectionGestureDetectorBuilder;

  void handleSelectionChanged(
      TextSelection selection, SelectionChangedCause cause,
      {bool rebuildOverlay = true}) {
    super.handleSelectionChanged(selection, cause);
    if (!_hasFocus) {
      focusNode.requestFocus();
    }

    if (rebuildOverlay) {
      _selectionOverlay?.hide();
      _selectionOverlay = null;

      if (widget.textSelectionControls != null) {
        _selectionOverlay = MathSelectionOverlay(
          manager: this,
          toolbarLayerLink: _toolbarLayerLink,
          startHandleLayerLink: _startHandleLayerLink,
          endHandleLayerLink: _endHandleLayerLink,
          onSelectionHandleTapped: () {
            if (!controller.selection.isCollapsed) {
              toolbarVisible ? hideToolbar() : showToolbar();
            }
          },
          selectionControls: widget.textSelectionControls,
        );
        _selectionOverlay.handlesVisible = _shouldShowSelectionHandles(cause);
        _selectionOverlay.showHandles();
      }
    } else {
      _selectionOverlay?.update();
    }
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        if (cause == SelectionChangedCause.longPress) {
          bringIntoView(selection.base);
        }
        return;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      // Do nothing.
    }
  }

  bool _shouldShowSelectionHandles(SelectionChangedCause cause) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar)
      return false;

    if (controller.selection.isCollapsed) return false;

    if (cause == SelectionChangedCause.keyboard) return false;

    if (cause == SelectionChangedCause.longPress) return true;

    if (controller.ast.greenRoot.capturedCursor > 1) return true;

    return false;
  }

  /// Shows the selection toolbar at the location of the current cursor.
  ///
  /// Returns `false` if a toolbar couldn't be shown, such as when the toolbar
  /// is already shown, or when no text selection currently exists.
  bool showToolbar() {
    // Web is using native dom elements to enable clipboard functionality of the
    // toolbar: copy, paste, select, cut. It might also provide additional
    // functionality depending on the browser (such as translate). Due to this
    // we should not show a Flutter toolbar for the editable text elements.
    if (kIsWeb) {
      return false;
    }

    if (_selectionOverlay == null || _selectionOverlay.toolbarIsVisible) {
      return false;
    }

    _selectionOverlay.showToolbar();
    toolbarVisible = true;
    return true;
  }

  @override
  void hideToolbar() {
    toolbarVisible = false;
    _selectionOverlay?.hideToolbar();
  }

  @override
  void initState() {
    super.initState();
    controller = MathController(
      ast: widget.ast,
      selection: defaultSelection,
    );
    _selectionGestureDetectorBuilder =
        MathSelectableSelectionGestureDetectorBuilder(delegate: this);
  }

  @override
  void didUpdateWidget(covariant _SelectableMath oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.ast = widget.ast;
    _selectionOverlay?.update();
  }

  @override
  void dispose() {
    controller.dispose();
    _selectionOverlay?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    final child = widget.ast.buildWidget(widget.options);

    return _selectionGestureDetectorBuilder.buildGestureDetector(
      child: MouseRegion(
        cursor: SystemMouseCursors.text,
        child: CompositedTransformTarget(
          link: _toolbarLayerLink,
          child: MultiProvider(
            providers: [
              Provider.value(value: FlutterMathMode.select),
              ChangeNotifierProvider.value(value: controller),
              ProxyProvider<MathController, TextSelection>(
                create: (context) => const TextSelection.collapsed(offset: -1),
                update: (context, value, previous) => value.selection,
              ),
              Provider.value(
                value: Tuple2(_startHandleLayerLink, _endHandleLayerLink),
              ),
            ],
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  bool handleVisible;

  @override
  bool toolbarVisible = false;

  @override
  bool get copyEnabled => true;

  @override
  bool get cutEnabled => false;

  @override
  Rect getLocalEditingRegion() {
    final root = widget.ast.greenRoot.key.currentContext.findRenderObject()
        as RenderEditableLine;
    return Rect.fromPoints(
      Offset.zero,
      root.size.bottomRight(Offset.zero),
    );
  }

  @override
  bool get pasteEnabled => true;

  @override
  double get preferredLineHeight => widget.options.fontSize;

  @override
  bool get selectAllEnabled => true;

  @override
  bool get forcePressEnabled => widget.forcePressEnabled;

  @override
  bool get hasFocus => focusNode.hasFocus;

  @override
  bool get selectionEnabled => true;
}
