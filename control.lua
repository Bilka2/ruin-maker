local util = require("utilities")
local output_selection = require("output")

local function discard_selection(player_index)
  for _, render in pairs(global.selection[player_index].renders) do
    rendering.destroy(render)
  end
  global.selection[player_index] = nil
end

local function confirm_selection(player_index, name)
  local data = global.selection[player_index]
  output_selection(data.entities, data.tiles, data.tile_filter, data.center, name ~= "" and name or "unknown", data["ruin-maker-damage"], data["ruin-maker-items"], player_index)
  discard_selection(player_index)
end

script.on_event(defines.events.on_gui_click, function(event)
  if event.element.name == "ruin-maker-confirm" then
    confirm_selection(event.player_index, global.selection[event.player_index].name.text)
    game.get_player(event.player_index).gui.screen["ruin-maker-main"].destroy()
  elseif event.element.name == "ruin-maker-cancel" then
    discard_selection(event.player_index)
    game.get_player(event.player_index).gui.screen["ruin-maker-main"].destroy()
  end
end)

script.on_event(defines.events.on_gui_checked_state_changed, function(event)
  if event.element.parent and event.element.parent.name == "ruin-maker-tile-filter" then
    global.selection[event.player_index].tile_filter[event.element.name] = event.element.state
  elseif event.element.parent and event.element.parent.name == "ruin-maker-config" then
    global.selection[event.player_index][event.element.name] = event.element.state
  end
end)

script.on_event(defines.events.on_gui_confirmed, function(event)
  if not global.selection[event.player_index] then return end
  if event.element == global.selection[event.player_index].name then
    confirm_selection(event.player_index, event.element.text)
    game.get_player(event.player_index).gui.screen["ruin-maker-main"].destroy()
  end
end)

local function config_gui(player, tile_names, area)
  local gui = player.gui.screen.add{type = "frame", caption = {"gui.ruin-maker-config"}, direction = "vertical", name = "ruin-maker-main"}
  gui.force_auto_center()
  gui = gui.add{type = "frame", style = "inside_shallow_frame_with_padding"}
  gui = gui.add{type = "table", name = "ruin-maker-config", style = "bordered_table", column_count = 1}

  do
    local w = area.right_bottom.x - area.left_top.x
    local h = area.right_bottom.y - area.left_top.y
    local name = "too big"
    if w <= 8 and h <= 8 then
      name = "small"
    elseif w <= 16 and h <= 16 then
      name = "medium"
    elseif w <= 32 and h <= 32 then
      name = "large"
    end

    local flow = gui.add{type="flow", direction = "vertical"}
    flow.add{type = "label", caption = {"gui.ruin-maker-size", name, w, h}}
  end

  do
    local flow = gui.add{type="flow", direction = "vertical"}
    flow.add{type = "label", caption = {"gui.ruin-maker-name"}}
    global.selection[player.index].name = flow.add{type = "textfield"}
    global.selection[player.index].name.focus()
  end

  if next(tile_names) ~= nil then
    local frame = gui.add{type="flow", name = "ruin-maker-tile-filter", direction = "vertical"}
    frame.add{type = "label", caption = {"gui.ruin-maker-tile-filter"}}
    for tile_name in pairs(tile_names) do
      frame.add{type = "checkbox", name = tile_name, caption = tile_name, state = true}
    end
  end

  gui.add{type = "checkbox", name = "ruin-maker-damage", caption = {"gui.ruin-maker-damage"}, state = true}
  gui.add{type = "checkbox", name = "ruin-maker-items", caption = {"gui.ruin-maker-items"}, state = true}

  gui.add{type = "button", name = "ruin-maker-cancel", caption = {"gui.ruin-maker-cancel"}}
  gui.add{type = "button", name = "ruin-maker-confirm", caption = {"gui.ruin-maker-confirm"}}
end

local function configure_selection(entities, tiles, area, center, player_index, renders)
  local tile_names = {}
  for _, tile in pairs(tiles) do
    tile_names[tile.name] = true
  end

  global.selection[player_index] = {
    entities = entities,
    tiles = tiles,
    tile_filter = tile_names,
    center = center,
    renders = renders,
    ["ruin-maker-damage"] = true,
    ["ruin-maker-items"] = true
  }

  config_gui(game.get_player(player_index), tile_names, area)
end

local function render_selection(area, center, surface)
  local renders = {}
  renders[#renders+1] = rendering.draw_line(
  {
    from = {center.x + 0.5, center.y},
    to = {center.x - 0.5, center.y},
    width = 4,
    color = {1, 1, 1},
    surface = surface
  })
  renders[#renders+1] = rendering.draw_line(
  {
    from = {center.x, center.y + 0.5},
    to = {center.x, center.y - 0.5},
    width = 4,
    color = {1, 1, 1},
    surface = surface
  })
  renders[#renders+1] = rendering.draw_rectangle(
  {
    left_top = area.left_top,
    right_bottom  = area.right_bottom,
    filled = false,
    width = 4,
    color = {1, 1, 1},
    surface = surface
  })
  return renders
end

script.on_event({defines.events.on_player_selected_area, defines.events.on_player_alt_selected_area}, function(event)
  if event.item ~= "ruin-maker" then return end
  if global.selection[event.player_index] ~= nil then
    game.get_player(event.player_index).print({"error.ruin-maker-already-in-progress"})
    return
  end

  local area = util.expand_area_to_tile_border(event.area)
  local center = util.get_center_of_area(area)

  local renders = render_selection(area, center, event.surface)

  configure_selection(event.entities, event.tiles, area, center, event.player_index, renders)
end)

script.on_init(function()
  global.selection = {}
end)
