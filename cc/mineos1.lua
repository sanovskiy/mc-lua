DATA_FILE = "miners.dat" -- Файл для сохранения данных
TEMP_FILE = "miners.temp" -- Временное хранилище
REFRESH_RATE = 5		-- Seconds

BACKGROUND_COLOR = 1	-- White
TEXT_COLOR = 32768		-- Black

nTotal = 0
mLayerOffset = 30

nLowEnergy = 0
nMining = 0
nQuarry = 0
nStopped = 0
maxLayer = 0
minLayer = 256

scrX, scrY = term.getSize()

peripherals = peripheral.getNames()
for i = 1, #peripherals do
  if peripheral.getType(peripherals[i]) == "modem" then
    modem = peripheral.wrap(peripherals[i])
  end
end
miner = {}

--------------------------------------------------

	-- Массив данных о майнерах:
	-- 1 - 'state'
	-- 2 - 'energy'
	-- 3 - 'currentLayer'
	-- 4 - 'mined'
	-- 5 - 'total'

minersStats = {}
for i = 1, 81 do
    minersStats[i] = {}

    for j = 1, 7 do
        minersStats[i][j] = 0 -- Fill the values here
    end
end

--------------------------------------------------
-- Инициализация
--------------------------------------------------

function updateSoftware()
  if not(fs.exists("san")) then
    shell.run("pastebin","get wf2EBfvT san")
  end
  shell.run("san"," update san")
  shell.run("san"," update moneos1")
  os.reboot()
end

function FindMiners ()
	for i = 1, #peripherals do
		if peripheral.getType(peripherals[i]) == "mininglaser" then
			nTotal = nTotal + 1
			miner[nTotal] = peripherals[i]
		end
	end
end

--------------------------------------------------
-- Сбор статистики
--------------------------------------------------

function UpdateMiner (minerN)
	local state, energy, currentLayer, mined, total = modem.callRemote(miner[minerN], "state")

	minersStats[minerN][1] = state
	minersStats[minerN][2] = energy
	minersStats[minerN][3] = currentLayer
	minersStats[minerN][4] = mined
	minersStats[minerN][5] = total

	return 0
end

function UpdateAllMiners() -- Обновление статусов всех майнеров
	for i = 1, nTotal do
		UpdateMiner(i)
	end

	return 0
end

function RecalculateStatistics ()
	nOnline = 0
	nLowEnergy = 0
	nMining = 0
	nQuarry = 0
	nStopped = 0
	maxLayer = 0
	minLayer = 256

	for i = 1, nTotal do
		-- nLowEnergyTemp
		if minersStats[i][2] <= 20000 then
			nLowEnergy = nLowEnergy + 1
		end
		-- Scanning ores
		-- Mining ores
		-- nMiningTemp, nQuarryTemp, nStoppedTemp
		ooemessage = " - Out of energy"
		if minersStats[i][1] == "IDLE (not mining)" or minersStats[i][1] == "IDLE (not mining)".. ooemessage then
			nStopped = nStopped + 1
		elseif minersStats[i][1] == "Mining ores" or minersStats[i][1] == "Mining ores" .. ooemessage then
			nMining = nMining + 1
		elseif minersStats[i][1] == "Mining all" or minersStats[i][1] == "Mining all"..ooemessage then
			nQuarry = nQuarry + 1
		end
		-- maxLayerTemp
		maxLayer = math.max(maxLayer, minersStats[i][3])
		minLayer = math.min(minLayer, minersStats[i][3])
	end

	return 0
end

--------------------------------------------------
-- Интерфейс
--------------------------------------------------

function CommandAllMiners(command)
	for i = 1, nTotal do
		modem.callRemote(miner[i], "offset", mLayerOffset)
		modem.callRemote(miner[i], command)
	end
end

function DrawBackground ()
	term.setBackgroundColor(BACKGROUND_COLOR)
	term.setTextColor(TEXT_COLOR)
	term.setCursorBlink(false)
	term.clear()
	term.setCursorPos(1, 1)

	term.write("\t\t< Mining lasers >")
end

function WriteStats ()
	term.setCursorPos(1, 3)
	term.write("Online:\t\t" .. nTotal)
	term.setCursorPos(1, 4)
	term.write("Mining, quarry:\t\t" .. nMining .. ":" .. nQuarry)
	term.setCursorPos(1, 5)
	term.write("Max/min level:\t\t" .. maxLayer .. "/" .. minLayer)
	term.setCursorPos(1, 6)
	term.write("Low energy:\t\t" .. nLowEnergy)
end

function WriteButtonsExplanation ()
	term.setCursorPos(1, scrY-4)
	term.write("M - mine, Q - quarry, S - stop")
	term.setCursorPos(1, scrY-3)
	term.write("O - set offset")
	term.setCursorPos(1, scrY-2)
	term.write("R - refresh, X - exit, U - update soft")
end

function ReceiveOffset ()
	sleep(1/20)
	term.setCursorPos(1, 3)
	term.write("Enter offset:")
	term.setCursorPos(1, 4)
	term.write("> ")

	term.setCursorBlink(true)
	local input = read()
	term.setCursorBlink(false)

	mLayerOffset = tonumber(input)

	return mLayerOffset
end

function Shutdown()
	term.setBackgroundColor(32768)
	term.setTextColor(1)
	term.setCursorPos(1, 1)
	term.clear()
	print("Bye!..")
	sleep(1)
--	os.shutdown()
	error()
end

--------------------------------------------------
-- Сохранение и загрузка
--------------------------------------------------

function SaveToFile()
	local file = fs.open(TEMP_FILE, "w")
	file.writeLine(mLayerOffset .. "")
	file.close()

	fs.delete(DATA_FILE)
	fs.move(TEMP_FILE, DATA_FILE)

	return 0
end

function LoadFromFile()
	local file = fs.open(DATA_FILE, "r")
	mLayerOffset = tonumber(file.readLine())
	file.close()

	return 0
end

--------------------------------------------------
-- Главный луп
--------------------------------------------------

function main ()
	FindMiners()

	if fs.exists(DATA_FILE) then
		LoadFromFile()
	end

	while true do
		UpdateAllMiners()
		RecalculateStatistics()

		DrawBackground()
		WriteStats()
		WriteButtonsExplanation ()

		local timeout = os.startTimer(REFRESH_RATE)
		while true do

			event = {os.pullEvent()}

			if event[1] == "key" then
				if event[2] == 50 then				-- M - mining
					CommandAllMiners("mine")
				elseif event[2] == 16 then			-- Q - quarry
					CommandAllMiners("quarry")
				elseif event[2] == 31 then			-- S - stop
					CommandAllMiners("stop")
				elseif event[2] == 24 then			-- O - offset
					DrawBackground()
					ReceiveOffset()
					SaveToFile()
					break
				elseif event[2] == 19 then			-- R - refresh
					break
				elseif event[2] == 45 then			-- X - shutdown
					Shutdown()
				elseif event[2] == 22 then          -- u
					updateSoftware()					
				end
				local timeout2 = os.startTimer(REFRESH_RATE)

			elseif event[1] == "timer" and event[2] == timeout then
				break
			end
		end
	end
end
main()