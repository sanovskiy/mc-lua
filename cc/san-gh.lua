local function printUsage()
  print( "Usages:" )
  print( "san-gh get <file>" )
end
 
local tArgs = { ... }
if #tArgs < 2 then
  printUsage()
    return
end
 
if not http then
  print( "san-gh requires http API" )
  print( "Set enableAPI_http to true in ComputerCraft.cfg" )
  return
end
 
local sCommand = tArgs[1]
if sCommand == "get" then
  -- Download a file from Github
  if #tArgs < 3 then
    printUsage()
    return
  end
 
  -- Determine file to download
  local sCode = tArgs[2]
  local sFile = tArgs[3]
  local sPath = shell.resolve( sFile )
  if fs.exists( sPath ) then
    print( "File already exists" )
    return
  end
  local appendix = '?' .. math.random(100000,999999)
  local url = "https://raw.githubusercontent.com/sanovskiy/mc-lua/master/cc/" .. sCode .. appendix
  local response = http.get(url)
  if response then
    print( "Success." )
   
    local sResponse = response.readAll()
    response.close()
   
    local file = fs.open( sPath, "w" )
    file.write( sResponse )
    file.close()
  else
    print( "Failed." )
  end  
 
else
  printUsage()
  return
end