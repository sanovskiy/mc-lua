args = {...}
command = args[1]
args[2] = args[2] or "san-get"
programs = {}
programs["cls"] = "cc/cls.lua"
programs["fills"] = "cc/fills.lua"
programs["san-pb"] = "cc/san-pb.lua"
programs["san-bb"] = "cc/san-bb.lua"
programs["san-get"] = "cc/san-get.lua"
programs["kubachos"] = "cc/kubachos.lua"
programs["mcwarp"] = "cc/mcwarp.lua"
programs["oldmcwarp"] = "cc/oldmcwarp.lua"
programs["mineos1"] = "cc/mineos1.lua"
programs["mineos2"] = "cc/mineos2.lua"
programs["reactorctl"] = "cc/reactorctl.lua"
programs["debug"] = "cc/apis/debug.lua"
programs["shum"] = "cc/shum.lua"
-- programs[""] = ""

if not(fs.exists("san-bb")) then
  print("Initial install...")
  shell.run("pastebin","get gK3LCMmC san-bb")
end
function exec(cmd,params)
  shell.run(cmd,params)
end
function update(program,url)
  print("Removing old version of "..program)
  exec("rm",program)
  install(program,url)
end
function install(program,url)
  print("Installing "..program)
  exec("san-bb","get "..url.." "..program)
end
if command=="update" then
  if programs[args[2]] ~= nil then
    update(args[2],programs[args[2]])
  else
    error("Program "..args[2].." not found in repo")
  end
elseif command=="install" then
  if programs[args[2]] ~= nil then
    if fs.exists(args[2]) then
      update(args[2],programs[args[2]])
    else
      install(args[2],programs[args[2]])
    end
  else
    error("Program "..args[2].." not found in repo")
  end
end