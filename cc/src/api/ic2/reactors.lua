os.loadAPI('/lib/debug')

local deviceTypes = {"ic2:nuclear reactor", "ic2:reactor chamber"}

allDevices = {}

deviceSide = {}

for _, deviceType in pairs(deviceTypes) do
  for __, device in pairs({peripheral.find(deviceType)}) do
    if device.getReactorCore ~= nil then
      device = device.getReactorCore()
    end
    table.insert(allDevices, device)
  end
end

function getAllDevices()
  return allDevices
end

function getDevicesCount()
  return #allDevices
end

function hasEmptySlots(entity)
  
end

--function getTotalEnergy()
--  local result = 0
--  for _, v in pairs(allEntities) do
--    result = result + v.getEUStored()
--  end
--  return result
--end

--function getTotalCapacity()
--  local result = 0
--  for _, v in pairs(allEntities) do
--    result = result + v.getEUCapacity()
--  end
--  return result
--end
