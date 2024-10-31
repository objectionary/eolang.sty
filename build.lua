-- (The MIT License)
--
-- Copyright (c) 2021-2024 Yegor Bugayenko
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the 'Software'), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

module = "eolang"
ctanupload = true
typesetopts = "-interaction=batchmode -shell-escape -halt-on-error"
checkopts = "-interaction=batchmode -shell-escape -halt-on-error"
sourcefiles = {"*.dtx", "*.ins", "*-????-??-??.sty", "eolang.pl"}
exefiles = {"eolang.pl"}
checkengines = {"pdftex", "luatex", "xetex"}
tagfiles = {"build.lua", "eolang.dtx"}
docfiles = {"cactus.pdf", "eolang.bib"}
cleanfiles = {"build", "_docshots", "*.pl.eolang", "*.run.xml", "*.log", "*.bcf", "*.glo", "*.fls", "*.idx", "*.out", "*.fdb_latexmk", "*.aux", "*.sty", "*.zip", "eolang.pdf"}
checkfiles = {"eolang.pl"}
scriptfiles  = {"eolang.pl"}
scriptmanfiles = {"eolang.1"}
tagfiles = {"eolang.dtx", "eolang.pl", "build.lua", "eolang.1"}
typesetruns = 2

uploadconfig = {
  pkg = "eolang",
  version = "0.18.2",
  author = "Yegor Bugayenko",
  uploader = "Yegor Bugayenko",
  email = "yegor256@gmail.com",
  note = "Bug fixes",
  announcement = "",
  ctanPath = "/macros/latex/contrib/eolang",
  bugtracker = "https://github.com/objectionary/eolang.sty/issues",
  home = "",
  description = "This package helps you format expressions of 𝜑-calculus and draw SODG graphs for EO programming language",
  development = "",
  license = "mit",
  summary = "Formulas and graphs for EO programming language",
  repository = "https://github.com/objectionary/eolang.sty",
  support = "",
  topic = {"program-doc", "diagram"}
}

function update_tag(file, content, tagname, tagdate)
  return string.gsub(
    string.gsub(content, "0%.0%.0", tagname),
    "2024/10/31", os.date("%Y/%m/%d")
  )
end
