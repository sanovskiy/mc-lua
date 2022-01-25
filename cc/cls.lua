aArgs = {...}
local maxRadius = tonumber(aArgs[1])
local startRadius = tonumber(aArgs[2])

if not(startRadius) then
  startRadius = 1
end
if not(maxRadius) or startRadius>maxRadius then
  print('Usage: '..shell.getRunningProgram()..' <maxRadius> [startRadius]')
  error()
end

print("Clearing spiral in radius " .. maxRadius)

function immersiveRefuel()
  print("Refuelling...")
  while turtle.getFuelLevel()<10 do
    turtle.refuel(1)
  end
  print("Done refuelling. Fuel level: "..turtle.getFuelLevel())
end

function digAll(dir)
  if dir=='down' then
    while turtle.detectDown() do
      turtle.digDown()
      sleep(.3)
	end
  elseif dir=='up' then
	while turtle.detectUp() do
      turtle.digUp()
	  sleep(.3)
	end
  else
    while turtle.detect() do
      turtle.dig()
	  sleep(.3)
	end
  end
end

function digForward(count)
  for i=1,count,1 do
    digAll()
	while not(turtle.forward()) do
	  turtle.dig()
	  turtle.attack()
	  sleep(.3)
	end
    digAll('up')
	digAll('down')
    fuel=tonumber(turtle.getFuelLevel())
    if fuel<10 then  
      immersiveRefuel()
    end
  end 
end

function makeStep(radius)
  -- entering ring
  digForward(1)
  turtle.turnRight()
  -- dig first part
  digForward(radius*2-1)
  turtle.turnRight()
  digForward(radius*2-1)
  -- entering second part
  digForward(1)
  turtle.turnRight()
  -- digging second part
  digForward(radius*2)
  turtle.turnRight()
  digForward(radius*2)
end

if 1<startRadius then
  for i=2,startRadius,1 do
	digForward(1)
	turtle.turnLeft()
	digForward(1)
	turtle.turnRight()
  end
end

for step=startRadius,maxRadius,1 do
  print('Clearing ring # '..step..' out of '..maxRadius)
  makeStep(step)
end