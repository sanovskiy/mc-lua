--[[
  Package manager for my soft 
]]
local AUTHOR = 'Pavel Terentyev <pavel.terentyev@gmail.com>'
local VERSION = '1.0.9'

local fs = require("filesystem")
local internet = require("internet")
local filesystem = require("filesystem")
local serialization = require("serialization")
local shell = require("shell")
local args, options = shell.parse(...)
local sanfs = require('sanfs')
require('santable')
require('sanstring')

local randstr = tostring(math.floor(math.random()*100000))
local packagesfile = '/etc/san-get/packages.list'
local installedPackagesFile = '/etc/san-get/installed.list'
local packagesList
local installedPackages

local function checkFolders()
  local folders = {
    '/etc/san-get/'
  }
  for _,path in pairs(folders) do
    if not(filesystem.exists(path)) or not(filesystem.isDirectory(path)) then
      if filesystem.exists(path) then
        filesystem.remove(path)
      end
      filesystem.makeDirectory(path)
    end
  end
end

local function checkFiles()
  if not(filesystem.exists(installedPackagesFile)) then
    sanfs:saveLuaData(installedPackagesFile,{})
  end
end

local function isOutdated(curVersion,newVersion)
  local index, v1, v2
  local ver1parts = string.split(curVersion,'%.')
  local ver2parts = string.split(newVersion,'%.')
  if #ver1parts~=#ver2parts then
    if #ver1parts>#ver2parts then
      while #ver2parts<#ver1parts do
        table.insert(ver2parts,'0')
      end
    else
      while #ver2parts>#ver1parts do
        table.insert(ver1parts,'0')
      end
    end
  end

  for index=0,#ver1parts do
    v1 = ver1parts[index] or 0
    v2 = ver2parts[index] or 0
    if v2 > v1 then
      return true
    end
  end
  return false
end

local function showHelp()
  io.write('Usage: \n')
  io.write('  san-get update - updates packages list\n')
  io.write('  san-get install [-f] <packagename> - installs new package\n')
  io.write('  san-get remove <packagename> - remove installed package\n')
  io.write('  san-get upgrade [-f] [packagename] - updates package. If no package name supplied - tries to update all installed\n')
  io.write('  san-get list - lists all available packages\n')
  io.write('  san-get help - shows this help\n')
  io.write('san-get version '..VERSION)
end

local function loadInstalledPackages(forceLoad)
  forceLoad = forceLoad or false
  if installedPackages==nil or forceLoad then
    installedPackages = sanfs:loadLuaData(installedPackagesFile)
  end
end

local function saveInstalledPackages()
  sanfs:saveLuaData(installedPackagesFile,installedPackages)
end

local function isPackageInstalled(packageName)
  if installedPackages==nil then
    loadInstalledPackages()
  end
  return table.hasKey(installedPackages,packageName) 
end

local function loadFileFromInternet(url,path)
  local partial = path..'.part'
  local f, reason = io.open(partial, "w")
  if not f then
    io.stderr:write("Failed opening file for writing: " .. reason..'\n')
    return
  end
  io.write('  Downloading '..path..' ')
  local result, response = pcall(internet.request, url)
  if result then
    for chunk in response do
      if not options.k then
        string.gsub(chunk, "\r\n", "\n")
      end
      f:write(chunk)
    end
    f:close()
    if filesystem.exists(path) then
      filesystem.remove(path)
    end
    filesystem.rename(partial,path)
    io.write('done\n')
  else
    filesystem.remove(partial)
    f:close()
    io.write('failed\n')
    io.stderr:write("HTTP request failed: " .. response .. "\n")
    os.exit()
  end
end

local function loadPackages(forceLoad)
  forceLoad = forceLoad or false
  if packagesList==nil or forceLoad then
    packagesList = sanfs:loadLuaData(packagesfile)
  end
  
  --serialization.serialize(packagesList)
  for packageName,info in pairs(packagesList) do
    if table.hasKey(info,'info') then
      -- io.write('Downloading info for '..packageName..' from '..info['info']..'\n')
      loadFileFromInternet(info['info'],'/tmp/'..packageName..'_info.lua')
      local subInfo = sanfs:loadLuaData('/tmp/'..packageName..'_info.lua')
      info = table.merge(info,subInfo)
      table.removeKey(info,'info')
      packagesList[packageName] = info
    end
  end
  io.write('\n\n WRITING\n')
  io.write(serialization.serialize(packagesList)..'\n')
  sanfs:saveLuaData(packagesfile,packagesList)
  io.write('DONE\n\n')
  return packagesList
end

local function getPackageInfo(packageName)
  loadPackages()
  if table.hasKey(packagesList,packageName) then
    return packagesList[packageName]
  end
  return nil
end

local function getInstalledPackageVersion(packageName)
  if not(isPackageInstalled(packageName)) then
    return 0
  end
  return installedPackages[packageName]
end

local function getPackageLatestVersion(packageName)
  loadPackages()
  return packagesList[packageName]['version']
end

local function getPackageDependencies(packageName)
  loadPackages()
  local pInfo = getPackageInfo(packageName)
  local dep = pInfo['dependencies']
  if #pInfo['dependencies']>0 then
    for _,depName in pairs(pInfo['dependencies']) do
      local subdeps = getPackageDependencies(depName)
      if #subdeps>0 then
        for _,subdepName in pairs(subdeps) do
          if not(isPackageInstalled(subdepName)) and not(table.hasValue(dep,subdepName)) then
            table.insert(dep,1,subdepName)
          end
        end
      end
    end
  end
  return dep
end

local function doInstallFiles(pList)
  for _,packageName in pairs(pList) do
    io.write('Loading files for ' .. packageName .. '\n')
    local pInfo = getPackageInfo(packageName)
    for path,url in pairs(pInfo['files']) do
      if pInfo['addrandom'] then
        url = url..'?'..randstr
      end
      loadFileFromInternet(url,path)
    end
    installedPackages[packageName] = pInfo['version']
  end
  saveInstalledPackages()
end

-- Main
checkFolders() -- checking required folders
checkFiles() -- checking required files

local command = args[1]
local packageName = args[2]
local force = options['f'] or false
local actions = {
  ['update'] = function(...)
    loadFileFromInternet("https://raw.githubusercontent.com/sanovskiy/mc-lua/master/oc/packages.lua",packagesfile)
    -- loadPackages()
  end,

  ['upgrade'] = function(packageName) -- upgrades package or all installed
    loadInstalledPackages()
    local packagesToUpgrade = {}
    local packagesToDoUpgrade = {}
    if packageName==nil then
      packagesToUpgrade = installedPackages
    else 
      local pInfo = getPackageInfo(packageName)
      if pInfo==nil then
        io.stderr:write('Package '..packageName..' not found\n')
        os.exit()
      end
      if not(isPackageInstalled(packageName)) then
        io.stderr:write('Package '..packageName..' not installed\n')
        os.exit()
      end
      if not(isOutdated(getInstalledPackageVersion(packageName),pInfo['version'])) and not(force) then
        io.stderr:write('Package '..packageName..' is up to date\n')
        os.exit()
      end
      table.insert(packagesToDoUpgrade,packageName)
      
      local deps = getPackageDependencies(packageName)
      for _,dep in pairs(deps) do
        if not(isPackageInstalled(dep)) then
          table.insert(packagesToDoUpgrade,dep)
        else
          table.insert(packagesToUpgrade,dep)
        end
      end
    end
    
    for p,ver in pairs(packagesToUpgrade) do
      if force or isOutdated(ver,getPackageLatestVersion(p)) then
        if not(table.hasValue(packagesToDoUpgrade,p)) then
          table.insert(packagesToDoUpgrade,1,p)
        else
          io.write(p.. ' - up to date\n')
        end
      end
    end
    
    if #packagesToDoUpgrade>0 then
      doInstallFiles(packagesToDoUpgrade)
      io.write('Updated\n')
    else
      io.write('Nothing to upgrade\n')
    end
  
  end,

  ['install'] = function(packageName)
    if packageName==nil then
      io.stderr:write('Package '..packageName..' not found\n')
      os.exit()
    end
    if isPackageInstalled(packageName) and (not(force)) then
      io.stderr:write('Package '..packageName..' already installed\n')
      os.exit()
    end
    
    local packageInfo = getPackageInfo(packageName)
    if packageInfo==nil then
      io.stderr:write('Package '..packageName..' not found\n')
      os.exit()
    end
    io.write('Checking for dependencies...\n')
    local dependecies = getPackageDependencies(packageName)
    if #dependecies>0 then
      io.write('Installing dependencies:\n')
      io.write('  '..table.concat(dependecies,', ')..'\n')
      doInstallFiles(dependecies)
    end
    io.write('Installing package:\n')
    doInstallFiles({packageName})

  end,

  ['remove'] = function(package)
    io.write('Not implemented yet. Sorry.\n')
    os.exit()
  end,

  ['list'] = function(...)
    if not(fs.exists(packagesfile)) then
      io.stderr:write('No packages list found. Try do `san-get update` first\n')
      os.exit()
    end
    loadPackages()
    for packageName,pInfo in pairs(packagesList) do
      local inst = '-'
      if isPackageInstalled(packageName) then
        inst = '+'
      end
      io.write(inst..' '..packageName .. ' - ('..pInfo['version']..') '..pInfo['description']..'\n')
    end
    
  end,
  ['help'] = function(...)
    showHelp()
  end
  
}

if table.hasKey(actions,command)~=true then
  showHelp()
  os.exit()
end
actions[command](packageName)

