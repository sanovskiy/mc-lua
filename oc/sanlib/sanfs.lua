local fs = require("filesystem")
local serialization = require('serialization')
local sanfs = {}

local doPrettySerialization = false

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
  if fs.exists(path) then
    fs.remove(path)
  end
  
  file, reason = io.open(path, 'w')
  if not file then
    io.stderr:write('Failed opening file '.. path ..' for writing: ' .. reason)
    os.exit()
  end

  raw = serialization.serialize(data,doPrettySerialization)
  success, reason = file:write(raw)
  file:close()
  if not file then
    io.stderr:write('Failed writing data to '.. path ..': ' .. reason)
    os.exit()
  end
  return success
end


return sanfs