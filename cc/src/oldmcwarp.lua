version = "1.12.0 Multicore"

__programName = shell.getRunningProgram()

_warp_config_file = "/etc/warpdrive/config";

Style = {
  CDeflt = colors.white,
  BGDeflt = colors.gray,
  CTitle = colors.black,
  BGTitle = colors.lightGray,
  CWarn = colors.white,
  BGWarn = colors.red
}

WARP_UP = 1
WARP_DOWN = 2
WARP_FORWARD = 0
WARP_BACK = 180
WARP_LEFT = 90
WARP_RIGHT = 255

warp_names = {}
warp_names[WARP_UP] = 'Up'
warp_names[WARP_DOWN] = 'Down'
warp_names[WARP_FORWARD] = 'Forward'
warp_names[WARP_BACK] = 'Back'
warp_names[WARP_LEFT] = 'Left'
warp_names[WARP_RIGHT] = 'Right'

DIRECTION_SOUTH = 0
DIRECTION_EAST = 90
DIRECTION_NORTH = 180
DIRECTION_WEST = 255
DIRECTION_UP = 1
DIRECTION_DOWN = 2

direction_names = {}
direction_names[DIRECTION_SOUTH] = 'South'
direction_names[DIRECTION_EAST] = 'East'
direction_names[DIRECTION_NORTH] = 'North'
direction_names[DIRECTION_WEST] = 'West'
direction_names[DIRECTION_UP] = 'Up'
direction_names[DIRECTION_DOWN] = 'Down'

function getDirectionName(dir)
  return direction_names[dir]
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

TYPE_WARP = "warpcore"

MAX_CORE_ENERGY = 120000000

logger = fs.exists("disk")
if logger then
  file = fs.open("/disk/oldmcwarp.log","w")
  file.close()
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function hlog(data)
  file = fs.open("/var/log/oldmcwarp.log",fs.exists("/var/log/oldmcwarp.log") and "a" or "w")
  file.writeLine(data)
  file.close()
end


if true then -- for folding purpose
  Key = {};
  Key["backspace"] = 14
  Key["tab"] = 15
  Key["enter"] = 28
  Key["lshift"] = 42
  Key["lctrl"] = 29
  Key["lalt"] = 56
  Key["rshift"] = 54
  Key["rctrl"] = 157
  Key["ralt"] = 184
  Key["pause"] = 197
  Key["caps lock"] = 58
  Key["esc"] = 1
  Key["spacebar"] = 57
  Key["page up"] = 201
  Key["page down"] = 209
  Key["end"] = 207
  Key["home"] = 199
  Key["left_arrow"] = 203
  Key["up_arrow"] = 200
  Key["right_arrow"] = 205
  Key["down_arrow"] = 208
  Key["insert"] = 210
  Key["delete"] = 211
  Key["0"] = 11
  Key["1"] = 2
  Key["2"] = 3
  Key["3"] = 4
  Key["4"] = 5
  Key["5"] = 6
  Key["6"] = 7
  Key["7"] = 8
  Key["8"] = 9
  Key["9"] = 10
  Key["a"] = 30
  Key["b"] = 48
  Key["c"] = 46
  Key["d"] = 32
  Key["e"] = 18
  Key["f"] = 33
  Key["g"] = 34
  Key["h"] = 35
  Key["i"] = 23
  Key["j"] = 36
  Key["k"] = 37
  Key["l"] = 38
  Key["m"] = 50
  Key["n"] = 49
  Key["o"] = 24
  Key["p"] = 25
  Key["q"] = 16
  Key["r"] = 19
  Key["s"] = 31
  Key["t"] = 20
  Key["u"] = 22
  Key["v"] = 47
  Key["w"] = 17
  Key["x"] = 45
  Key["y"] = 21
  Key["z"] = 44
  Key["lsuper"] = 219 -- Left Windows Key
  Key["rsuper"] = 220 -- Right Windows Key
  Key["menu"] = 221 -- Application key - located between the right Windows and Ctrl keys on most keyboards
  -- Numpad numbers start
  Key["num0"] = 82
  Key["num1"] = 79
  Key["num2"] = 80
  Key["num3"] = 81
  Key["num4"] = 75
  Key["num5"] = 76
  Key["num6"] = 77
  Key["num7"] = 71
  Key["num8"] = 72
  Key["num9"] = 73
  Key["num*"] = 55
  Key["num+"] = 78
  Key["num-"] = 74
  Key["num."] = 83
  Key["num/"] = 181
  Key["numenter"] = 28
  -- Numpad numbers end
  Key["f1"] = 59
  Key["f2"] = 60
  Key["f3"] = 61
  Key["f4"] = 62
  Key["f5"] = 63
  Key["f6"] = 64
  Key["f7"] = 65
  Key["f8"] = 66
  Key["f9"] = 67
  Key["f10"] = 68
  Key["f11"] = 87
  Key["f12"] = 88
  Key["numlock"] = 69
  Key["scrolllock"] = 70
  Key[";"] = 39
  Key["="] = 13
  Key[","] = 51
  Key["-"] = 12
  Key["."] = 52
  Key["/"] = 53
  Key["'"] = 40
  Key["["] = 26
  Key["\\"] = 43
  Key["]" ] = 27
  Key["`"] = 41
end

function drawSplash()
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white)
  term.clear()
  term.setCursorPos(1,4)
  print("    __  ___      ____  _                    ")
  print("   /  |/  /_  __/ / /_(_)________  ________ ")
  print("  / /|_/ / / / / / __/ / ___/ __ \\/ ___/ _ \\")
  print(" / /  / / /_/ / / /_/ / /__/ /_/ / /  /  __/")
  print("/_/  /_/\\__,_/_//__/_/\\___/\\____/_/   \\___/ ")
  print("      | |     / /___ __________  ___  _____ ")
  print("      | | /| / / __ \\'/ ___/ __ \\/ _ \\/ ___/ ")
  print("      | |/ |/ / /_/ / /  / /_/ /  __/ /     ")
  print("      |__/|__/\\__,_/_/  / .___/\\___/_/      ")
  print("                       /_/                  ")

  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white)
  line = "                     LOADING                       "
  term.setCursorPos(1,19)
  term.write(line)
  term.setBackgroundColor(colors.white)
  term.setTextColor(colors.gray)
  for i=1,51 do
    term.setCursorPos(i,19)
    term.write(string.sub(line,i,i))
    if round(math.random()*100)%7 == 0 then
      sleep(0.1)
    end
  end
  term.setBackgroundColor(colors.gray)
end

function SetColorDeflt()
  term.setBackgroundColor(Style.BGDeflt)
  term.setTextColor(Style.CDeflt)
end

function SetColorTitle()
  term.setBackgroundColor(Style.BGTitle)
  term.setTextColor(Style.CTitle)
end

function SetColorWarn()
  term.setBackgroundColor(Style.BGWarn)
  term.setTextColor(Style.CWarn)
end

function Clear()
  term.clear()
  term.setCursorPos(1,1)
end

function Show(Text)
  term.write(Text)
  local xt,yt = term.getCursorPos()
  term.setCursorPos(1, yt+1)
end

function ShowTitle(Text)
  SetColorTitle()
  local w, h = term.getSize()
  local posX = math.floor((w-string.len(Text))/2)
  if posX<0 then
    posX=0
  end
  term.setCursorPos(posX,1)
  Show(Text)
  SetColorDeflt()
end

function ShowMenu(Text)
  term.write(Text)
  local xt, yt = term.getCursorPos()
  for i = xt, 51 do
    term.write(" ")
  end
  term.setCursorPos(1, yt+1)
end

function ShowWarning(Text)
  SetColorWarn()
  term.setCursorPos(10, 19)
  term.write(" "..Text.." ")
  SetColorDeflt()
end

warps = {} -- all warp cores

function findWarps() -- find all warp cores
  peripherals = peripheral.getNames()
  for i = 1,#peripherals do
    if peripheral.getType(peripherals[i]) == TYPE_WARP and table.contains(peripheral.getMethods(peripherals[i]),'set_mode') then
      table.insert(warps,{ID = peripherals[i],core = peripheral.wrap(peripherals[i])})
      if (SData["CurrentCore"]~="" and SData["CurrentCore"]==peripherals[i]) then
        warp = warps[#warps]["core"]
        curCoreIndex = #warps
      end
      warps[#warps]["core"].set_mode(0)
    end
  end
end

function getCurCore()
  return warps[curCoreIndex]["core"]
end

GFront, GRight, GUp, GBack, GLeft, GDown, IsInHyper, X, Y, Z, Weight = nil
function getCoreInfo(core)
  core = core or getCurCore()
  GFront, GRight, GUp = core.dim_getp()
  GBack, GLeft, GDown = core.dim_getn()
  IsInHyper = core.is_in_hyperspace()
  repeat
    X = core.get_x()
    sleep(0.3)
  until X ~= nil
  Y = core.get_y()
  Z = core.get_z()
  Weight = core.get_ship_size()
  if Weight==nil then
    Weight = 1
  end

end

function checkDirs()
  if not(fs.exists("/etc")) then
    fs.makeDir("/etc")
  else
    if not(fs.isDir("/etc")) then
      fs.delete("/etc")
      fs.makeDir("/etc")
    end
  end
  if not(fs.exists("/etc/warpdrive")) then
    fs.makeDir("/etc/warpdrive")
  else
    if not(fs.isDir("/etc/warpdrive")) then
      fs.delete("/etc/warpdrive")
      fs.makeDir("/etc/warpdrive")
    end
  end
end

function SaveData(data)
  if tablelength(data)>0 then
    local file = fs.open(_warp_config_file, "w")
    local str = textutils.serialize(data)
    if str~="{}" then
      file.writeLine(str)
    end
    file.close()
  end
end

function ReadData()
  local file = fs.open(_warp_config_file, "r")
  local data = textutils.unserialize(file.readAll())
  file.close()
  return data
end

function Explode(d, p)
  local t, ll
  t = {}
  ll = 0
  if(#p == 1) then return {p} end
  while true do
    local l = string.find(p ,d, ll, true)
    if l ~= nil then
      table.insert(t, string.sub(p, ll, l-1))
      ll = l+1
    else
      table.insert(t, string.sub(p, ll))
      break
    end
  end
  return t
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function getCoreOrientation(core)
  core = core or getCurCore()
  local dx = core.get_dx()
  local dz = core.get_dz()
  if not(dx==0) then
    if dx > 0 then
      return DIRECTION_EAST
    elseif dx < 0 then
      return DIRECTION_WEST
    end
  else
    if dz > 0 then
      return DIRECTION_SOUTH
    elseif dz < 0 then
      return DIRECTION_NORTH
    end
  end
  return -1
end

MinimumDistance,RealDistance = nil

function CalcRealDistance()
  if IsInHyper then
    RealDistance = SData.Distance * 100
    MinimumDistance = 1
  else
    if SData.Direction == DIRECTION_UP or SData.Direction == DIRECTION_DOWN then
      MinimumDistance = GUp + GDown
      RealDistance = SData.Distance + MinimumDistance
    elseif SData.Direction == DIRECTION_SOUTH or SData.Direction == DIRECTION_NORTH then
      MinimumDistance = GFront + GBack
      RealDistance = SData.Distance + MinimumDistance
    elseif SData.Direction == DIRECTION_EAST or SData.Direction == DIRECTION_WEST then
      MinimumDistance = GLeft + GRight
      RealDistance = SData.Distance + MinimumDistance
    end
    MinimumDistance = MinimumDistance + 1
  end
end

function CalcNewCoords(cx, cy, cz)
  local res = {x=cx, y=cy, z=cz}
  if SData.Direction == DIRECTION_UP then
    res.y = res.y + RealDistance
  elseif SData.Direction == DIRECTION_DOWN then
    res.y = res.y - RealDistance
  end
  local dx = warp.get_dx()
  local dz = warp.get_dz()
  if dx ~= 0 then
    if SData.Direction == WARP_FORWARD then
      res.x = res.x + (RealDistance * dx)
    elseif SData.Direction == WARP_BACK then
      res.x = res.x - (RealDistance * dx)
    elseif SData.Direction == WARP_LEFT then
      res.z = res.z + (RealDistance * dx)
    elseif SData.Direction == WARP_RIGHT then
      res.z = res.z - (RealDistance * dx)
    end
  else
    if SData.Direction == WARP_FORWARD then
      res.z = res.z + (RealDistance * dz)
    elseif SData.Direction == WARP_BACK then
      res.z = res.z - (RealDistance * dz)
    elseif SData.Direction == WARP_LEFT then
      res.x = res.x + (RealDistance * dz)
    elseif SData.Direction == WARP_RIGHT then
      res.x = res.x - (RealDistance * dz)
    end
  end
  return res
end

function ShowInfo()
  ShowTitle(Title)
  local core = getCurCore();
  local core_id = Explode("_",warps[curCoreIndex]["ID"])
  if core_id[2] then
    core_id = core_id[2]
  else
    core_id = warps[curCoreIndex]["ID"]
  end
  Show("Core: "..SData.Shipname.."_"..core_id)
  Show(" x, y, z          = "..X..", "..Y..", "..Z)
  local energy = core.get_energy_level()
  Show(" Energy           = "..math.floor((energy / MAX_CORE_ENERGY)*100).." % ("..energy.."EU)")
  Show(" Attached players = "..core.get_attached_players())
  local heading = getDirectionName(getCoreOrientation(core))
  while type(heading) ~= "string" do
    heading = getDirectionName(getCoreOrientation(core))
    sleep(0.1)
  end
  Show(" Heading          = "..heading)
  Show("Dimensions:")
  Show(" Front, Right, Up = "..GFront..", "..GRight..", "..GUp)
  Show(" Back, Left, Down = "..GBack..", "..GLeft..", "..GDown)
  Show(" Size             = "..Weight.." blocks")
  Show("Warp data:")
  Show(" Direction        = "..warp_names[SData.Direction].." ")
  local dest = CalcNewCoords(X, Y, Z)
  if table.contains(core, 'get_energy_required') then
    local JumpCost = core.get_energy_required(RealDistance)
  local JumpInfo = " ("..JumpCost.."EU, "..math.floor(energy/JumpCost).." jumps)"
  else
    local JumpInfo = ' ';
  end
  Show(" Distance         = "..tostring(RealDistance)) -- ..tostring(JumpInfo)
  Show(" Dest.coordinates = "..dest.x..", "..dest.y..", "..dest.z)
  local summons = " Summon after (M) = No" 
  if SData.Summon then
    summons = " Summon after (M) = Yes"
  end
  Show(summons)
end

function Confirm(message)
  message = message or "Are you sure?"
  ShowWarning(message.." (y/n)")
  local event, keycode = os.pullEvent("key")
  if keycode == 21 then
    return true
  else
    return false
  end
end

function SetDistance()
  Clear()
  ShowTitle("<====  Set distance  ====>")
  SData.Distance = 0
  CalcRealDistance()
  MaximumDistance = MinimumDistance + (128 * (IsInHyper and 100 or 1))
  if IsInHyper then
    term.write("Distance * 100 (min "..MinimumDistance..", max "..MaximumDistance.."): ")
  else
    term.write("Distance (min "..MinimumDistance..", max "..MaximumDistance.."): ")
  end
  sleep(0.3)
  SData.Distance = tonumber(read())
  if SData.Distance == nil then SData.Distance = 1 end
  if SData.Distance < MinimumDistance or SData.Distance > MaximumDistance then
    SData.Distance = 1
    ShowWarning("Wrong distance. Try again.")
    os.pullEvent("key")
    CalcRealDistance()
  else
    if not IsInHyper then
      SData.Distance = SData.Distance - RealDistance
    end
    CalcRealDistance()
  end
end

function SetDirection()
  local drun = true
  while(drun) do
    Clear()
    ShowTitle("<==== Set direction ====>")
    Show(" Direction        = "..warp_names[SData.Direction].." ")
    term.setCursorPos(1, 16)
    SetColorTitle()
    ShowMenu("Use directional keys")
    ShowMenu("W/S keys for Up/Down")
    ShowMenu("Enter - confirm")
    SetColorDeflt()
    local event, keycode = os.pullEvent("key")
    if keycode == Key["up_arrow"] then
      SData.Direction = WARP_FORWARD
    elseif keycode == Key["w"] then
      SData.Direction = WARP_UP
    elseif keycode == Key["left_arrow"] then
      SData.Direction = WARP_LEFT
    elseif keycode == Key["right_arrow"] then
      SData.Direction = WARP_RIGHT
    elseif keycode == Key["down_arrow"] then
      SData.Direction = WARP_BACK
    elseif keycode == Key["s"] then
      SData.Direction = WARP_DOWN
    elseif keycode == Key["enter"] then
      drun = false
    end
  end
end

function SetDimensions()
  local _GFront, _GRight, _GUp, _GBack, _GLeft, _GDown
  Clear()
  sleep(0.3)
  ShowTitle("<== Set dimensions for "..SData["CurrentCore"].." ==>")

  term.write(" Front ("..GFront..") : ")
  _GFront = tonumber(read()) or GFront

  term.write(" Right ("..GRight..") : ")
  _GRight = tonumber(read()) or GRight

  term.write(" Up    ("..GUp..") : ")
  _GUp = tonumber(read()) or GUp

  term.write(" Back  ("..GBack..") : ")
  _GBack = tonumber(read()) or GBack

  term.write(" Left  ("..GLeft..") : ")
  _GLeft = tonumber(read()) or GLeft

  term.write(" Down  ("..GDown..") : ")
  _GDown = tonumber(read()) or GDown

  term.write("Setting dimensions...")
  getCurCore().dim_setp(_GFront, _GRight, _GUp)
  getCurCore().dim_setn(_GBack, _GLeft, _GDown)
  
  GFront = _GFront
  GRight = _GRight
  GUp = _GUp
  GBack = _GBack
  GLeft = _GLeft
  GDown = _GDown

  if #warps<2 or not(Confirm("Calculate other cores?")) then
    return
  end

  local curCoords = {x=getCurCore().get_x(),y=getCurCore().get_y(),z=getCurCore().get_z()}
  hlog("CurCoords: x="..curCoords['x'].." y="..curCoords['y'].." z="..curCoords['z'] )
  hlog("CurDimensions: F="..GFront.." R="..GRight.."  U="..GUp )
  hlog("CurDimensions: B="..GBack.."  L="..GLeft.." D="..GDown )
  local curCoreOrient = getCoreOrientation(getCurCore())

  for i,wcore in pairs(warps) do
    local core = wcore['core']
    if not(wcore["ID"]==warps[curCoreIndex]["ID"]) then
      local dx,dy,dz
      local _GFront, _GRight, _GUp, _GBack, _GLeft, _GDown
      local coreOrient = getCoreOrientation(core)
      hlog('Found not current core '..wcore["ID"])
      local coreCoords = {x=core.get_x(),y=core.get_y(),z=core.get_z()}
      hlog(wcore["ID"].." Coords: x="..coreCoords['x'].." y="..coreCoords['y'].." z="..coreCoords['z'] )
      dx = coreCoords['x']-curCoords['x']
      dy = coreCoords['y']-curCoords['y']
      dz = coreCoords['z']-curCoords['z']
      hlog("Diff: x="..dx.." y="..dy.." z="..dz)
      _GUp = GUp - dy
      _GDown = GDown + dy

      local nextIteration = false
      if coreOrient == curCoreOrient then
        if coreOrient == DIRECTION_NORTH then
          _GFront = GFront + dz
          _GRight = GRight - dx
          _GLeft = GLeft + dx
          _GBack = GBack - dz
        elseif coreOrient == DIRECTION_SOUTH then
          _GFront = GFront - dz
          _GRight = GRight + dx
          _GLeft = GLeft - dx
          _GBack = GBack + dz
        elseif coreOrient == DIRECTION_EAST then
          _GFront = GFront - dx
          _GRight = GRight - dz
          _GLeft = GLeft + dz
          _GBack = GBack + dx
        elseif coreOrient == DIRECTION_WEST then
          _GFront = GFront + dx
          _GRight = GRight + dz
          _GLeft = GLeft - dz
          _GBack = GBack - dx
        end
      else
        print("Can't calculate differntly oriented core.")
        if not(Confirm("Skip this one and continue?")) then
          return
        end
        nextIteration = true
      end
      if not(nextIteration) then
        hlog("NewDimensions: F=".._GFront.." R=".._GRight.."  U=".._GUp )
        hlog("NewDimensions: B=".._GBack.."  L=".._GLeft.." D=".._GDown )
        core.dim_setp(_GFront, _GRight, _GUp)
        core.dim_setn(_GBack, _GLeft, _GDown)
      end
    end
  end


end

function chooseWarpCore()
  Clear()
  sleep(0.3)
  ShowTitle("<==== Select warpcore ====>")
  getCoreInfo()
  Show("Current core: " .. warps[curCoreIndex]["ID"])
  Show(" x, y, z          = "..X..", "..Y..", "..Z)
  local energy = warp.get_energy_level()
  Show(" Energy           = "..math.floor(energy / 1000000).." % ("..energy.."EU)")
  Show(" Attached players = "..warp.get_attached_players())
  Show("Dimensions:")
  Show(" Front, Right, Up = "..GFront..", "..GRight..", "..GUp)
  Show(" Back, Left, Down = "..GBack..", "..GLeft..", "..GDown)
  Show(" Size             = "..Weight.." blocks")

  ShowMenu("Press <Left> or <Right> to switch core")
  ShowMenu("Press <Enter> to select core")
  local event, keycode = os.pullEvent("key")
  if keycode == Key["right_arrow"] or keycode == Key["numenter"] then
    return
  elseif keycode == Key["left_arrow"] or keycode == Key["num4"] then -- Left
    if curCoreIndex==1 then
      curCoreIndex = #warps
  else
    curCoreIndex = curCoreIndex-1
  end
  elseif keycode == Key["right_arrow"] or keycode == Key["num6"] then -- Right
    if curCoreIndex==#warps then
      curCoreIndex = 1
  else
    curCoreIndex = curCoreIndex+1
  end
  end
  warp = warps[curCoreIndex]["core"]
  SData["CurrentCore"] = warps[curCoreIndex]["ID"]
  chooseWarpCore()
end


function Warp()
  powerOffAllCores()
  sleep(1)
  getCurCore().set_direction(SData.Direction)
  getCurCore().set_distance(SData.Distance)
  if IsInHyper then
    getCurCore().set_mode(2)
  else
    getCurCore().set_mode(1)
  end
  getCurCore().do_jump()
end

function HyperJump()
  if Confirm() then
    powerOffAllCores()
    getCurCore().set_mode(5)
    getCurCore().do_jump()
  end
end

function Summon()
  Clear()
  ShowTitle("<==== Summon players ====>")
  local players = Explode(",", warp.get_attached_players())
  for i = 1, #players do
    Show(i..". "..players[i])
  end
  SetColorTitle()
  ShowMenu("Enter player number")
  ShowMenu("or press enter to summon everyone")
  SetColorDeflt()
  sleep(0.3)
  term.write(":")
  local input = read()
  if input == "" then
    warp.summon_all()
  else
    input = tonumber(input)
    warp.summon(input - 1)
  end
end

function JumpToBeacon()
  Clear()
  ShowTitle("<==== Jump to beacon ====>")
  sleep(0.3)
  term.write("Enter beacon frequency: ")
  local freq = tostring(read())
  if Confirm() then
    powerOffAllCores()
    getCurCore().set_mode(4)
    getCurCore().set_beacon_frequency(freq)
    getCurCore().do_jump()
  end
end

function JumpToGate()
  Clear()
  ShowTitle("<==== Jump to JumpGate ====>")
  sleep(0.3)
  term.write("Enter jumpgate name: ")
  local name = tostring(read())
  if Confirm() then
    powerOffAllCores()
    getCurCore().set_mode(6)
    getCurCore().set_target_jumpgate(name)
    getCurCore().do_jump()
  end
end

function SetShipName()
  Clear()
  ShowTitle("<==== Set ship name ====>")
  sleep(0.3)
  term.write("Enter ship name: ")
  SData.Shipname = tostring(read())
  os.setComputerLabel(SData.Shipname)
  for i,wcore in pairs(warps) do
    local core_id = Explode("_",wcore["ID"])
    core_id = core_id[2]
    if not(core_id) then
      wcore['core'].set_core_frequency(SData.Shipname..'_'..wcore["ID"])
    else
      wcore['core'].set_core_frequency(SData.Shipname..'_'..core_id)
    end
  end
  SaveData(SData)
  os.reboot()
end

function powerOnCore(core)
  core = core or getCurCore()
  core.set_mode(1)
end

function powerOffAllCores()
  for i = 1,#warps do
    warps[i]["core"].set_mode(0)
  end
end

function powerOnAllCores()
  for i = 1,#warps do
    warps[i]["core"].set_mode(1)
  end
end

function checkStartup()
  if not(fs.exists("startup")) then
    shell.run("rm","startup")
    local sfile= fs.open("startup", "w") or error("Cannot open file startup", 2)
    sfile.write("shell.run(\""..__programName.."\")")
    sfile.close()
  end
end

function updateSoftware()
  Clear()
  if not(fs.exists("san")) then
    shell.run("pastebin","get f89mQwxK san-get")
  end
  shell.run("san-get"," update san-get")
  shell.run("san-get"," update "..__programName)
  if not(fs.exists("kubachos")) then
    shell.run("rm","startup")
    local sfile= fs.open("startup", "w") or error("Cannot open file startup", 2)
    sfile.write("shell.run(\""..__programName.."\")")
    sfile.close()
  end
  os.reboot()
end

-- TODO: make this work
function Navigation()
  Clear()
  ShowTitle("<==== Navigator ====>")
  Show("Current x, y, z          = "..X..", "..Y..", "..Z)
  term.write("Enter target X: ")
end

function main()
  while(mainloop) do
    Clear()
    ShowInfo()
    term.setCursorPos(1, 16)
    SetColorTitle()
    local hyper_text = ''
    if getCurCore().is_in_hyperspace() then
      hyper_text = "from (H)yperspace, "
    elseif getCurCore().is_in_space() then
      hyper_text = "to (H)yperspace, "
    end
    ShowMenu("(D)imensions, Ship (N)ame, (S)et warp data")
    ShowMenu("(J)ump, (G)ate jump, (B)eacon jump, (C)rew")
    ShowMenu(hyper_text.."E(X)it, (R)eboot, (U)pdate")
    if #warps>1 then
      ShowMenu("            <- Choose warpcore ->")
    end
    SetColorDeflt()
    while not(doLoop) do
      os.queueEvent("randomEvent")
      os.pullEvent()
      sleep(.5)
      getCoreInfo()
    end
    sleep(.1)
  end
end

function eventListener()
  while mainloop do
    local event, keycode = os.pullEvent("key")
    doLoop = false
    sleep(.2)
    if keycode == Key["s"] then -- Set jump direction
      SetDirection()
      SetDistance()
      SaveData(SData)
    elseif keycode == Key["m"] then -- Summon crew
      if SData.Summon then
        SData.Summon = false
      else
        SData.Summon = true
      end
      SaveData(SData)
    elseif keycode == Key["d"] then -- Set dimensions
      SetDimensions()
      SaveData(SData)
    elseif keycode == Key["j"] then -- do jump
      if Confirm() then
        Warp()
      end
    elseif keycode == Key["c"] then -- 
      Summon()
    elseif keycode == Key["b"] then
      JumpToBeacon()
    elseif #warps>1 and (keycode == Key["left_arrow"] or keycode == Key["right_arrow"]) then
      powerOffAllCores()
      if keycode == Key["left_arrow"] then
        if curCoreIndex==1 then
          curCoreIndex = #warps
        else
          curCoreIndex = curCoreIndex-1
        end
      elseif keycode == Key["right_arrow"] then -- Right
        if curCoreIndex==#warps then
          curCoreIndex = 1
        else
          curCoreIndex = curCoreIndex+1
        end
      end
      SData["CurrentCore"] = warps[curCoreIndex]["ID"]
      warp = getCurCore()
      powerOnCore(getCurCore())
      SaveData(SData)
      getCoreInfo()
    elseif keycode == Key["w"] then
      chooseWarpCore()
    elseif keycode == Key["z"] then
      powerOnAllCores()
      ShowWarning("All cores powered on")
      sleep(2)
    elseif keycode == Key["a"] then
      powerOffAllCores()
      ShowWarning("All cores powered off")
      sleep(2)
    elseif keycode == Key["u"] then
      updateSoftware()
    elseif keycode == Key["r"] then
      os.reboot()
    elseif keycode == Key["g"] then
      JumpToGate()
    elseif keycode == Key["h"] and (getCurCore().is_in_hyperspace() or getCurCore().is_in_space()) then
      HyperJump()
    elseif keycode == Key["x"] then
      mainloop = false
      gracefulExit()
    elseif keycode == Key["n"] then
      SetShipName()
    end
    doLoop = true
  end
end

function gracefulExit()
  if SData.Summon then
    SData.Summon = false
    SaveData(SData)
  end
  Clear()
  print("Powering off all cores...")
  for i = 1,#warps do
    warps[i]["core"].set_mode(0)
  end
  print("Done")
  sleep(0.5)
  print("wish you good")
  error()
end

-- Main code starts here
SData = {
  Summon = false,
  Distance = 1,
  Direction = 0,
  Shipname = "",
  CurrentCore = ""
}

if fs.exists(_warp_config_file) then
  for k,v in pairs(ReadData()) do
    SData[k] = v
  end
end

SetColorDeflt()
checkStartup()
warps = {}

findWarps()

if #warps <1 then
  ShowWarning("No warpcore controllers detected")
  --os.pullEvent("key")
  --error()
  sleep(1)
  error()
end

if warp == nil then
  SData["CurrentCore"] = warps[1]["ID"]
  warp=warps[1]["core"]
  curCoreIndex=1
end

drawSplash()

local heading = getDirectionName(getCoreOrientation(core))
while type(heading) ~= "string" do
  heading = getDirectionName(getCoreOrientation(core))
  sleep(0.1)
end

  
if SData["Shipname"] == nil or SData.Shipname == "" then
  SetShipName()
end

Title = "<Jump-S "..version.." \""..SData.Shipname.."\">"

if SData.Summon then
  warp.summon_all()
end

getCoreInfo()
CalcRealDistance()

-- warp.set_mode(1)
powerOnAllCores()

mainloop = true
doLoop = true

parallel.waitForAny(eventListener, main)