local util = require("utilities")

local output

local function set_tiles(tiles, tile_filter, center, out)
  if next(tiles) == nil then return end

  out[#out+1] = "  tiles =\n"
  out[#out+1] = "  {\n"
  local before_size = table_size(out)

  for _, tile in pairs(tiles) do
    if tile_filter[tile.name] then
      local vec = util.vector_from_center(tile.position, center)

      out[#out+1] = "    {\"" .. tile.name .. "\", "
      out[#out+1] = "{x = " .. vec.x .. ", y = " .. vec.y .. "}},\n"
    end
  end

  if before_size == table_size(out) then -- no tiles added
    out[#out] = nil -- remove "  {\n"
    out[#out] = nil -- remove "  tiles =\n"
    return
  end

  out[#out+1] = "  }\n"
end

local function create_entity(entities, center, out)
  if next(entities) == nil then return end

  out[#out+1] = "  entities =\n"
  out[#out+1] = "  {\n"

  for _, entity in pairs(entities) do
    local vec = util.vector_from_center(entity.position, center)

    out[#out+1] = "    {\"" .. entity.name .. "\", "
    out[#out+1] = "{x = " .. vec.x .. ", y = " .. vec.y .. "}, "

    out[#out+1] = "{" -- extra options start

    local dir = entity.direction
    if dir ~= defines.direction.north then
      out[#out+1] = "dir = \"" .. util.direction_to_str(dir) .. "\", "
    end
    if entity.is_entity_with_owner then
      if entity.force.name ~= "player" and entity.force.name ~= "neutral" then
        out[#out+1] = "force = \"enemy\", "
      end
    end
    if entity.is_entity_with_health and (entity.get_health_ratio() ~= 1) then
      local dmg = math.floor(entity.prototype.max_health - entity.health)
      out[#out+1] = "dmg = {dmg = " .. dmg .. "}, "
    end
    if entity.has_items_inside() then
      local inv = nil
      if entity.type == "container" then
        inv = entity.get_inventory(defines.inventory.chest)
      elseif entity.type == "ammo-turret" then
        inv = entity.get_inventory(defines.inventory.turret_ammo)
      end
      if inv then
        out[#out+1] = "items = " .. serpent.line(inv.get_contents()) .. ", "
      end
    end
    if entity.type == "assembling-machine" then
      local recipe = entity.get_recipe()
      if recipe then
        out[#out+1] = "recipe = \"" .. recipe.name .. "\", "
      end
    end
    out[#out+1] = "}},\n" -- extra options and entity end
  end

  out[#out+1] = "  },\n"
end

output = function(entities, tiles, tile_filter, center, name, player_index)
  local out = {}
  out[1] = "return\n"
  out[2] = "{\n"
  create_entity(entities, center, out)
  set_tiles(tiles, tile_filter, center, out)

  if out[3] == nil then
    game.get_player(player_index).print("Nothing selected")
    return
  end

  out[#out+1] = "}\n"
  game.write_file("ruins/" .. name .. ".lua", table.concat(out))
end

return output
