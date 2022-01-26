os.loadAPI('debug')

POSTPONE_TRESHOLD = 80
TYPE_REACTOR = 'nuclear_reactor'
TYPE_MFSU = 'mfsu'
REACTOR_MULT = 5

function findPeripherals(type) -- find all peripherals of certain typr
  local result = {}
  local peripherals = peripheral.getNames()
  for i = 1,#peripherals do
    print( 'found '.. peripherals[i] .. ' - '..peripheral.getType(peripherals[i]) )
    if peripheral.getType(peripherals[i]) == type then
      table.insert(result,{ID = peripherals[i],core = peripheral.wrap(peripherals[i])})
    end
  end
  return result
end

function cls()
	term.clear()
	term.setCursorPos(1,1)
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

reactor = findPeripherals(TYPE_REACTOR)[1]
mfsu = findPeripherals(TYPE_MFSU)[1]

reactor_on = false
postpone_enabling = false
while true do
  os.queueEvent("randomEvent")
  os.pullEvent()
  mfsuEnergy = mfsu.core.getEUStored()
  mfsuMax = mfsu.core.getEUCapacity()
  mfsuPercentage = round((mfsuEnergy/mfsuMax)*10000)/100;

  if postpone_enabling and mfsuPercentage<POSTPONE_TRESHOLD then
	postpone_enabling = false
  end
  
  if postpone_enabling and mfsuPercentage<POSTPONE_TRESHOLD then
    postpone_enabling = false
  end
  
  if mfsuEnergy<mfsuMax and not(postpone_enabling) then
    reactor_on = true
  end
  
  if mfsuEnergy>=mfsuMax then
    reactor_on = false
    postpone_enabling = true
  end
  
  redstone.setOutput(reactor.ID,reactor_on)
  cls()
  print('Reactor status: '..(reactor_on and 'enabled' or 'disabled'))
  print('Reactor real status: '..(reactor.core.isActive() and 'enabled' or'disabled'))
  print('Reactor generation: '..(reactor.core.getEUOutput() * REACTOR_MULT))
  print('Energy storage: '..mfsuEnergy..'/'..mfsuMax..' ('..mfsuPercentage..')')
  if postpone_enabling then
  print('POSTPONE ENABLING')
  end
  sleep(1)
end
-- san-get update reactorctl
-- debug.dump(reactor)
-- debug.dump(mfsu)