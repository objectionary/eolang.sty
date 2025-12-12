-- SPDX-FileCopyrightText: Copyright (c) 2021-2025 Yegor Bugayenko
-- SPDX-License-Identifier: MIT

module = "eolang"
ctanupload = true
typesetopts = "-interaction=batchmode -shell-escape -halt-on-error"
checkopts = "-interaction=batchmode -shell-escape -halt-on-error"
sourcefiles = {"*.dtx", "*.ins", "*-????-??-??.sty", "eolang.pl"}
exefiles = {"eolang.pl"}
checkengines = {"pdftex"}
-- checkengines = {"pdftex", "luatex", "xetex"}
tagfiles = {"build.lua", "eolang.dtx"}
docfiles = {"cactus.pdf", "eolang.bib"}
cleanfiles = {"build", "_docshots", "*.pl.eolang", "*.run.xml", "*.log", "*.bcf", "*.glo", "*.fls", "*.idx", "*.out", "*.fdb_latexmk", "*.aux", "*.sty", "*.zip", "eolang.pdf"}
checkfiles = {"eolang.pl"}
scriptfiles  = {"eolang.pl"}
scriptmanfiles = {"eolang.1"}
tagfiles = {"eolang.dtx", "eolang.pl", "build.lua", "eolang.1"}
typesetruns = 1
checkruns = 1

uploadconfig = {
  pkg = "eolang",
  version = "0.20.3",
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
    "2025/12/12", os.date("%Y/%m/%d")
  )
end

-- Run all Perl test scripts before packaging
function ctan_pre_action()
  print("Running Perl test scripts from tests/ directory...")
  local handle = io.popen("ls -1 tests/*.pl")
  local result = handle:read("*a")
  handle:close()
  for script in string.gmatch(result, "([^\n]+)") do
    print("Running " .. script)
    os.execute("perl " .. script)
    if not os.execute("perl " .. script) then
      error("Test script " .. script .. " failed!")
    end
  end
  return true
end
