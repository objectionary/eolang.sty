module = "phi"
ctanupload = true
typesetopts = "--interaction=batchmode --shell-escape"
checkopts = "--interaction=batchmode --shell-escape"
checkengines = {"pdftex", "luatex"}
tagfiles = {"build.lua", "phi.dtx"}
docfiles = {"cactus.pdf", "main.bib"}
cleanfiles = {"*.glo", "*.fls", "*.idx", "*.out", "*.fdb_latexmk", "*.aux", "*.sty", "*.zip", "phi.pdf"}
typesetruns = 2

uploadconfig = {
  pkg = "phi",
  version = "0.0.0",
  author = "Yegor Bugayenko",
  uploader = "Yegor Bugayenko",
  email = "yegor256@gmail.com",
  note = "Bug fixes",
  announcement = "",
  ctanPath = "/macros/latex/contrib/phi",
  bugtracker = "https://github.com/yegor256/phi/issues",
  home = "",
  description = "This package helps you format expressions of 𝜑-calculus and draw SOT graphs for EO programming language",
  development = "",
  license = "mit",
  summary = "Formulas and graphs of 𝜑-calculus",
  repository = "https://github.com/yegor256/phi",
  support = "",
  topic = {"graph"}
}

function update_tag(file, content, tagname, tagdate)
  return string.gsub(
    string.gsub(content, "0%.0%.0", tagname),
    "0000%-00%-00", os.date("%d.%m.%Y")
  )
end
