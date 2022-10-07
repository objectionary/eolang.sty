[![l3build](https://github.com/yegor256/phigures/actions/workflows/l3build.yml/badge.svg)](https://github.com/yegor256/phigures/actions/workflows/l3build.yml)
[![CTAN](https://img.shields.io/ctan/v/phigures)](https://ctan.org/pkg/phigures)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/phigures/blob/master/LICENSE.txt)

This LaTeX package helps you write 𝜑-calculus formulas and graphs.

First, [install it](https://en.wikibooks.org/wiki/LaTeX/Installing_Extra_Packages)
from [CTAN](https://ctan.org/pkg/phigures)
and then use in the preamble:

```tex
\documentclass{article}
\usepackage{phigures}
\begin{document}
\begin{phiquation}
x -> [
  \varphi -> |foo|(5),
  y -> [ \lambda -> M_1 ]].
\end{phiquation}
\end{document}
```

If you want to contribute yourself, make a fork, then create a branch, 
then run `make` in the root directory.
It should compile everything without errors. If not, submit an issue and wait.
Otherwise, make your changes and then run `make` again. If the build is
still clean, submit a pull request.
