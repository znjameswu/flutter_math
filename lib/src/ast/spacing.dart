import 'size.dart';
import 'style.dart';

import 'syntax_tree.dart';

// class _InterAtomSpacingConf {
//   final int value;
//   final bool skipInScript;

//   Measurement get measurement => const {
//     0: Measurement(value: 0, unit: Unit.pt),
//   }[value];

//   // ignore: avoid_positional_boolean_parameters
//   const _InterAtomSpacingConf(this.value, this.skipInScript);
// }

// const _interAtomSpacing = {
//   AtomType.ord: {
//     AtomType.ord: _InterAtomSpacingConf(0, false),
//     AtomType.op: _InterAtomSpacingConf(1, false),
//     AtomType.bin: _InterAtomSpacingConf(2, true),
//     AtomType.rel: _InterAtomSpacingConf(3, true),
//     AtomType.open: _InterAtomSpacingConf(0, false),
//     AtomType.close: _InterAtomSpacingConf(0, false),
//     AtomType.punct: _InterAtomSpacingConf(0, false),
//     AtomType.inner: _InterAtomSpacingConf(1, true),
//   },
//   AtomType.op: {
//     AtomType.ord: _InterAtomSpacingConf(1, false),
//     AtomType.op: _InterAtomSpacingConf(1, false),
//     AtomType.bin: null,
//     AtomType.rel: _InterAtomSpacingConf(3, true),
//     AtomType.open: _InterAtomSpacingConf(0, false),
//     AtomType.close: _InterAtomSpacingConf(0, false),
//     AtomType.punct: _InterAtomSpacingConf(0, false),
//     AtomType.inner: _InterAtomSpacingConf(1, false),
//   },
//   AtomType.bin: {
//     AtomType.ord: _InterAtomSpacingConf(2, true),
//     AtomType.op: _InterAtomSpacingConf(2, true),
//     AtomType.bin: null,
//     AtomType.rel: null,
//     AtomType.open: _InterAtomSpacingConf(2, true),
//     AtomType.close: null,
//     AtomType.punct: null,
//     AtomType.inner: _InterAtomSpacingConf(2, true),
//   },
//   AtomType.rel: {
//     AtomType.ord: _InterAtomSpacingConf(3, true),
//     AtomType.op: _InterAtomSpacingConf(3, true),
//     AtomType.bin: null,
//     AtomType.rel: _InterAtomSpacingConf(0, false),
//     AtomType.open: _InterAtomSpacingConf(3, true),
//     AtomType.close: _InterAtomSpacingConf(0, false),
//     AtomType.punct: _InterAtomSpacingConf(0, false),
//     AtomType.inner: _InterAtomSpacingConf(3, true),
//   },
//   AtomType.open: {
//     AtomType.ord: _InterAtomSpacingConf(0, false),
//     AtomType.op: _InterAtomSpacingConf(0, false),
//     AtomType.bin: null,
//     AtomType.rel: _InterAtomSpacingConf(0, false),
//     AtomType.open: _InterAtomSpacingConf(0, false),
//     AtomType.close: _InterAtomSpacingConf(0, false),
//     AtomType.punct: _InterAtomSpacingConf(0, false),
//     AtomType.inner: _InterAtomSpacingConf(0, false),
//   },
//   AtomType.close: {
//     AtomType.ord: _InterAtomSpacingConf(0, false),
//     AtomType.op: _InterAtomSpacingConf(1, false),
//     AtomType.bin: _InterAtomSpacingConf(2, true),
//     AtomType.rel: _InterAtomSpacingConf(3, true),
//     AtomType.open: _InterAtomSpacingConf(0, false),
//     AtomType.close: _InterAtomSpacingConf(0, false),
//     AtomType.punct: _InterAtomSpacingConf(0, false),
//     AtomType.inner: _InterAtomSpacingConf(1, true),
//   },
//   AtomType.punct: {
//     AtomType.ord: _InterAtomSpacingConf(1, true),
//     AtomType.op: _InterAtomSpacingConf(1, true),
//     AtomType.bin: null,
//     AtomType.rel: _InterAtomSpacingConf(1, true),
//     AtomType.open: _InterAtomSpacingConf(1, true),
//     AtomType.close: _InterAtomSpacingConf(1, true),
//     AtomType.punct: _InterAtomSpacingConf(1, true),
//     AtomType.inner: _InterAtomSpacingConf(1, true),
//   },
//   AtomType.inner: {
//     AtomType.ord: _InterAtomSpacingConf(1, true),
//     AtomType.op: _InterAtomSpacingConf(1, false),
//     AtomType.bin: _InterAtomSpacingConf(2, true),
//     AtomType.rel: _InterAtomSpacingConf(3, true),
//     AtomType.open: _InterAtomSpacingConf(1, true),
//     AtomType.close: _InterAtomSpacingConf(0, false),
//     AtomType.punct: _InterAtomSpacingConf(1, true),
//     AtomType.inner: _InterAtomSpacingConf(1, true),
//   },
// };

const thinspace = Measurement(value: 3, unit: Unit.mu);
const mediumspace = Measurement(value: 4, unit: Unit.mu);
const thickspace = Measurement(value: 5, unit: Unit.mu);

const Map<AtomType, Map<AtomType, Measurement>> spacings = {
  AtomType.ord: {
    AtomType.op: thinspace,
    AtomType.bin: mediumspace,
    AtomType.rel: thickspace,
    AtomType.inner: thinspace,
  },
  AtomType.op: {
    AtomType.ord: thinspace,
    AtomType.op: thinspace,
    AtomType.rel: thickspace,
    AtomType.inner: thinspace,
  },
  AtomType.bin: {
    AtomType.ord: mediumspace,
    AtomType.op: mediumspace,
    AtomType.open: mediumspace,
    AtomType.inner: mediumspace,
  },
  AtomType.rel: {
    AtomType.ord: thickspace,
    AtomType.op: thickspace,
    AtomType.open: thickspace,
    AtomType.inner: thickspace,
  },
  AtomType.open: {},
  AtomType.close: {
    AtomType.op: thinspace,
    AtomType.bin: mediumspace,
    AtomType.rel: thickspace,
    AtomType.inner: thinspace,
  },
  AtomType.punct: {
    AtomType.ord: thinspace,
    AtomType.op: thinspace,
    AtomType.rel: thickspace,
    AtomType.open: thinspace,
    AtomType.close: thinspace,
    AtomType.punct: thinspace,
    AtomType.inner: thinspace,
  },
  AtomType.inner: {
    AtomType.ord: thinspace,
    AtomType.op: thinspace,
    AtomType.bin: mediumspace,
    AtomType.rel: thickspace,
    AtomType.open: thinspace,
    AtomType.punct: thinspace,
    AtomType.inner: thinspace,
  },
};

const Map<AtomType, Map<AtomType, Measurement>> tightSpacings = {
  AtomType.ord: {
    AtomType.op: thinspace,
  },
  AtomType.op: {
    AtomType.ord: thinspace,
    AtomType.op: thinspace,
  },
  AtomType.bin: {},
  AtomType.rel: {},
  AtomType.open: {},
  AtomType.close: {
    AtomType.op: thinspace,
  },
  AtomType.punct: {},
  AtomType.inner: {
    AtomType.op: thinspace,
  },
};

Measurement getSpacingSize({AtomType left, AtomType right, MathStyle style}) =>
    (style.index >= MathStyle.script.index
        ? tightSpacings[left][right]
        : spacings[left][right]) ??
    Measurement.zero;
