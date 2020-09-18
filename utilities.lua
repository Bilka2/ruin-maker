local util = {}
util.debugprint = __DebugAdapter and __DebugAdapter.print or function() end

local dirs = {}
for k,v in pairs(defines.direction) do
  dirs[v] = k
end
util.direction_to_str = function(direction)
  return dirs[direction]
end

util.align_to_grid = function(number) -- round to .5 or .0
  return math.floor((number / 0.5 ) + 0.5) * 0.5
end

util.vector_from_center = function(position, center)
  return {x = util.align_to_grid(position.x - center.x), y = util.align_to_grid(position.y - center.y)}
end

return util
