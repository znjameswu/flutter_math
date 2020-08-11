# Flutter Math

[![Build Status](https://travis-ci.com/znjameswu/flutter_math.svg?branch=master)](https://travis-ci.com/znjameswu/flutter_math) [![codecov](https://codecov.io/gh/znjameswu/flutter_math/branch/master/graph/badge.svg)](https://codecov.io/gh/znjameswu/flutter_math)

Math equation rendering in pure Dart & Flutter. 


This project aims to achieve maximum compatibility and fidelity with regard to the [KaTeX](https://github.com/KaTeX/KaTeX) project, while maintaining the performance advantage of Dart and Flutter. A furthur [UnicodeMath](https://www.unicode.org/notes/tn28/UTN28-PlainTextMath-v3.1.pdf)-style equation editing support will be experimented in the future.


The TeX parser is a completely rewritten Dart port of the KaTeX parser, with almost full features. There are only a few differences. List of some unsupported features can be found [here](doc/unsupported.md).

## [Online Demo](https://znjameswu.github.io/flutter_math_demo/)

## Rendering Samples

`x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}`

![Example1](doc/img/delta.png)

`i\hbar\frac{\partial}{\partial t}\Psi(\vec x,t) = -\frac{\hbar}{2m}\nabla^2\Psi(\vec x,t)+ V(\vec x)\Psi(\vec x,t)`

![Example2](doc/img/schrodinger.png)

`\hat f(\xi) = \int_{-\infty}^\infty f(x)e^{- 2\pi i \xi x}\mathrm{d}x`

![Example3](doc/img/fourier.png)


## How to use
Add the following font resources into your pubspec.yaml (under the root `flutter:` tag, not `dependencies:  flutter:`)
```yaml
flutter:

  // ......

  fonts:
    - family: KaTeX_Main
      fonts:
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Main-Regular.ttf
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Main-Italic.ttf
          style: italic
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Main-Bold.ttf
          weight: 700
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Main-BoldItalic.ttf
          weight: 700
          style: italic
    - family: KaTeX_Math
      fonts:
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Math-Italic.ttf
          style: italic
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Math-BoldItalic.ttf
          weight: 700
          style: italic
    - family: KaTeX_AMS
      fonts:
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_AMS-Regular.ttf
    - family: KaTeX_Caligraphic
      fonts:
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Caligraphic-Regular.ttf
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Caligraphic-Bold.ttf
          weight: 700
    - family: KaTeX_Fraktur
      fonts:
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Fraktur-Regular.ttf
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Fraktur-Bold.ttf
          weight: 700
    - family: KaTeX_SansSerif
      fonts:
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_SansSerif-Regular.ttf
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_SansSerif-Bold.ttf
          weight: 700
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_SansSerif-Italic.ttf
          style: italic
    - family: KaTeX_Script
      fonts:
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Script-Regular.ttf
    - family: KaTeX_Typewriter
      fonts:
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Typewriter-Regular.ttf
    - family: KaTeX_Size1
      fonts:
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Size1-Regular.ttf
    - family: KaTeX_Size2
      fonts:
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Size2-Regular.ttf
    - family: KaTeX_Size3
      fonts:
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Size3-Regular.ttf
    - family: KaTeX_Size4
      fonts:
        - asset: packages/flutter_math/katex_fonts/fonts/KaTeX_Size4-Regular.ttf
```
### Mobile
Currently only Android platform has been tested. If you encounter any issues with iOS, please file them.

### Web
Web supported is added in v0.1.7. It is tested for DomCanvas backend. In general it should behave largely the same with mobile. It is expected to break with CanvasKit backend. Check out the [Online Demo](https://znjameswu.github.io/flutter_math_pages/)

## API usage
Currently the usage is straightforward. Just `FlutterMath.fromTexString(r'\frac a b')`. There is also optional arguments of `Options` and `Settings`, which correspond to Options and Settings in KaTeX and support a subset of their features.

Display-style equations:
```dart
FlutterMath.fromTexString(r'\frac a b', options: Options.displayOptions)
```

In-line equations
```dart
FlutterMath.fromTexString(r'\frac a b', options: Options.textOptions)
```

You can also resize the output by providing `baseSizeMultiplier` parameter. (This parameter will also affect the size of absolute unit used in the equation. You can obtain the approximate font size for normal-sized letters by `Options.fontSize`.)

```dart
FlutterMath.fromTexString(
  r'\frac a b', 
  options: Options(
    style: MathStyle.display, 
    baseSizeMultiplier: 1.5,
  ),
)
```

If you would like to display custom styled error message or handle them differently, you should use `onErrorFallback` parameter

```dart
FlutterMath.fromTexString(
  r'\garbled $tring', 
  onErrorFallback: (errMsg) => Text(errMsg), // You can also invoke your handler here
)
```

## Credits
This project is possible thanks to the inspirations and resources from [the KaTeX Project](https://katex.org/), [MathJax](www.mathjax.org), and [Zefyr](https://github.com/memspace/zefyr).

## Goals
- [x] : TeX math parsing (See [design doc](doc/design.md))
- [x] : AST rendering in flutter
- [ ] : TeX output
- [ ] : [UnicodeMath](https://www.unicode.org/notes/tn28/UTN28-PlainTextMath-v3.1.pdf)-style editing
- [ ] : UnicodeMath parsing and encoding
- [ ] : Breakable equations
- [ ] : MathML parsing and encoding