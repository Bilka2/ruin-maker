local util = {}
util.debugprint = __DebugAdapter and __DebugAdapter.print or function() end

local dirs = {}
for k,v in pairs(defines.direction) do
  dirs[v] = k
end
util.direction_to_str = function(direction)
  return dirs[direction]
end

local function align_to_grid(number) -- round to .5 or .0
  return math.floor((number / 0.5 ) + 0.5) * 0.5
end

util.vector_from_center = function(position, center)
  return
  {
    x = align_to_grid(position.x - center.x),
    y = align_to_grid(position.y - center.y)
  }
end

util.get_center_of_area = function(area)
  return
  {
    x = area.left_top.x + (area.right_bottom.x - area.left_top.x) / 2,
    y = area.left_top.y + (area.right_bottom.y - area.left_top.y) / 2
  }
end

util.expand_area_to_tile_border = function(area)
  for k,v in pairs(area.left_top) do
    area.left_top[k] = math.floor(v)
  end
  for k,v in pairs(area.right_bottom) do
    area.right_bottom[k] = math.ceil(v)
  end
  return area
end

return util
