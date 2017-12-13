-- poparse.lua kinazarov 2017
local quotes = {['"'] = 1, ["'"] = 2}

function dequote(argTable)
  local savedQuote

  local function firstQuote(astring, aquote)
    local firstSymbol = astring:sub(1,1)
    return quotes[firstSymbol], firstSymbol
  end
  local function lastQuote(astring, aquote)
    local lastSymbol = astring:sub(astring:len())
    return quotes[lastSymbol], lastSymbol
  end

  local argsOut = {}
  local argIndex = 1
  local index, value = next(argTable)
  while index do
    if savedQuote then
      local endQuoted = lastQuote(value, savedQuote)
      if endQuoted then
        savedQuote = nil
        argsOut[argIndex] = argsOut[argIndex] .. " " .. value:sub(1, value:len() - 1)
        argIndex = argIndex + 1
      else
        argsOut[argIndex] = argsOut[argIndex] .. " " .. value
      end
    else
      local startQuoted, charFirst = firstQuote(value, savedQuote)
      if startQuoted then
        if value:len() == 1 then
          argsOut[argIndex] = ''
          savedQuote = charFirst
        else
          local endQuoted, charLast = lastQuote(value)
          if charFirst == charLast then
            argsOut[argIndex] = value:sub(2,-2)
            argIndex = argIndex + 1
          else
            savedQuote = charFirst
            argsOut[argIndex] = value:sub(2)
          end
        end
      else
        argsOut[argIndex] = value
        argIndex = argIndex + 1
      end
    end
    index, value = next(argTable, index)
  end
  return argsOut
end


local function setArgumentProcessor(argKey, argProcessingFunc, defaultValue, argMap)
  argMap = argMap or {}
  argMap[argKey] = {set = argProcessingFunc, default = defaultValue}
  return argMap
end

local function parseArgs(args, map)
  if not(args and #args > 0) then return args end
  if not(map and #map > 0) then return args end
  -- {key1,"\"value","multiword\""} to {key1,"value multiword"}
  local savedArgs = dequote(args)
  if map then
    for i, v in ipairs(args) do
      --get handler for key or position. Position 0 means run handler func for every cli argument
      if map[0] then
        map[0].set(map[0].default or v)
      end
      local vSetter = map[v] or map[i]
      if vSetter then
        local value = args[i+1]
        if value and not map[value] then
          --process key arguments like --key1 value1 --key2 value2 ...
          if not vSetter.set(value) then vSetter.set(vSetter.default) end
        else
          --process key arguments like --key1 --key2 and positional ones
          vSetter.set(v)
        end
      end
    end
  end
  return savedArgs
end

poparse = {
  setHandler = setArgumentProcessor,
  parseArgs = parseArgs
}

return poparse