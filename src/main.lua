-- Gets list of links on the Control Unit
local links = library.getLinks()
local linksToIgnore = { 'unit', 'export' }
local json = require('dkjson')

-- Finds keyed table length
function table_length (table)
  local length = 0

  for k, v in pairs(table) do
    length = length + 1
  end

  return length
end

-- Finds index of value on table
function table_index_of (table, value)
  for k, v in pairs(table) do
    if v == value then
      return k
    end
  end

  return false
end

-- Makes value into string
function value_to_string (data)
  if 'nil' == type(data) then
    return 'nil'
  else
    return json.encode(data)
  end
end

-- Header text
system.print(string.format('Found %d link(s) on Control Unit:', (table_length(links) - #linksToIgnore)))
for linkName, element in pairs(library.getLinks()) do
  if not table_index_of(linksToIgnore, linkName) then
    -- Basic information
    system.print('------------------------------')
    system.print('Link Name: ' .. linkName)
    system.print('Link Type: ' .. element.getElementClass())
    system.print('Link API:')

    -- Shows the Lua API
    for linkProp, linkPropValue in pairs(element) do
      local linkPropType = type(linkPropValue)
      local linkPropValueString = ''

      -- Prints data
      system.print(string.format('[%s] %s.%s %s', linkPropType, linkName, linkProp, linkPropValueString))

      -- Handles getter functions
      if 'get' == linkProp:sub(1, 3) and 'function' == type(linkPropValue) then
        local canGetValue, getterValue = pcall(linkPropValue)
        if canGetValue then
          system.print(string.format('  ↳ [%s] %s', type(getterValue), value_to_string(getterValue)))
        end
      end
    end

    -- Shows the Data
    if element.getData then
      system.print('Link Data:')
      system.print(element.getData())
    end
  end
end

-- Stops execution
unit.exit()