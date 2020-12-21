## [0.3.0-nullsafety.0]
Migrate to dart null safety

## [0.2.1] - 2020/12/18
- Fix overflow in `cases` environment
- Fix errors caused by null text colors in `Math` widget.

## [0.2.0+2] - 2020/11/1
Add support for `TextStyle.color` in widget constructors.

## [0.2.0+1] - 2020/10/28
Fix `Math.tex` constructor's wrong default value for `MathOptions`.

## [0.2.0] - 2020/10/24
- A new `SelectableMath` widget that supports selection and copy-to-clipboard.
- A TeX encoder.
- Various performance boosts.
- fix a bug where some math functions' lower bound get dropped

### 0.2.0 API breaking change
- Major overhual on classnames.
- `baseSizeMultiplier` is removed.
- Parse errors and build errors now have correct types instead of `dynamic`. `onErrorFallback`'s signature has changed as a result.
- Exports are grouped into `widgets`, `ast`, `tex`.
For detailed information, please see [0.2.0 migration guide](doc/migration.0.2.0.md).

## [0.1.9] - 2020/10/24
With all 0.2.0 improvements, but excluding those breaking changes.

## [0.1.8+1] - 2020/9/3
- More documentations.
## [0.1.8] - 2020/9/3
- Add support for text-mode accent and unicode accents. (e.g. `ä` and `\text{\v{a}}`)
- Fix underflow issues of accents and sqrts when their child has too little height.
## [0.1.7] - 2020/8/11
- Remove need for specifying fonts in package Pubspec.
## [0.1.6+1] - 2020/8/10
## [0.1.6] - 2020/8/10
- Add support for Flutter Web (DomCanvas backend)
## [0.1.5] - 2020/8/5
- Fix breakings caused by [dart/#40674](https://github.com/dart-lang/sdk/issues/40674)
- Support Flutter 1.20.
## [0.1.4] - 2020/7/24
- Fix incorrect color for lines in \frac, \overline, \underline, and \rule
## [0.1.3] - 2020/7/12
- Dashed matrix separator will now be rendered correctly
## [0.1.2] - 2020/7/12
- Add support for composite symbols, i.e. \notin \not\lt
- Add API to indicate font size
- Fix a problem where some exceptions will not be caught
## [0.1.1] - 2020/7/7
Add `onErrorFallback` functions for `FlutterMath` widget
## [0.1.0] - 2020/7/6
Fix minor crashes
## [0.0.1+1] - 2020/7/5 
Temporarily fix the problem that pana and dartfmt will crash on this package causing zero pub score
## [0.0.1] - 2020/7/5 
Initial release.
