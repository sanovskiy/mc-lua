__programName = shell.getRunningProgram()

if not(fs.exists("/etc")) then
  fs.makeDir("/etc")
else
  if not(fs.isDir("/etc")) then
    fs.delete("/etc")
    fs.makeDir("/etc")
  end
end

if not(fs.exists("/etc/kubachos")) then
  fs.makeDir("/etc/kubachos")
else
  if not(fs.isDir("/etc/kubachos")) then
    fs.delete("/etc/kubachos")
    fs.makeDir("/etc/kubachos")
  end
end

__config_file = "/etc/kubachos/config";

function Clear()
 term.clear()
 term.setCursorPos(1,1)
end

function drawLogo()
  term.setBackgroundColor(colors.white)
  term.setTextColor(colors.blue)
  term.clear()
  term.setCursorPos(1,7)
  -- print("    _  __     _                _        ____   _____ ")
  -- print("   | |/ /    | |              | |      / __ \\ / ____|")
  -- print("   | ' /_   _| |__   __ _  ___| |__   | |  | | (___  ")
  -- print("   |  <| | | | '_ \\ / _' |/ __| '_ \\  | |  | |\\___ \\ ")
  -- print("   | . \\ |_| | |_) | (_| | (__| | | | | |__| |____) |")
  -- print("   |_|\\_\\__,_|_.__/ \\__,_|\\___|_| |_|  \\____/|_____/ ")
  print("     __ __     __            __     ____  ____")
  print("    / // /_ __/ /  ___ _____/ /    / __ \\/ __/")
  print("   / ,< / // / _ \\/ _ '/ __/ _ \\  / /_/ /\\ \\  ")
  print("  /_/|_|\\_,_/_.__/\\_,_/\\__/_//_/  \\____/___/  ")
  cycle={"-","\\","|","/"}
  for i=1,60 do
  term.setCursorPos(22,12)
  cur = i%4+1
  print("Loading " .. cycle[cur])
  sleep(0.05)
  end
  -- sleep(3)
end
drawLogo()

-- kubachwrpper
Menu = {}
if fs.exists("mcwarp") then
  table.insert(Menu,{Name="Let's warp to space!",Command="mcwarp"})
end
if fs.exists("oldmcwarp") then
  table.insert(Menu,{Name="Let's warp to space!",Command="oldmcwarp"})
end
if fs.exists("mineos2") then
  table.insert(Menu,{Name="Wanna diamonds?",Command="mineos2"})
elseif fs.exists("mineos1") then 
  table.insert(Menu,{Name="Wanna diamonds?",Command="mineos1"})
end
table.insert(Menu,{Name="Update",Command="san-get update "..__programName})
table.insert(Menu,{Name="Reboot",Command="reboot"})

currentMenuChoice=1
shell.run("rm","startup")
sfile= fs.open("startup", "w") or error("Cannot open file startup.conf", 2)
sfile.write("shell.run(\""..__programName.."\")")
sfile.close()

local function saveConfig(table, file)
  local fConfig = fs.open(file, "w") or error("Cannot open file "..file, 2)
  fConfig.write(textutils.serialize(table))
  fConfig.close()
end
local function loadConfig(file)
  local fConfig = fs.open(file, "r")
  local ret = textutils.unserialize(fConfig.readAll())
  fConfig.close()
  return ret
end
if fs.exists(__config_file) then
  cfg=loadConfig(__config_file)
else
  cfg={}
  cfg["startup"] = nil
  saveConfig(cfg, __config_file)
end
if cfg["startup"]~=nil and cfg["startup"]~="reboot" then
  shell.run(cfg["startup"])
end

function Clear()
 term.clear()
 term.setCursorPos(1,1)
end
function drawButton(cX,cY,Text,color,bgcolor,inverted)
  inverted = inverted or false
  term.setCursorPos(cX,cY)
  if not(inverted) then
    term.setBackgroundColor(bgcolor)
    term.setTextColor(color)
  else
    term.setBackgroundColor(color)
    term.setTextColor(bgcolor)
  end
  term.write("+"..string.rep("-", string.len(Text)+2).."+")
  term.setCursorPos(cX,cY+1)
  term.write("+ "..Text.." +")
  term.setCursorPos(cX,cY+2)
  term.write("+"..string.rep("-", string.len(Text)+2).."+")
end

function drawMenu()
  term.setBackgroundColor(colors.blue)
  Clear()
  local termW, termH = term.getSize()
  local summButtSize = (#Menu*3) + (#Menu-1)
  cY = math.floor((termH-summButtSize)/2)
  maxButtonWidth = 0
  for i=1,#Menu do
     if maxButtonWidth<string.len(Menu[i]["Name"]) then
       maxButtonWidth = string.len(Menu[i]["Name"])
     end
  end
  cX = math.floor((termW-(maxButtonWidth+4))/2)
  for i=1,#Menu do
    inverted = false
    if i==currentMenuChoice then
      inverted = true
    end
    local lChop = math.floor((maxButtonWidth-string.len(Menu[i]["Name"]))/2)
    local rChop = maxButtonWidth - string.len(Menu[i]["Name"]) - lChop
    if lChop<0 then
      lChop=0
    end
    if rChop<0 then
      rChop=0
    end
    drawButton(cX,cY,string.rep(" ",lChop)..Menu[i]["Name"]..string.rep(" ",rChop),colors.black,colors.white,inverted)
    cY=cY+4
  end
end

while true do
  drawMenu()
  local event, keycode = os.pullEvent("key")
  if keycode == 200 then
    if currentMenuChoice==1 then
      currentMenuChoice=#Menu
    else
      currentMenuChoice=currentMenuChoice-1
    end
  elseif keycode == 208 or keycode==15 then  
    if currentMenuChoice==#Menu then
      currentMenuChoice=1
    else
      currentMenuChoice=currentMenuChoice+1
    end
  elseif keycode == 57 or keycode == 28 then
    Clear()
    cfg["startup"] = Menu[currentMenuChoice]["Command"]
    saveConfig(cfg, __config_file)
    shell.run(Menu[currentMenuChoice]["Command"])
    cfg["startup"] = nil
    saveConfig(cfg, __config_file)
  end
end