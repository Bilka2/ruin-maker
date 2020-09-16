local util = {}
util.debugprint = __DebugAdapter and __DebugAdapter.print or function() end

local dirs = {}
for k,v in pairs(defines.direction) do
  dirs[v] = k
end
util.direction_to_str = function(direction)
  return dirs[direction]
end

util.round = function(number)
  return math.floor(number * 10 + 0.5) / 10
end

util.vector_from_center = function(position, center)
  return {x = util.round(position.x - center.x), y = util.round(position.y - center.y)}
end

return util
