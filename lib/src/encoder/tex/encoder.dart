import 'dart:convert';

import 'package:meta/meta.dart';

import '../../ast/syntax_tree.dart';
import '../../ast/types.dart';
import '../../parser/tex/functions.dart';
import '../../parser/tex/settings.dart';
import '../../utils/iterable_extensions.dart';
import '../encoder.dart';
import 'functions.dart';

final texEncodingCache = Expando<EncodeResult>('Tex encoding results');

class TexEncoder extends Converter<GreenNode, String> {
  @override
  String convert(GreenNode input) => input.encodeTeX();
}

extension TexEncoderExt on GreenNode {
  String encodeTeX({TexEncodeConf conf = const TexEncodeConf()}) =>
      encodeTex(this).stringify(conf);
}

extension ListTexEncoderExt on List<GreenNode> {
  String encodeTex() =>
      this.wrapWithEquationRow().encodeTeX(conf: TexEncodeConf().mathParam());
}

EncodeResult encodeTex(GreenNode node) {
  final cachedRes = texEncodingCache[node];
  if (cachedRes != null) return cachedRes;

  final optimization = optimizationEntries
      .firstWhereOrNull((entry) => entry.matcher.match(node));
  if (optimization != null) {
    optimization.optimize(node);
    final cachedRes = texEncodingCache[node];
    if (cachedRes != null) return cachedRes;
  }

  final type = node.runtimeType;
  final encoderFunction = encoderFunctions[type];
  if (encoderFunction == null) {
    return NonStrictEncodeResult('unknown node type',
        'Unrecognized node type $type encountered during encoding');
  }

  final encodeResult = encoderFunction(node);
  texEncodingCache[node] = encodeResult;
  return encodeResult;
}

class TexEncodeConf extends EncodeConf {
  final Mode mode;
  final bool removeRowBracket;

  const TexEncodeConf({
    this.mode = Mode.math,
    this.removeRowBracket = false,
    Strict strict = Strict.warn,
    StrictFun strictFun,
  }) : super(strict: strict, strictFun: strictFun);

  static const mathConf = TexEncodeConf();
  static const mathParamConf = TexEncodeConf(removeRowBracket: true);
  static const textConf = TexEncodeConf(mode: Mode.text);
  static const textParamConf =
      TexEncodeConf(mode: Mode.text, removeRowBracket: true);

  TexEncodeConf math() {
    if (mode == Mode.math && !removeRowBracket) return this;
    return copyWith(mode: Mode.math, removeRowBracket: false);
  }

  TexEncodeConf mathParam() {
    if (mode == Mode.math && removeRowBracket) return this;
    return copyWith(mode: Mode.math, removeRowBracket: true);
  }

  TexEncodeConf text() {
    if (mode == Mode.text && !removeRowBracket) return this;
    return copyWith(mode: Mode.text, removeRowBracket: false);
  }

  TexEncodeConf textParam() {
    if (mode == Mode.text && removeRowBracket) return this;
    return copyWith(mode: Mode.text, removeRowBracket: true);
  }

  TexEncodeConf param() {
    if (removeRowBracket) return this;
    return copyWith(removeRowBracket: true);
  }

  TexEncodeConf ord() {
    if (!removeRowBracket) return this;
    return copyWith(removeRowBracket: false);
  }

  TexEncodeConf copyWith({
    Mode mode,
    bool removeRowBracket,
    Strict strict,
    StrictFun strictFun,
  }) =>
      TexEncodeConf(
        mode: mode ?? this.mode,
        removeRowBracket: removeRowBracket ?? this.removeRowBracket,
        strict: strict ?? this.strict,
        strictFun: strictFun ?? this.strictFun,
      );
}

String _handleArg(dynamic arg, EncodeConf conf) {
  if (arg == null) return '';
  if (arg is EncodeResult) {
    return arg.stringify(conf);
  }
  if (arg is GreenNode) {
    return encodeTex(arg).stringify(conf);
  }
  if (arg is String) return arg;
  return arg.toString();
}

class TexCommandEncodeResult extends EncodeResult {
  final String command;

  /// Accepted type: [Null], [String], [EncodeResult], [GreenNode]
  final List<dynamic> args;

  FunctionSpec _spec;
  FunctionSpec get spec => _spec ??= functions[command];

  int _numArgs;
  int get numArgs => _numArgs ??= spec.numArgs;

  int _numOptionalArgs;
  int get numOptionalArgs => _numOptionalArgs ??= spec.numOptionalArgs;

  List<Mode> _argModes;
  List<Mode> get argModes => _argModes ??= spec.argModes ??
      List.filled(numArgs + numOptionalArgs, null, growable: false);

  TexCommandEncodeResult({
    @required this.command,
    @required this.args,
    int numArgs,
    int numOptionalArgs,
  })  : _numArgs = numArgs,
        _numOptionalArgs = numOptionalArgs;

  @override
  String stringify(TexEncodeConf conf) {
    assert(this.numArgs >= this.numOptionalArgs);
    if (!spec.allowedInMath && conf.mode == Mode.math) {
      conf.reportNonstrict('command mode mismatch',
          'Text-only command $command occured in math encoding enviroment');
    }
    if (!spec.allowedInText && conf.mode == Mode.text) {
      conf.reportNonstrict('command mode mismatch',
          'Math-only command $command occured in text encoding environment');
    }
    final argString = Iterable.generate(
      numArgs + numOptionalArgs,
      (index) {
        final mode = argModes[index] ?? conf.mode;
        final string = _handleArg(args[index],
            mode == Mode.math ? conf.mathParam() : conf.textParam());
        if (index < numOptionalArgs) {
          return string.isEmpty ? '' : '[$string]';
        } else {
          return '{$string}'; // TODO optimize
        }
      },
    ).join();

    if (argString.isNotEmpty && (argString[0] == '[' || argString[0] == '{')) {
      return '$command$argString';
    } else {
      return '$command $argString';
    }
  }
}

class EquationRowTexEncodeResult extends EncodeResult {
  final List<dynamic> children;

  const EquationRowTexEncodeResult(this.children);

  @override
  String stringify(TexEncodeConf conf) {
    final content = Iterable.generate(children.length, (index) {
      final dynamic child = children[index];
      if (index == children.length - 1 && child is TexModeCommandEncodeResult) {
        return _handleArg(child, conf.param());
      }
      return _handleArg(child, conf.ord());
    }).join();
    if (conf.removeRowBracket == true) {
      return content;
    } else {
      return '{$content}';
    }
  }
}

class TransparentTexEncodeResult extends EncodeResult {
  final List<dynamic> children;

  const TransparentTexEncodeResult(this.children);

  @override
  String stringify(TexEncodeConf conf) =>
      children.map((dynamic child) => _handleArg(child, conf.ord())).join();
}

class ModeDependentEncodeResult extends EncodeResult {
  final dynamic text;

  final dynamic math;

  const ModeDependentEncodeResult({this.text, this.math});

  @override
  String stringify(TexEncodeConf conf) =>
      _handleArg(conf.mode == Mode.math ? math : text, conf);

  static String _handleArg(dynamic arg, TexEncodeConf conf) {
    if (arg == null) return '';
    if (arg is GreenNode) return arg.encodeTeX(conf: conf);
    if (arg is EncodeResult) return arg.stringify(conf);
    return arg.toString();
  }
}

class TexModeCommandEncodeResult extends EncodeResult {
  final String command;

  final List<dynamic> children;

  const TexModeCommandEncodeResult({this.command, this.children});

  @override
  String stringify(TexEncodeConf conf) {
    final content = Iterable.generate(children.length, (index) {
      final dynamic child = children[index];
      if (index == children.length - 1 && child is TexModeCommandEncodeResult) {
        return _handleArg(child, conf.param());
      }
      return _handleArg(child, conf.ord());
    }).join();
    if (conf.removeRowBracket == true) {
      return '$command $content';
    } else {
      return '{$command $content}';
    }
  }
}
