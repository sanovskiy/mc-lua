BitBucketBranch = 'master'
local function printUsage()
  print( "Usages:" )
  print( "san-bb get <code> <filename>" )
end

local tArgs = { ... }
if #tArgs < 2 then
  printUsage()
    return
end

if not http then
  print( "san-pb requires http API" )
  print( "Set enableAPI_http to true in ComputerCraft.cfg" )
  return
end

local sCommand = tArgs[1]
if sCommand == "get" then
  -- Download a file from pastebin.com
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

  local response = http.get(
    "https://bitbucket.org/sanovskiy/minecraft-lua/raw/".. BitBucketBranch .."/"..textutils.urlEncode( sCode )..appendix
  )
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