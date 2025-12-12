# LaTeX package for EOLANG and 𝜑-calculus

[![l3build](https://github.com/objectionary/eolang.sty/actions/workflows/l3build.yml/badge.svg)](https://github.com/objectionary/eolang.sty/actions/workflows/l3build.yml)
[![CTAN](https://img.shields.io/ctan/v/eolang)](https://ctan.org/pkg/eolang)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/objectionary/eolang.sty/blob/master/LICENSE.txt)

This LaTeX package helps you write [𝜑-calculus] formulas and
draw [SODG] graphs for [EOLANG] programming language.

First, [install it][install] from [CTAN] and then use in the preamble:

```tex
\documentclass{article}
\usepackage{eolang}
\begin{document}
\begin{phiquation}
x -> [
  @ -> foo(5),
  y -> [ L> M_1 ]].
\end{phiquation}
\end{document}
```

Otherwise, you can download [`eolang.sty`][sty] and add to your project.

If you want to contribute yourself, make a fork, then create a branch,
then run `l3build ctan` in the root directory.
It should compile everything without errors. If not, submit an issue and wait.
Otherwise, make your changes and then run `l3build ctan` again. If the build is
still clean, submit a pull request.

Currently, @yegor256 is the maintainer of the project.

[install]: https://en.wikibooks.org/wiki/LaTeX/Installing_Extra_Packages
[sty]: https://objectionary.github.io/eolang.sty/eolang.sty
[𝜑-calculus]: https://arxiv.org/abs/2111.13384
[EOLANG]: https://www.eolang.org
[SODG]: https://github.com/objectionary/sodg
[CTAN]: https://ctan.org/pkg/eolang
