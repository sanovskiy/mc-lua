os.loadAPI("debug")

-- CONSTANTS
__programName = shell.getRunningProgram()
__const = {}
__const.product_name = "Miner OS"
__const.version = "2.1"
__const.defaultBGcolor = colors.green
__const.defaultFGcolor = colors.black

-- FUNCTIONS 
function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function split(pString, pPattern)
  local Table = {}
  local fpat = "(.-)" .. pPattern
  local last_end = 1
  local s, e, cap = pString:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
      table.insert(Table,cap)
    end
    last_end = e+1
    s, e, cap = pString:find(fpat, last_end)
  end
  if last_end <= #pString then
    cap = pString:sub(last_end)
    table.insert(Table, cap)
  end
  return Table
end

local modem
local monitor
function scanMiners ()
  print("Scanning network...")
  local list = {}
  local n = 1
  local peripherals = peripheral.getNames()
  for i = 1, #peripherals do
    if peripheral.getType(peripherals[i]) == "mininglaser" then
      n = n + 1
      table.insert(list,peripherals[i])
    elseif peripheral.getType(peripherals[i]) == "modem" then
      modem = peripheral.wrap(peripherals[i])
    elseif peripheral.getType(peripherals[i]) == "monitor" then
      monitor = peripheral.wrap(peripherals[i])
    end
  end
  print(tostring(#list).." miners found")
  return list
end

function saveFile(t, file)
  local fConfig = fs.open(file, "w") or error("Cannot open file "..file, 2)
  fConfig.write(textutils.serialize(t))
  fConfig.close()
end

function loadFile(file)
  local fConfig = fs.open(file, "r")
  local ret = textutils.unserialize(fConfig.readAll())
  fConfig.close()
  return ret
end

function getLongest( _table )
  local longest = 0
  for index,c_text in pairs( _table ) do
    longest = #c_text > longest and #c_text or longest
  end
  return longest + 1
end

__mineosConfig = {}

if not(fs.exists("/etc")) then
  fs.makeDir("/etc")
else
  if not(fs.isDir("/etc")) then
    fs.delete("/etc")
    fs.makeDir("/etc")
  end
end

if not(fs.exists("/etc/mineos2")) then
  fs.makeDir("/etc/mineos2")
else
  if not(fs.isDir("/etc/mineos2")) then
    fs.delete("/etc/mineos2")
    fs.makeDir("/etc/mineos2")
  end
end

__mineos_config_file = "/etc/mineos2/mineos.conf";
__groups_config_file = "/etc/mineos2/miner_groups.dat";

if fs.exists(__mineos_config_file) then
  __mineosConfig=loadFile(__mineos_config_file)
else
  __mineosConfig={
    BGColor=__const.defaultBGcolor,
    FGColor=__const.defaultFGcolor
  }
  saveFile(__mineosConfig, __mineos_config_file)
end

function initialize()
  if fs.exists(__groups_config_file) then
    registry["groups"]=loadFile(__groups_config_file)
  else
    registry["groups"]={{name="All",list="*"}}
    saveFile(registry["groups"], __groups_config_file)
  end

  registry["currentGroup"] = 1
  registry['main_section'] = "mainstats"
  registry["miner_ids"] = scanMiners()
end

function menu( _term, _table, startX, startY )
  sX, sY = _term.getSize()
  local function printMenu(_term, _table, long, sel, yPos )
    _term.clear()
    --for index, text in pairs( _table ) do
    --  _term.setCursorPos( startX, startY + index - 1 )
    --  write( ( index == sel and '[ ' or '  ' ) .. text .. string.rep(' ', long - #text) .. ( index == sel and ']' or ' ' ) )
    --end
    for i = 1, sY do
      if _table[i + yPos - 1] then
        local tmp = _table[i + yPos - 1]
        _term.setCursorPos( startX, startY + i - 1 )
        _term.write( ( i + yPos - 1 == sel and '[ ' or '  ' ) .. tmp .. string.rep(' ', long - #tmp) .. ( i + yPos - 1 == sel and ']' or ' ' ) )
      else break end
    end
  end

  local longest = getLongest( _table )
  local sel = 1
  local yPos = 1

  while true do
    printMenu(_term, _table, longest, sel, yPos )
    local e, key = os.pullEvent()
    if e == "key" or e == "mouse_scroll" then
      if key == keys.up or key == -1 then
        -- up
        if yPos > 1 then
          yPos = yPos - 1
        end
        if sel > 1 then
          sel = sel - 1
        end
      elseif key == keys.down or key == 1 then
        -- down
        if sel < #_table then
          sel = sel + 1
        end
        if yPos < #_table - 18 and sel >= 20 then
          yPos = yPos + 1
        end
      elseif key == keys.enter then
        return _table[sel], sel
      end
    end
  end
end

function drawMainScreen()
  term.setBackgroundColor(__mineosConfig.BGColor)
  term.setTextColor(__mineosConfig.FGColor)
  term.clear()
  term.setCursorPos(1, 1)
  term.write(__const.product_name.." "..__const.version)
  term.setCursorPos(1, 2)
  term.write(string.rep("-",51))
  for i=3,19 do
    term.setCursorPos(35, i)
    term.write("|")
  end
--  term.setCursorPos(1, 17)
--  term.write(string.rep("-",51))
--  term.setCursorPos(1, 18)
--  term.write("G - group manipulations, O - group orders, X - exit")
end

function updateSoftware()
  windows['main'].clear()
  windows['main'].setCursorPos(1, 1)
  if not(fs.exists("san-get")) then
    print("Retrieving latest installer")
    shell.run("pastebin","get f89mQwxK san-get")
  else
    print("Updating installer")
    shell.run("san-get"," update san-get")
  end
  shell.run("san-get"," update "..__programName)
  if not(fs.exists("kubachos")) then
    print("Removing old startup")
    shell.run("rm","startup")
    sfile= fs.open("startup", "w") or error("Cannot open file startup", 2)
    print("Writing new startup")
    sfile.write("shell.run(\""..__programName.."\")")
  sfile.close()
end
print("Rebooting...")
os.reboot()
end

function getCurrentGroupMinerIDs()
  local groupMinerIDs = split(registry["groups"][registry["currentGroup"]]["list"],',')
  local prepend = true
  if groupMinerIDs[1]=="*" then
    groupMinerIDs = registry["miner_ids"]
    prepend = false
  end
  local list = {}
  for i=1,#groupMinerIDs do
    local elemname = groupMinerIDs[i]
    if prepend then
      elemname = "mininglaser_"..tostring(tonumber(elemname))
    end
    if peripheral.isPresent(elemname) then
      table.insert(list,elemname)
    end
  end
  return list
end

function drawMainStat()
  local w = windows['main']
  w.clear()
  w.setCursorPos(1, 1)
  w.write("Miners total: "..(#registry["miner_ids"]))
  w.setCursorPos(1, 2)
  -- debug.dump(registry["currentGroup"])
  -- debug.dump(registry["groups"])
  w.write("Current group: "..registry["groups"][registry["currentGroup"]]['name'])
  w.setCursorPos(1, 3)
  local stat = getMinerStats(getCurrentGroupMinerIDs())
  w.write("Miners in group: "..(stat["total"]))
  w.setCursorPos(1, 4)
  w.write("M/Q/W/I: "..stat["mining"].."/"..stat["quarry"].."/"..stat["warmup"].."/"..stat["idle"])
  w.setCursorPos(1, 5)
  w.write("Low energy: "..stat["lowenergy"])
  w.setCursorPos(1, 6)
  w.write("Levels: "..stat["lowest"].."/"..stat["highrst"])
  w.setCursorPos(1,7)
  -- debug.dump(stat["raw"])
end

function userInputReader()
  while true do
    wX, wY = windows['menu'].getSize()
    windows['menu'].clear()
    local sOption, sNumb = menu(windows['menu'], __main_menu, (wX-getLongest(__main_menu))/2, 1 )
    windows['main'].setCursorPos(1, 1)
    -- windows['main'].write(sOption)
    if sOption=="Exit" then
      break
    elseif sOption=="Orders" then
      ordersMenu()
    elseif sOption=="Groups" then
      groupsMenu()
    elseif sOption=="Update" then
      registry['main_section'] = 'none';
      updateSoftware()
    end
  end

end

function monitorUpdater()
end

function monitorListener()
end

function mainScreenDrawer()
  while true do
    if registry['main_section'] == "mainstats" then
      drawMainStat()
    else
      local e, key = os.pullEvent()
    end
    sleep(1)
  end
end

function groupsMenu()
  while true do
    wX, wY = windows['menu'].getSize()
    windows['menu'].clear()
    local sOption, sNumb = menu(windows['menu'], __groups_menu, (wX-getLongest(__groups_menu))/2, 1 )
    windows['main'].setCursorPos(1, 1)
    -- windows['main'].write(sOption)
    if sOption=="<< Back" then
      break
    elseif sOption=="Add new" then
      local entry = askGroupData()
      table.insert(registry["groups"], entry)
      saveFile(registry["groups"], "miner_groups.dat")
    elseif   sOption=="Select" then
      local groupsList = getGroupList(true)
      local sOption, sNumb = menu(windows['menu'], groupsList, (wX-getLongest(groupsList))/2, 1 )
      registry["currentGroup"] = sNumb-1
      return
    elseif sOption=="Edit" then
      local groupsList = getGroupList()
      windows['menu'].clear()
      local sOption, sNumb = menu(windows['menu'], groupsList, (wX-getLongest(groupsList))/2, 1 )
      if not(sOption=="<< Back") then
        local entry = askGroupData()
        if type(entry)=="table" then
          registry["groups"][sNumb]=entry
        end
        saveFile(registry["groups"], "miner_groups.dat")
      end
    elseif sOption=="Remove" then
      local groupsList = getGroupList()
      windows['menu'].clear()
      local sOption, sNumb = menu(windows['menu'], groupsList, (wX-getLongest(groupsList))/2, 1 )
      if not(sOption=="<< Back") then
        table.remove(registry["groups"],sNumb)
        if sNumb==registry["currentGroup"] then
          registry["currentGroup"] = 1
        elseif registry["currentGroup"]>sNumb then
          registry["currentGroup"] = registry["currentGroup"] - 1
        end
        local newgroups = {}
        for key,val in pairs(registry["groups"]) do
          table.insert(newgroups,val)
        end
        registry["groups"] = newgroups
        saveFile(registry["groups"], "miner_groups.dat")
        registry["groups"]=loadFile("miner_groups.dat")
      end
    end
    sOption = ''
  end
end

function ordersMenu()
  while true do
    wX, wY = windows['menu'].getSize()
    windows['menu'].clear()
    local sOption, sNumb = menu(windows['menu'], __orders_menu, (wX-getLongest(__orders_menu))/2, 1 )
    windows['main'].setCursorPos(1, 1)
    if sOption=="<< Back" then
      break
    elseif sOption=="Stop" then
      for _,val in pairs(getCurrentGroupMinerIDs()) do
        orderStop(val);
      end
      return
    elseif sOption=="Mine" or sOption=="Mine S" then
      for _,val in pairs(getCurrentGroupMinerIDs()) do
        orderMine(val,not(sOption=="Mine S"));
      end
      return
    elseif sOption=="Quarry" or sOption=="Quarry S" then
      for _,val in pairs(getCurrentGroupMinerIDs()) do
        orderQuarry(val,not(sOption=="Quarry S"));
      end
      return
    elseif sOption=="Offset" then
      registry['main_section'] = "none"
      local cw = windows['main'];
      cw.clear()
      local offset = ""
      cw.setCursorPos(1,1)
      cw.write("Offset : ")
      offset = read()
      offset = tonumber(offset)
      if offset>0 then
        for _,val in pairs(getCurrentGroupMinerIDs()) do
          orderOffset(val,offset);
        end
      end
      cw.clear()
      registry['main_section'] = "mainstats"
    end
    sOption = ''
  end
end

function orderQuarry(miner,nosilktouch)
  -- nosilktouch = nosilktouch or true
  if peripheral.isPresent(miner) then
    local m = peripheral.wrap(miner)
    if nosilktouch then
      m.quarry()
    else
      m.quarry(true)
    end
  end
end

function orderMine(miner,nosilktouch)
  -- nosilktouch = nosilktouch or true
  if peripheral.isPresent(miner) then
    local m = peripheral.wrap(miner)
    if nosilktouch then
      m.mine()
    else
      m.mine(true)
    end
  end
end

function orderStop(miner)
  if peripheral.isPresent(miner) then
    local m = peripheral.wrap(miner)
    m.stop()
  end
end

function orderOffset(miner,offset)
  offset = offset or 1
  if peripheral.isPresent(miner) then
    local m = peripheral.wrap(miner)
    m.offset(offset)
  end
end

function askGroupData(info)
  local info = info or {name="",list=""}
  registry['main_section'] = "none"
  local cw = windows['main'];
  cw.clear()
  local groupName = ""
  while string.len(groupName)<3 do
    cw.setCursorPos(1,1)
    cw.write("New group name (at least 3 chars): ")
    cw.setCursorPos(1,2)
    groupName = read()
    if groupName=="" then
      registry['main_section'] = "mainstats"
      return false
    end
  end
  local ids = ""
  while string.len(ids)<1 do
    cw.setCursorPos(1,3)
    cw.write("Peripheral ids (comma separated):")
    cw.setCursorPos(1,4)
    ids = read()
    if ids=="" then
      registry['main_section'] = "mainstats"
      return false
    end
  end
  local entry = {name = groupName, list=ids}
  registry['main_section'] = "mainstats"
  return entry
end

function getGroupList(withAll)
  withAll = withAll or false
  local list = {"<< Back"}
  for key,val in pairs(registry["groups"]) do
    if withAll or not(val["name"]=="All") then
      table.insert(list,val['name'])
    end
  end
  return list
end

function getMinerStats(ids)
  local stat={}
  stat["total"] = #ids
  stat["idle"] = 0
  stat["mining"] = 0
  stat["quarry"] = 0
  stat["lowenergy"] = 0
  stat["lowest"] = 255
  stat["highrst"] = 0
  stat["warmup"] = 0
  stat["raw"] = {}
  for _,id in pairs(ids) do
    if peripheral.isPresent(id)then
      local state,energy,curlayer,mined,total = modem.callRemote(id,"state")
      if not(stat["raw"][state]==nil) then
        stat["raw"][state] = stat["raw"][state]+1
      else
        stat["raw"][state] = 1
      end
      if string.find(state,"IDLE") then
        stat["idle"] = stat["idle"]+1
      elseif string.find(state,"Mining ores") or string.find(state,"Scanning ores") then
        stat["mining"] = stat["mining"]+1
      elseif string.find(state,"Mining all") or string.find(state,"Scanning all") then
        stat["quarry"] = stat["quarry"]+1
      elseif string.find(state,"Warming up") then
        stat["warmup"] = stat["warmup"]+1
      end
      if string.find(state,"Out of energy") then
        stat["lowenergy"]=stat["lowenergy"]+1
      end
      if curlayer<stat["lowest"] then
        stat["lowest"]=curlayer
      end
      if curlayer>stat["highrst"] then
        stat["highrst"]=curlayer
      end
    end
  end
  return stat
end
-- /FUNCTIONS

__main_menu = {"Orders","Groups","Update","Exit"}
__groups_menu = {"<< Back","Select","Add new","Edit","Remove"}
__orders_menu = {"<< Back","Stop","Mine","Mine S","Quarry","Quarry S","Offset"}

registry = {}
windows = {}
initialize()
-- debug.dump(loadFile("miner_groups.dat"))
-- error()
-- debug.dump(split(registry["groups"][registry["currentGroup"]]["list"],','))
-- debug.dump(getCurrentGroupMinerIDs())
-- error()
drawMainScreen()

windows['menu']=window.create(term.current(),36,3,15,10,true)
windows['menu'].setBackgroundColor(__mineosConfig.BGColor)
windows['menu'].setTextColor(__mineosConfig.FGColor)
windows['menu'].clear()
windows['main']=window.create(term.current(),1,3,34,17,true)
windows['main'].setBackgroundColor(__mineosConfig.BGColor)
windows['main'].setTextColor(__mineosConfig.FGColor)
windows['main'].clear()

parallel.waitForAny(userInputReader, mainScreenDrawer)

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1,1)