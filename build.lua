module = "eolang"
ctanupload = true
typesetopts = "--interaction=batchmode --shell-escape"
checkopts = "--interaction=batchmode --shell-escape"
checkengines = {"pdftex"}
tagfiles = {"build.lua", "eolang.dtx"}
docfiles = {"cactus.pdf", "main.bib"}
cleanfiles = {"build", "_docshots", "*.pl.eolang", "*.run.xml", "*.log", "*.bcf", "*.glo", "*.fls", "*.idx", "*.out", "*.fdb_latexmk", "*.aux", "*.sty", "*.zip", "eolang.pdf"}
typesetruns = 2

uploadconfig = {
  pkg = "eolang",
  version = "0.0.1",
  author = "Yegor Bugayenko",
  uploader = "Yegor Bugayenko",
  email = "yegor256@gmail.com",
  note = "Bug fixes",
  announcement = "",
  ctanPath = "/macros/latex/contrib/eolang",
  bugtracker = "https://github.com/yegor256/eolang.sty/issues",
  home = "",
  description = "This package helps you format expressions of 𝜑-calculus and draw SODG graphs for EO programming language",
  development = "",
  license = "mit",
  summary = "Formulas and graphs of 𝜑-calculus",
  repository = "https://github.com/yegor256/eolang.sty",
  support = "",
  topic = {"graph"}
}

function update_tag(file, content, tagname, tagdate)
  return string.gsub(
    string.gsub(content, "0%.0%.0", tagname),
    "0000%-00%-00", os.date("%Y-%m-%d")
  )
end
