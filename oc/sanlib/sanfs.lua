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
  local tmppath = path..'.write'
  
  file, reason = io.open(tmppath, 'w')
  if not file then
    io.stderr:write('Failed opening file '.. tmppath ..' for writing: ' .. reason)
    os.exit()
  end

  raw = serialization.serialize(data,doPrettySerialization)
  io.write('\nWRITING\n\n'..raw..'\n\n')
  success, reason = file:write(raw)
  file:close()
  file, reason = io.open(path, 'r')
  local raw1 = file:read('*a')
  io.write('\nWRITTEN\n\n'..raw1..'\n\n')
  file:close()
  
  if not success then
    io.stderr:write('Failed writing data to '.. path ..': ' .. reason)
    os.exit()
  end
  if fs.exists(path) then
    fs.remove(path)
  end
  fs.rename(tmppath,path)
  return success
end


return sanfs