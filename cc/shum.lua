s = peripheral.wrap('left')
s.setAttenuation(10)

minFq = 100
maxFq = 3000
minCh = 0
maxCh = 7

mainloop = true

function main()
  while mainloop do
	sine(minFq,maxFq,0)
	os.sleep(0.01)
  end
end

function main1()
  sleep(1)
  while mainloop do
	sine(minFq,maxFq,1)
	os.sleep(0.01)
  end
end

function sine(minF,maxF,channel)
  diff = maxF - minF
  mid = round((maxF+minF)/2)
  for i = 0, 180, 0.25 do
    sinus = math.sin(i)
	pitch = round(diff * sinus)
	if pitch > diff then
	  pitch = diff
	end
	freq = mid + pitch
	s.start(channel,freq)
	os.sleep(0.3)
  end	
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function random()
  newFq = math.random(minFq,maxFq)
  atCh = math.random(minCh,maxCh)
  print(newFq .. '@' .. atCh)
  s.start(atCh,newFq)
end

function eventListener()
  while mainloop do
    local event, param = os.pullEvent()
    if event == 'key' then
      if param == keys.enter then
        for i = minCh, maxCh do
          s.stop(i)
        end
	    mainloop = false
	  end
    end
  end
end

parallel.waitForAny(eventListener, main, main1)