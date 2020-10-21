import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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
import 'controller.dart';
import 'flutter_math.dart';
import 'selection/focus_manager.dart';
import 'selection/overlay_manager.dart';
import 'selection/selection_manager.dart';
import 'selection/web_selection_manager.dart';

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
    this.showCursor = false,
    this.autofocus = false,
    this.dragStartBehavior = DragStartBehavior.start,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    ToolbarOptions toolbarOptions,
    this.enableInteractiveSelection = true,
  })  : assert(showCursor != null),
        assert(autofocus != null),
        assert(dragStartBehavior != null),
        toolbarOptions = toolbarOptions ??
            const ToolbarOptions(
              selectAll: true,
              copy: true,
            ),
        super(key: key);

  final SyntaxTree ast;

  final Color cursorColor;

  final Radius cursorRadius;

  final FocusNode focusNode;

  final Options options;

  final OnErrorFallback onErrorFallback;

  final String parseError;

  final TextStyle style;

  final TextSelectionControls textSelectionControls;

  final bool showCursor;

  final bool autofocus;

  final DragStartBehavior dragStartBehavior;

  final double cursorWidth;

  final double cursorHeight;

  final bool enableInteractiveSelection;

  final ToolbarOptions toolbarOptions;

  factory MathSelectable.tex(
    String expression, {
    Options options = Options.displayOptions,
    Settings settings = const Settings(),
    TextSelectionControls textSelectionControls,
    OnErrorFallback onErrorFallback = defaultOnErrorFallback,
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

  Widget build(BuildContext context) {
    if (parseError != null) {
      return onErrorFallback(parseError);
    }

    final theme = Theme.of(context);
    // The following code adapts for Flutter's new theme system (https://github.com/flutter/flutter/pull/62014/)
    // final selectionTheme = TextSelectionTheme.of(context);

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
        // if (theme.useTextSelectionTheme) {
        //   cursorColor ??= selectionTheme.cursorColor ??
        //       CupertinoTheme.of(context).primaryColor;
        //   selectionColor = selectionTheme.selectionColor ??
        //       CupertinoTheme.of(context).primaryColor;
        // } else {
        cursorColor ??= CupertinoTheme.of(context).primaryColor;
        selectionColor = theme.textSelectionColor;
        // }
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
        // if (theme.useTextSelectionTheme) {
        //   cursorColor ??=
        //       selectionTheme.cursorColor ?? theme.colorScheme.primary;
        //   selectionColor =
        //       selectionTheme.selectionColor ?? theme.colorScheme.primary;
        // } else {
        cursorColor ??= theme.cursorColor;
        selectionColor = theme.textSelectionColor;
        // }
        break;
    }

    var effectiveTextStyle = style;
    if (style == null || style.inherit) {
      effectiveTextStyle = DefaultTextStyle.of(context).style.merge(style);
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
  _SelectableMath({
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
    with
        AutomaticKeepAliveClientMixin,
        FocusManagerMixin,
        MathSelectionManagerMixin,
        MathSelectionOverlayManager
        // WebSelectionManagerMixin 
        {
  TextSelectionControls get textSelectionControls =>
      widget.textSelectionControls;

  FocusNode _focusNode;
  FocusNode get focusNode => widget.focusNode ?? (_focusNode ??= FocusNode());

  MathController controller;

  @override
  void initState() {
    controller = MathController(ast: widget.ast);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _SelectableMath oldWidget) {
    if (widget.ast != controller.ast) {
      controller = MathController(ast: widget.ast);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onSelectionChanged(
      TextSelection selection, SelectionChangedCause cause) {
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

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    final child = controller.ast.buildWidget(widget.options);

    return selectionGestureDetectorBuilder.buildGestureDetector(
      child: MouseRegion(
        cursor: SystemMouseCursors.text,
        child: CompositedTransformTarget(
          link: toolbarLayerLink,
          child: MultiProvider(
            providers: [
              Provider.value(value: FlutterMathMode.select),
              ChangeNotifierProvider.value(value: controller),
              ProxyProvider<MathController, TextSelection>(
                create: (context) => const TextSelection.collapsed(offset: -1),
                update: (context, value, previous) => value.selection,
              ),
              Provider.value(
                value: Tuple2(startHandleLayerLink, endHandleLayerLink),
              ),
            ],
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get copyEnabled => true;

  @override
  bool get cutEnabled => false;

  @override
  bool get pasteEnabled => false;

  @override
  bool get selectAllEnabled => true;

  @override
  bool get forcePressEnabled => widget.forcePressEnabled;

  @override
  bool get selectionEnabled => true;

  @override
  double get preferredLineHeight => widget.options.fontSize;

  @override
  void bringIntoView(TextPosition position) {}
}
