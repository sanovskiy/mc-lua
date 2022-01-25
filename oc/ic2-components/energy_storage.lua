local component = require('component')

IC2EnergyStorage = {}

function IC2EnergyStorage:new(uuid)
  
  local obj = {}
    obj.uuid = uuid
  
  function obj.getVoltage()
    return 'N/A'
  end
end
