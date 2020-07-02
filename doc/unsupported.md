
## Won't support functionalities
- `\href`
- `\includegraphics`
- `\lap` and other horizontal lapping command (This will probably be reconsidered in the future)
- `\mathchoice` and dependent features
- `\smash`
- `\overlinesegment`, `\underlinesegment`
- `\pmb`
- `\hspace*`
- Exotic composite symbols: `\Coloneqq, \coloneq, \Coloneq, \Eqqcolon, \Eqcolon, \colonapprox, \Colonapprox, \colonsim, \Colonsim, \simcolon, \simcoloncolon, \approxcolon, \approxcoloncolon`, and also their equivalent `\coloncolonequals` ...

## Functionalities that will be supported later
- **Text-mode accent**
- Composite operators (e.g. negated operators, \not)
- Composite symbols drawn by macros using horizontal lapping
- `gather` environment
- `\@char` char input by unicode

## Known render differences to KaTeX
- Math functions with limit-like subscript and superscript will not adapt to sub/sup under/over styles under different styles. This breaks TeX spec. This is due to the design of AST, and is in accordance with UnicodeMath designs.
- Multiple `\hlines` and `||` column separators for matrices will not be supported, just as MathJax won't either.
- `\genfrac`'s delimiters will have a larger spacing with inner node. (This might be fixed in future)
- `\color` commands inside a block will NOT be applied to right delimiters. This is in line with MathJax rather than KaTeX. 
- The parsing behavior of `\overbrace` and `\underbase` with sub-sup pairs will be in line with MathJax rather than KaTeX. (Possibly KaTeX bug?)
- `\colon`'s behavior will be in line with MathJax rather than KaTeX.
- Due to the lack of `\mathchoice`, `\pod`, `\pmod`, `\mod` will have fixed spacing.
- `\dfrac`, `\tfrac` ... will have slight size deviation from KaTeX and will be in line with MathJax's rendering behavior. 
- There will be no automatic thinspace between `\cdots` and right delimiter, (which is odd. MathJax and Tex don't have them either)


Any other deviations from KaTeX will be considered as bug.