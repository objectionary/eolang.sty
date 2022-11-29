module = "eolang"
ctanupload = true
typesetopts = "-interaction=batchmode -shell-escape -halt-on-error"
checkopts = "-interaction=batchmode -shell-escape -halt-on-error"
checkengines = {"pdftex", "luatex", "xetex"}
tagfiles = {"build.lua", "eolang.dtx"}
docfiles = {"cactus.pdf", "eolang.bib"}
cleanfiles = {"build", "_docshots", "*.pl.eolang", "*.run.xml", "*.log", "*.bcf", "*.glo", "*.fls", "*.idx", "*.out", "*.fdb_latexmk", "*.aux", "*.sty", "*.zip", "eolang.pdf"}
typesetruns = 2

uploadconfig = {
  pkg = "eolang",
  version = "0.8.0",
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
    "0000%-00%-00", os.date("%Y-%m-%d")
  )
end
