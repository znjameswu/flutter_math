part of '../functions.dart';

EncodeResult _styleEncoder(GreenNode node) {
  final styleNode = node as StyleNode;
  return _optionsDiffEncode(styleNode.optionsDiff, styleNode.children);
}

EncodeResult _optionsDiffEncode(OptionsDiff diff, List<dynamic> children) {
  EncodeResult res = TransparentTexEncodeResult(children);

  if (diff.size != null) {
    final sizeCommand = _sizeCommands[diff.size];
    res = TexModeCommandEncodeResult(
      command: sizeCommand ?? '\\tiny',
      children: <dynamic>[res],
    );
    if (sizeCommand == null) {
      res = NonStrictEncodeResult(
        'imprecise size',
        'Non-strict MethSize encountered during TeX encoding: '
            '${diff.size}',
        res,
      );
    }
  }

  if (diff.style != null) {
    final styleCommand = _styleCommands[diff.style];
    res = TexModeCommandEncodeResult(
      command: styleCommand ?? _styleCommands[diff.style.uncramp()],
      children: <dynamic>[res],
    );
    if (styleCommand == null) {
      NonStrictEncodeResult(
        'imprecise style',
        'Non-strict MathStyle encountered during TeX encoding: '
            '${diff.style}',
        res,
      );
    }
  }

  if (diff.textFontOptions != null) {
    final command = texTextFontOptions.entries
        .firstWhereOrNull((entry) => entry.value == diff.textFontOptions)
        ?.key;
    if (command == null) {
      res = NonStrictEncodeResult(
        'unknown font',
        'Unrecognized text font encountered during TeX encoding: '
            '${diff.textFontOptions}',
        res,
      );
    } else {
      res = TexCommandEncodeResult(
        command: command,
        args: <dynamic>[res],
      );
    }
  }

  if (diff.mathFontOptions != null) {
    final command = texMathFontOptions.entries
        .firstWhereOrNull((entry) => entry.value == diff.mathFontOptions)
        ?.key;
    if (command == null) {
      res = NonStrictEncodeResult(
        'unknown font',
        'Unrecognized math font encountered during TeX encoding: '
            '${diff.mathFontOptions}',
        res,
      );
    } else {
      res = TexCommandEncodeResult(
        command: command,
        args: <dynamic>[res],
      );
    }
  }
  if (diff.color != null) {
    res = TexCommandEncodeResult(
      command: '\\textcolor',
      args: <dynamic>[
        '#${diff.color.value.toRadixString(16).padLeft(6, '0')}',
        res,
      ],
    );
  }
  return res;
}

const _styleCommands = {
  MathStyle.display: '\\displaystyle',
  MathStyle.text: '\\textstyle',
  MathStyle.script: '\\scriptstyle',
  MathStyle.scriptscript: '\\scriptscriptstyle'
};

const _sizeCommands = {
  SizeMode.tiny: '\\tiny',
  SizeMode.size2: '\\tiny',
  SizeMode.scriptsize: '\\scriptsize',
  SizeMode.footnotesize: '\\footnotesize',
  SizeMode.small: '\\small',
  SizeMode.normalsize: '\\normalsize',
  SizeMode.large: '\\large',
  SizeMode.Large: '\\Large',
  SizeMode.LARGE: '\\LARGE',
  SizeMode.huge: '\\huge',
  SizeMode.HUGE: '\\HUGE',
};

final _mathFontCommands = {
  // styles, except \boldsymbol defined below
  '\\mathrm', '\\mathit', '\\mathbf', //'\\mathnormal',

  // families
  '\\mathbb', '\\mathcal', '\\mathfrak', '\\mathscr', '\\mathsf',
  '\\mathtt',
};

final _textFontCommands = {
  // Font families
  // '\\text',
  '\\textrm', '\\textsf', '\\texttt', '\\textnormal',
  // Font weights
  '\\textbf', '\\textmd',
  // Font Shapes
  '\\textit', '\\textup',
};
