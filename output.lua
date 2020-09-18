local util = require("utilities")

local output

local function set_tiles(tiles, tile_filter, center, out)
  if next(tiles) == nil then return end

  out[#out+1] = "    surface.set_tiles({\n"
  local before_size = table_size(out)

  for _, tile in pairs(tiles) do
    if tile_filter[tile.name] then
      local vec = util.vector_from_center(tile.position, center)

      out[#out+1] = "            {name = \"" .. tile.name .. "\", position = "
      out[#out+1] = "{center.x + (" .. vec.x .. "), center.y + (" .. vec.y .. ")}},\n"
    end
  end

  if before_size == table_size(out) then -- no tiles added
    out[#out] = nil -- remove "    surface.set_tiles({\n"
    return
  end

  out[#out+1] = "                               }, true)\n"
end

local function create_entity(entities, center, out)
  if next(entities) == nil then return end

  out[#out+1] = "    local ce = function(params)\n"
  out[#out+1] = "        params.raise_built = true\n"
  out[#out+1] = "        return surface.create_entity(params)\n"
  out[#out+1] = "    end\n"
  out[#out+1] = "    local fN = game.forces.neutral\n"
  out[#out+1] = "    local direct = defines.direction\n"

  for _, entity in pairs(entities) do
    local vec = util.vector_from_center(entity.position, center)

    out[#out+1] = "    ce{name = \"" .. entity.name .. "\", position = "
    out[#out+1] = "{center.x + (" .. vec.x .. "), center.y + (" .. vec.y .. ")}"
    if entity.direction ~= defines.direction.north then
      out[#out+1] = ", direction = direct." .. util.direction_to_str(entity.direction)
    end
    out[#out+1] = ", force=fN}\n"
  end
end

output = function(entities, tiles, tile_filter, center, player_index)
  local out = {}
  out[1] = "return function(center, surface)\n"
  create_entity(entities, center, out)
  set_tiles(tiles, tile_filter, center, out)

  if out[2] == nil then
    game.get_player(player_index).print("Nothing selected")
    return
  end

  out[#out+1] = "end\n"
  log(table.concat(out))
end

return output
