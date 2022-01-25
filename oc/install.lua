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

local filesToLoad = {
  ['/lib/sanstring.lua'] = 'https://bitbucket.org/sanovskiy/minecraft-lua/raw/master/oc/sanlib/sanstring.lua',
  ['/lib/santable.lua'] = 'https://bitbucket.org/sanovskiy/minecraft-lua/raw/master/oc/sanlib/santable.lua',
  ['/lib/sanfs.lua'] = 'https://bitbucket.org/sanovskiy/minecraft-lua/raw/master/oc/sanlib/sanfs.lua',
  ['/bin/san-get.lua'] = 'https://bitbucket.org/sanovskiy/minecraft-lua/raw/master/oc/san-get/san-get.lua'
}

local randstr = '?'..tostring(math.floor(math.random()*100000))

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