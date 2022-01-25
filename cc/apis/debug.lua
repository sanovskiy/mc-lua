-- DEBUG api
local indentChar = " "

function showPaged(t)
  termX,termY = term.getSize()
  term.setTextColor(colors.white)
  term.setBackgroundColor(colors.black)
  for i=1,#t do
    print(t[i])
    if i%(termY-1)==0 and not(i==0) then
      term.setTextColor(colors.white)
	  term.setBackgroundColor(colors.red)
	  term.write("Press any key for next page, \'c\' to interrupt")
	  term.setTextColor(colors.white)
	  term.setBackgroundColor(colors.black)
	  local event, keycode = os.pullEvent("key")
	  if keycode == 46 then
	    print("")
	    return
	  end
	  curX,curY = term.getCursorPos()
	  term.setCursorPos(1, curY)
	  term.write(string.rep(" ",termX-1))
	  term.setCursorPos(1, curY)
    end
  end
end

function dump(data)
  localdmp = performDump(data)
  splitted = split(localdmp, "\n")
  showPaged(splitted)
end

function performDump(data,indent)
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
    Buf = Buf .. string.rep(indentChar,indent) .. k .. " => " .. performDump ( v, indent )
  end
  return Buf .. "\n"
end

function split(pString, pPattern)
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

params = {...}
if params[1]~=nil then
  print("Debugging "..params[1])
  tmp = peripheral.wrap(params[1])
  dump(tmp)
end