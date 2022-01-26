args = {...}
command = args[1] or "help"
args[2] = args[2] or ""

if not (fs.exists("/etc")) then
    fs.makeDir("/etc")
end
if not (fs.exists("/lib")) then
    fs.makeDir("/lib")
end

local InitAnnounced = false

if not (fs.exists("/lib/json")) then
    if not (InitAnnounced) then
        print("Initial install...")
        InitAnnounced = true
    end
    print("  Installing JSON API")
    shell.run("pastebin", "get 4nRg9CHU /lib/json")
end
os.loadAPI("/lib/json")

function printUsage()
    print("Usage: ")
    print("  san-get <selfupdate|install <progname>>")
    return
end

function vardump(x)
    for k, v in pairs(x) do
        print(k .. "  " .. v)
    end
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function table.join(table, glue)
    local result
    local counter = 0
    for _, value in pairs(table) do
        if counter == 0 then
            result = value
        else
            result = result .. glue .. value
        end
    end
    return result
end

function download(sUrl, file)
  -- Check if the URL is valid
  local ok, err = http.checkURL(sUrl)
  -- print("Downloading "..sUrl.." into "..file)
  if not ok then
      printError(err or "Invalid URL.")
      return false
  end

  local response = http.get(sUrl , nil , true)
  if not response then
      printError("Download failed.")
      return false
  end

  local sResponse = response.readAll()
  response.close()

  f = fs.open(file, "w")
  f.write(sResponse)
  f.close()
  return true
end

function updateRepo()
    print("Updating repo info")
    if fs.exists("/etc/repo.json") then
        fs.delete("/etc/repo.json")
    end
    local randstr = tostring(math.floor(math.random() * 100000))
    download("https://raw.githubusercontent.com/sanovskiy/mc-lua/master/cc/repo.json?" .. randstr,"/etc/repo.json")
end

function readRepoFile()
    if not (fs.exists("/etc/repo.json")) then
        updateRepo()
    end
    return json.decodeFromFile("/etc/repo.json")
end

function calcRequirements(softName, exclude)
    local repo = readRepoFile()
    exclude = exclude or {}
    local requirements = {}
    if repo[softName] ~= nil then
        if repo[softName]["requires"] ~= nil then
            for key, value in pairs(repo[softName]["requires"]) do
                if not (table.contains(requirements, value)) and not (table.contains(exclude, value)) then
                    table.insert(requirements, value)
                    table.insert(exclude, value)
                    for key1, value1 in pairs(calcRequirements(value, exclude)) do
                        if not (table.contains(requirements, value1)) then
                            table.insert(requirements, value1)
                        end
                    end
                end
            end
        end
    end
    return requirements
end

function dloadSoftFiles(softName)
    local soft = readRepoFile()[softName]
    for _, file in pairs(soft.files) do
        if fs.exists(file.localname .. ".tmp") then
            fs.delete(file.localname .. ".tmp")
        end
        -- print("DL: " .. file.url .. " -> " .. file.localname .. ".tmp")
        local randstr = tostring(math.floor(math.random() * 100000))
        local sUrl = file.url .. "?" .. randstr
        
        if not (download(sUrl, file.localname .. ".tmp")) then
            error("Failed to load " .. file.url)
            return
        end
        if fs.exists(file.localname) then
            -- print("RM: " .. file.localname)
            fs.delete(file.localname)
        end
        -- print("CP: " .. file.localname .. ".tmp -> " .. file.localname)
        fs.copy(file.localname .. ".tmp", file.localname)
        if fs.exists(file.localname .. ".tmp") then
            fs.delete(file.localname .. ".tmp")
        end
    end
end

function installSoftware(softName)
    local repo = readRepoFile()
    if repo[softName] == nil then
        error(softName .. " not found in repo")
        return
    end
    print("Installing " .. softName)
    local reqs = calcRequirements(softName)
    print("Requirements: " .. (table.join(reqs, ", ") or "NONE"))
    for _, subSoftName in pairs(reqs) do
        print("  Updating " .. subSoftName)
        dloadSoftFiles(subSoftName)
    end
    print("  Updating " .. softName)
    dloadSoftFiles(softName)
end

if not (fs.exists("/etc/repo.json")) then
    updateRepo()
end

local command = string.lower(args[1] or "help")

local actions = {
    selfupdate = function(opts)
        updateRepo()
        installSoftware("san-get")
    end,
    install = function(opts)
        local softName = opts[1]
        installSoftware(softName)
    end,
    help = function(x)
        printUsage()
    end
}

if actions[command] ~= nil then
    if args[2] ~= nil then
        actions[command] {args[2]}
        return
    end
end

printUsage()
return
