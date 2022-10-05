module = "phigures"
ctanupload = true
typesetopts = "--interaction=batchmode --shell-escape"
checkopts = "--interaction=batchmode --shell-escape"
tagfiles = {"build.lua", "phigures.dtx"}

uploadconfig = {
  pkg = "phigures",
  version = "0.0.0",
  author = "Yegor Bugayenko",
  uploader = "Yegor Bugayenko",
  email = "yegor256@gmail.com",
  note = "Bug fixes",
  announcement = "",
  ctanPath = "/macros/latex/contrib/phigures",
  bugtracker = "https://github.com/yegor256/phigures/issues",
  home = "",
  description = "This package helps you format expressions of 𝜑-calculus and draw SOT graphs",
  development = "",
  license = "mit",
  summary = "Formulas and graphs of 𝜑-calculus",
  repository = "https://github.com/yegor256/phigures",
  support = "",
  topic = {"graph"}
}

function update_tag(file, content, tagname, tagdate)
  return string.gsub(
    string.gsub(content, "0%.0%.0", tagname),
    "0000%-00%-00", os.date("%d.%m.%Y")
  )
end
