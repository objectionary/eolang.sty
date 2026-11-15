-- SPDX-FileCopyrightText: Copyright (c) 2021-2026 Yegor Bugayenko
-- SPDX-License-Identifier: MIT

kpse.set_program_name("kpsewhich")
dofile(assert(kpse.lookup("l3build-file-functions.lua", {format = "lua"})))
dofile("build.lua")

-- Release metadata must use the date requested by l3build.
assert(update_tag("eolang.pl", "0.0.0 0000-00-00", "1.2.3", "2001-02-03") ==
  "1.2.3 2001-02-03", "The supplied release date must be preserved")

-- Use l3build's real directory enumeration, but reject Unix shell commands.
io.popen = function(command)
  error("CTAN test discovery must not invoke a shell: " .. command)
end
local commands = {}
os.execute = function(command)
  assert(command:match("^perl tests/[^/]+%.pl$"), command)
  commands[command] = true
  return true
end
assert(ctan_pre_action())
local scripts = filelist("tests", "*.pl")
assert(#scripts > 0, "Expected Perl test fixtures")
for _, script in ipairs(scripts) do
  assert(commands["perl tests/" .. script], "Test not executed: " .. script)
end
assert(not commands["perl tests/test_tools.pm"], "Must only run Perl test scripts")

-- An empty test directory must not attempt to execute a literal glob.
filelist = function(path, glob)
  assert(path == "tests" and glob == "*.pl")
  return {}
end
os.execute = function()
  error("No scripts should run for an empty directory")
end
assert(ctan_pre_action())

-- A discovered test failure must still abort packaging.
filelist = function() return {"failing-test.pl"} end
os.execute = function() return nil, "exit", 1 end
local ok, message = pcall(ctan_pre_action)
assert(not ok and message:match("tests/failing%-test%.pl failed!"), message)
print("CTAN hook regression tests passed")
