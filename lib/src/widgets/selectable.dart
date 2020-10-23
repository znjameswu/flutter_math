import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../ast/options.dart';
import '../ast/syntax_tree.dart';
import '../parser/tex/parse_error.dart';
import '../parser/tex/parser.dart';
import '../parser/tex/settings.dart';
import '../utils/wrapper.dart';
import 'controller.dart';
import 'flutter_math.dart';
import 'selection/cursor_timer_manager.dart';
import 'selection/focus_manager.dart';
import 'selection/overlay_manager.dart';
import 'selection/selection_manager.dart';
import 'selection/web_selection_manager.dart';

const defaultSelection = TextSelection.collapsed(offset: -1);

class MathSelectable extends StatelessWidget {
  const MathSelectable({
    Key key,
    this.ast,
    this.autofocus = false,
    this.cursorColor,
    this.cursorRadius,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.focusNode,
    this.hintingColor,
    @required this.onErrorFallback,
    @required this.options,
    this.parseError,
    this.showCursor = false,
    this.style,
    this.textSelectionControls,
    ToolbarOptions toolbarOptions,
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

  final bool autofocus;

  final Color cursorColor;

  final Radius cursorRadius;

  final double cursorWidth;

  final double cursorHeight;

  final DragStartBehavior dragStartBehavior;

  final bool enableInteractiveSelection;

  final FocusNode focusNode;

  final Color hintingColor;

  final OnErrorFallback onErrorFallback;

  final Options options;

  final String parseError;

  final bool showCursor;

  final TextStyle style;

  final TextSelectionControls textSelectionControls;

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

    var textSelectionControls = this.textSelectionControls;
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
        textSelectionControls ??= cupertinoTextSelectionControls;
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
        textSelectionControls ??= materialTextSelectionControls;
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
      autofocus: autofocus,
      cursorColor: cursorColor,
      cursorOffset: cursorOffset,
      cursorOpacityAnimates: cursorOpacityAnimates,
      cursorRadius: cursorRadius,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      focusNode: focusNode,
      forcePressEnabled: forcePressEnabled,
      hintingColor: hintingColor,
      onErrorFallback: onErrorFallback,
      options: options,
      paintCursorAboveText: paintCursorAboveText,
      selectionColor: selectionColor,
      showCursor: showCursor,
      textSelectionControls: textSelectionControls,
      toolbarOptions: toolbarOptions,
    );
  }
}

class _SelectableMath extends StatefulWidget {
  final SyntaxTree ast;

  final bool autofocus;

  final Color cursorColor;

  final Offset cursorOffset;

  final bool cursorOpacityAnimates;

  final Radius cursorRadius;

  final double cursorWidth;

  final double cursorHeight;

  final DragStartBehavior dragStartBehavior;

  final bool enableInteractiveSelection;

  final FocusNode focusNode;

  final bool forcePressEnabled;

  final Color hintingColor;

  final OnErrorFallback onErrorFallback;

  final Options options;

  final bool paintCursorAboveText;

  final Color selectionColor;

  final bool showCursor;

  final TextSelectionControls textSelectionControls;

  final ToolbarOptions toolbarOptions;

  const _SelectableMath({
    Key key,
    this.ast,
    this.autofocus,
    this.cursorColor,
    this.cursorOffset,
    this.cursorOpacityAnimates,
    this.cursorRadius,
    this.cursorWidth,
    this.cursorHeight,
    this.dragStartBehavior,
    this.enableInteractiveSelection,
    this.forcePressEnabled,
    this.focusNode,
    this.hintingColor,
    this.onErrorFallback,
    this.options,
    this.paintCursorAboveText,
    this.selectionColor,
    this.showCursor,
    this.textSelectionControls,
    this.toolbarOptions,
  }) : super(key: key);

  @override
  __SelectableMathState createState() => __SelectableMathState();
}

class __SelectableMathState extends State<_SelectableMath>
    with
        AutomaticKeepAliveClientMixin,
        FocusManagerMixin,
        MathSelectionManagerMixin,
        MathSelectionOverlayManager,
        WebSelectionManagerMixin,
        SingleTickerProviderStateMixin,
        CursorTimerManagerMixin {
  TextSelectionControls get textSelectionControls =>
      widget.textSelectionControls;

  FocusNode _focusNode;
  FocusNode get focusNode => widget.focusNode ?? (_focusNode ??= FocusNode());

  bool get showCursor => widget.showCursor ?? false;

  bool get cursorOpacityAnimates => widget.cursorOpacityAnimates;

  MathController controller;

  @override
  void initState() {
    controller = MathController(ast: widget.ast);
    super.initState();
  }

  @override
  void didUpdateWidget(_SelectableMath oldWidget) {
    if (widget.ast != controller.ast) {
      controller = MathController(ast: widget.ast);
    }
    super.didUpdateWidget(oldWidget);
  }

  bool _didAutoFocus = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didAutoFocus && widget.autofocus) {
      _didAutoFocus = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          FocusScope.of(context).autofocus(widget.focusNode);
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
                value: SelectionStyle(
                  cursorColor: widget.cursorColor,
                  cursorOffset: widget.cursorOffset,
                  cursorRadius: widget.cursorRadius,
                  cursorWidth: widget.cursorWidth,
                  cursorHeight: widget.cursorHeight,
                  selectionColor: widget.selectionColor,
                  paintCursorAboveText: widget.paintCursorAboveText,
                ),
              ),
              Provider.value(
                value: Tuple2(startHandleLayerLink, endHandleLayerLink),
              ),
              // We can't just provide an AnimationController, otherwise
              // Provider will throw
              Provider.value(value: Wrapper(cursorBlinkOpacityController)),
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
  bool get copyEnabled => widget.toolbarOptions.copy;

  @override
  bool get cutEnabled => false;

  @override
  bool get pasteEnabled => false;

  @override
  bool get selectAllEnabled => widget.toolbarOptions.selectAll;

  @override
  bool get forcePressEnabled => widget.forcePressEnabled;

  @override
  bool get selectionEnabled => widget.enableInteractiveSelection;

  @override
  double get preferredLineHeight => widget.options.fontSize;

  @override
  void bringIntoView(TextPosition position) {}
}

class SelectionStyle {
  final Color cursorColor;
  final Offset cursorOffset;
  final Radius cursorRadius;
  final double cursorWidth;
  final double cursorHeight;
  final Color hintingColor;
  final bool paintCursorAboveText;
  final Color selectionColor;
  final bool showCursor;
  const SelectionStyle({
    this.cursorColor,
    this.cursorOffset,
    this.cursorRadius,
    this.cursorWidth = 1.0,
    this.cursorHeight,
    this.hintingColor,
    this.paintCursorAboveText = false,
    this.selectionColor,
    this.showCursor = false,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SelectionStyle &&
        o.cursorColor == cursorColor &&
        o.cursorOffset == cursorOffset &&
        o.cursorRadius == cursorRadius &&
        o.cursorWidth == cursorWidth &&
        o.cursorHeight == cursorHeight &&
        o.hintingColor == hintingColor &&
        o.paintCursorAboveText == paintCursorAboveText &&
        o.selectionColor == selectionColor &&
        o.showCursor == showCursor;
  }

  @override
  int get hashCode => hashValues(
        cursorColor,
        cursorOffset,
        cursorRadius,
        cursorWidth,
        cursorHeight,
        hintingColor,
        paintCursorAboveText,
        selectionColor,
        showCursor,
      );
}
