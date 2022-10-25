[![l3build](https://github.com/objectionary/eolang.sty/actions/workflows/l3build.yml/badge.svg)](https://github.com/objectionary/eolang.sty/actions/workflows/l3build.yml)
[![CTAN](https://img.shields.io/ctan/v/eolang)](https://ctan.org/pkg/eolang)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/objectionary/eolang.sty/blob/master/LICENSE.txt)

This LaTeX package helps you write 𝜑-calculus formulas and
[SODG](https://github.com/objectionary/sodg) graphs
for [EO](https://www.eolang.org) programming language.

First, [install it](https://en.wikibooks.org/wiki/LaTeX/Installing_Extra_Packages)
from [CTAN](https://ctan.org/pkg/eolang)
and then use in the preamble:

```tex
\documentclass{article}
\usepackage{eolang}
\begin{document}
\begin{phiquation}
x -> [
  @ -> |foo|(5),
  y -> [ \lambda -> M_1 ]].
\end{phiquation}
\end{document}
```

If you want to contribute yourself, make a fork, then create a branch, 
then run `l3build ctan` in the root directory.
It should compile everything without errors. If not, submit an issue and wait.
Otherwise, make your changes and then run `l3build ctan` again. If the build is
still clean, submit a pull request.
