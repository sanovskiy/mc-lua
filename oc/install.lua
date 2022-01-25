local fs = require("filesystem")
local component = require("component")
local computer = require("computer")
local internet = require("internet")
local shell = require("shell")
local math = require('math')

if not component.isAvailable("internet") then
  io.stderr:write("This program requires an internet card to run.")
  return
end

local repo_path = "https://raw.githubusercontent.com/sanovskiy/mc-lua/master/oc"

local filesToLoad = {
  ['/lib/sanstring.lua'] = repo_path..'/sanlib/sanstring.lua',
  ['/lib/santable.lua'] = repo_path..'/sanlib/santable.lua',
  ['/lib/sanfs.lua'] = repo_path..'/sanlib/sanfs.lua',
  ['/bin/san-get.lua'] = repo_path..'/san-get.lua'
}

-- local randstr = '?'..tostring(math.floor(math.random()*100000))
local randstr = ''

for path,url in pairs(filesToLoad) do
  if fs.exists(path) then
    fs.remove(path)
  end
  shell.execute('wget \''..url..randstr..'\' '..path)
end
shell.execute('san-get update')
shell.execute('san-get install sanlib')
shell.execute('san-get install san-get')

io.write('Installed')
os.sleep(3)
computer.shutdown(true)

--[[ uninstall it
local filesToDelete = {
  '/lib/sanstring.lua',
  '/lib/santable.lua',
  '/lib/sanfs.lua',
  '/bin/san-get.lua',
  '/etc/san-get/installed.list',
  '/etc/san-get/packages.list',
  '/etc/san-get/'
}
for _,path in pairs(filesToDelete) do
  if fs.exists(path) then
    fs.remove(path)
    io.write('Deleted '..path..'\n')
  end
end

]]