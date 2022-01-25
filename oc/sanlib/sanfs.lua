local fs = require("filesystem")
local serialization = require('serialization')
local sanfs = {}

local doPrettySerialization = true

function sanfs:loadLuaData(path)
  local file, reason = io.open(path, 'r')
  if not file then
    io.stderr:write('Failed opening file '.. path ..' for reading: ' .. reason)
    os.exit()
  end

  local raw = file:read('*a')
  file:close()
  return serialization.unserialize(raw)
end

function sanfs:saveLuaData(path,data)
  local file, reason, success, raw
  local tmppath = path..'.write'
  
  file, reason = io.open(tmppath, 'w')
  if not file then
    io.stderr:write('Failed opening file '.. tmppath ..' for writing: ' .. reason)
    os.exit()
  end

  raw = serialization.serialize(data,doPrettySerialization)
  success, reason = file:write(raw)
  file:close()
  if not success then
    io.stderr:write('Failed writing data to '.. tmppath ..': ' .. reason)
    os.exit()
  end
  
--  file, reason = io.open(tmppath, 'r')
--  if not file then
--    io.stderr:write('Failed opening file '.. tmppath ..' for reading: ' .. reason)
--    os.exit()
--  end
--  local raw1 = file:read('*a')
--  file:close()
  
  if fs.exists(path) then
    fs.remove(path)
  end
  fs.rename(tmppath,path)
  return success
end


return sanfs