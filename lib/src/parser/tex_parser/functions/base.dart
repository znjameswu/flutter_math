library latex_base;

import 'package:meta/meta.dart';


import '../../../ast/nodes/accent.dart';
import '../../../ast/nodes/accent_under.dart';
import '../../../ast/nodes/atom.dart';
import '../../../ast/nodes/enclosure.dart';
import '../../../ast/nodes/frac.dart';
import '../../../ast/nodes/function.dart';
import '../../../ast/nodes/left_right.dart';
import '../../../ast/nodes/multiscripts.dart';
import '../../../ast/nodes/nary_op.dart';
import '../../../ast/nodes/over.dart';
import '../../../ast/nodes/phantom.dart';
import '../../../ast/nodes/raise_box.dart';
import '../../../ast/nodes/space.dart';
import '../../../ast/nodes/sqrt.dart';
import '../../../ast/nodes/stretchy_op.dart';
import '../../../ast/nodes/style.dart';
import '../../../ast/nodes/under.dart';
import '../../../ast/options.dart';
import '../../../ast/size.dart';
import '../../../ast/style.dart';
import '../../../ast/syntax_tree.dart';
import '../../../ast/types.dart';
import '../define_environment.dart';
import '../font.dart';
import '../functions.dart';
import '../parse_error.dart';
import '../parser.dart';
import '../symbols.dart';

part 'base/accent.dart';
part 'base/accent_under.dart';
part 'base/arrow.dart';
part 'base/array.dart';
part 'base/break.dart';
part 'base/color.dart';
part 'base/cr.dart';
part 'base/delimsizing.dart';
part 'base/enclose.dart';
part 'base/environment.dart';
part 'base/font.dart';
part 'base/genfrac.dart';
part 'base/horiz_brace.dart';
part 'base/kern.dart';
part 'base/math.dart';
part 'base/op.dart';
part 'base/operator_name.dart';
part 'base/phantom.dart';
part 'base/raise_box.dart';
part 'base/sizing.dart';
part 'base/sqrt.dart';
part 'base/styling.dart';
part 'base/text.dart';

const baseFunctionEntries = {
  ..._accentEntries,
  ..._accentUnderEntries,
  ..._arrowEntries,
  ..._breakEntries,
  ..._colorEntries,
  ..._crEntries,
  ..._delimSizingEntries,
  ..._encloseEntries,
  ..._environmentEntries,
  ..._fontEntries,
  ..._genfracEntries,
  ..._horizBraceEntries,
  ..._kernEntries,
  ..._mathEntries,
  ..._opEntries,
  ..._operatorNameEntries,
  ..._phantomEntries,
  ..._raiseBoxEntries,
  ..._sizingEntries,
  ..._sqrtEntries,
  ..._stylingEntries,
  ..._textEntries,
};
