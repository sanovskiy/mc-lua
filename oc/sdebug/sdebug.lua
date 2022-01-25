-- DEBUG api
local sdebug = {}

local component = require('component')
local colors = require('colors')
local gpu = component.gpu
local term = require("term") 
local event = require('event')
local indentChar = " "

function sdebug.showPaged(t)
  local startFg, startFgPaletted = gpu.getForeground()
  local startBg, startBgPaletted = gpu.getBackground()
  termX,termY = gpu.getResolution()
  gpu.setForeground(0xffffff,false)
  gpu.setBackground(0x000000,false)
  for i=1,#t do
    io.write(t[i].."\n")
    if i%(termY-1)==0 and not(i==0) then
      local oldFg,fgpaletted = gpu.getForeground()
      local oldBg,bgpaletted = gpu.getBackground()
      gpu.setForeground(0xFFFFFF,false)
      gpu.setBackground(0xFF0000,false)
      io.write("Press any key for next page, \'c\' to interrupt")
      gpu.setForeground(oldFg,fgpaletted)
      gpu.setBackground(oldBg,bgpaletted)
      local name, device, keycode
      name, device, keycode = event.pull("key_down")
      if keycode == 99 then
        io.write("\n")
        gpu.setForeground(startFg, startFgPaletted)
        gpu.setBackground(startBg, startBgPaletted)
        return
      end
      curX,curY = term.getCursor()
      term.setCursor(1, curY)
      term.write(string.rep(" ",termX-1))
      term.setCursor(1, curY)
    end
  end
  gpu.setForeground(startFg, startFgPaletted)
  gpu.setBackground(startBg, startBgPaletted)
end

function sdebug.performDump(data,indent)
  local indent = indent or 1
  local datatype = type(data)
  if datatype == "table" then
    type_string = "table[" .. (#data) .. "] ".. "\n"
  elseif datatype == "string" then
  return "(string[" .. tostring(string.len ( data )) .. "]) "..(string.sub(data,1,16)) .. "\n"
  elseif datatype == "number" then
    return "(number) " .. tostring(data) .. "\n"
  elseif datatype == "boolean" then
  return "(boolean) " .. (data and "true" or "false") .. "\n"
  else
  return datatype .. "\n"
  end
  local Buf = type_string;
  indent = indent+1
  for k, v in pairs(data) do
    Buf = Buf .. string.rep(indentChar,indent) .. k .. " => " .. sdebug.performDump ( v, indent )
  end
  return Buf .. "\n"
end

function sdebug.split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
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

function sdebug.dump(data)
  local localdmp = sdebug.performDump(data)
  splitted = sdebug.split(localdmp, "\n")
  sdebug.showPaged(splitted)
end

return sdebug