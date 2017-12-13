local parser = require("poparse")

local cli={
  data = {}
}

local argMap = {}

local function printUsage()
  print(cli.data.loc.USAGE)
  os.exit()
end
local function projSetter(v)
  cli.data.projector = cli.data.trytofind(v)
  return cli.data.projector
end
local function scaleSetter(v)
  cli.data.scale(tonumber(v))
  return tonumber(v)
end

-- possible shift coord
local shiftCoordinate

local function setShiftParameter(v)
  if v then
    if argMap[v] then
      shiftCoordinate = v:sub(v:len())
      return true
    end
  end
end
local function setShift(v)
  cli.data.shiftVector = cli.data.shiftVector or {x=0,y=0,z=0}
  local distance = tonumber(v)
  if distance then
    cli.data.shiftVector[shiftCoordinate] = distance
  end
  return distance
end

local t_setShift = {set=setShift, default=0}
local t_projSetter = {set=projSetter, default=cli.data.holoName}
local t_scaleSetter = {set=scaleSetter, default=1}
local t_printUsage = {set=printUsage}
argMap = {
  [0] = {set=setShiftParameter},
  ["-sx"] = t_setShift,
  ["--shift_x"] = t_setShift,
  ["-sy"] = t_setShift,
  ["--shift_y"] = t_setShift,
  ["-sz"] = t_setShift,
  ["--shift_z"] = t_setShift,
  ["-p"] = t_projSetter,
  ["--projector"] = t_projSetter,
  ["-s"] = t_scaleSetter,
  ["--scale"] = t_scaleSetter,
  ["-h"] = t_printUsage,
  ["--help"] = t_printUsage,
  ["/?"] = t_printUsage
}

function cli.setHoloCfg(args)
  return parser.parseArgs(args, argMap)
end

function cli.setHandler(cliKey, handlerFunc, defaultValue)
  parser.setHandler(cliKey, handlerFunc, defaultValue, argMap)
end

return cli