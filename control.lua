local math2d = require("math2d")
local util = require("utilities")

local function output_entities(entities, center)
  local output = {}
  output[1] = "return function(center, surface)\n"
  output[2] = "    local ce = function(params)\n"
  output[3] = "        params.raise_built = true\n"
  output[4] = "        return surface.create_entity(params)\n"
  output[5] = "    end\n"
  output[6] = "    local fN = game.forces.neutral\n"
  output[7] = "    local direct = defines.direction\n"

  for _, entity in pairs(entities) do
    local vec = util.vector_from_center(entity.position, center)

    output[#output+1] = "    ce{name = \"" .. entity.name .. "\", position = "
    output[#output+1] = "{center.x + (" .. vec.x .. "), center.y + (" .. vec.y .. ")}"
    if entity.direction ~= defines.direction.north then
      output[#output+1] = ", direction = direct." .. util.direction_to_str(entity.direction)
    end
    output[#output+1] = ", force=fN}\n"
  end

  output[#output+1] = "end\n"
  log(table.concat(output))
end

script.on_event(defines.events.on_player_selected_area, function(event)
  if event.item ~= "ruin-maker" then return end
  local player = game.get_player(event.player_index)
  local center = math2d.bounding_box.get_centre(event.area)
  output_entities(event.entities, center)
  for _, tile in pairs(event.tiles) do
    player.print(tile.name)
  end
end)

script.on_event(defines.events.on_player_alt_selected_area, function(event)
  if event.item ~= "ruin-maker" then return end
  local player = game.get_player(event.player_index)
  local center = math2d.bounding_box.get_centre(event.area)
  output_entities(event.entities, center)
  for _, tile in pairs(event.tiles) do
    player.print(tile.name)
  end
end)
