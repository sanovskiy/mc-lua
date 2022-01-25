--[[

]]
local serialization = require('serialization')

table.hasKey = function(set, key)
    return set[key] ~= nil
end

table.hasValue = function(set,value)
  for _,val in pairs(set) do
    if val==value then
      return true
    end
  end
  return false
end

table.merge = function(t1,t2)
  io.write('\nMerging\n'..serialization.serialize(t1)..'\nAND\n'..serialization.serialize(t2)..'\n\n')
  result = t1
  for key,val in pairs(t2) do
    t1[key] = t2[key]
  end
  io.write('\nRESULT\n'..serialization.serialize(result)..'\n\n')
  return result
end

table.removeKey = function(table, key)
    local element = table[key]
    table[key] = nil
    return element
end