--[[

]]

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
