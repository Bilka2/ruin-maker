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
  output_selection(data.entities, data.tiles, data.tile_filter, data.center, name, player_index)
  discard_selection(player_index)
end

script.on_event(defines.events.on_gui_click, function(event)
  if event.element.name == "ruin-maker-confirm" then
    confirm_selection(event.player_index, event.element.parent["ruin-maker-name"].text)
    event.element.parent.destroy()
  elseif event.element.name == "ruin-maker-cancel" then
    discard_selection(event.player_index)
    event.element.parent.destroy()
  end
end)

script.on_event(defines.events.on_gui_checked_state_changed, function(event)
  if event.element.parent and event.element.parent.name == "ruin-maker-config" then
    global.selection[event.player_index].tile_filter[event.element.name] = false
  end
end)

script.on_event(defines.events.on_gui_confirmed, function(event)
  if event.element.name == "ruin-maker-name" then
    confirm_selection(event.player_index, event.element.text)
    event.element.parent.destroy()
  end
end)

local function config_gui(player, tile_names)
  local gui = player.gui.screen.add{type = "frame", name = "ruin-maker-config", caption = {"gui.ruin-maker-config"}, direction = "vertical"}
  gui.force_auto_center()

  gui.add{type = "label", caption = {"gui.ruin-maker-name"}}
  local name = gui.add{type = "textfield", name = "ruin-maker-name", text = "unknown", clear_and_focus_on_right_click = true}
  name.focus()

  gui.add{type = "label", caption = {"gui.ruin-maker-tile-filter"}}
  for tile_name in pairs(tile_names) do
    gui.add{type = "checkbox", name = tile_name, caption = tile_name, state = true}
  end

  gui.add{type = "button", name = "ruin-maker-confirm", caption = {"gui.ruin-maker-confirm"}}
  gui.add{type = "button", name = "ruin-maker-cancel", caption = {"gui.ruin-maker-cancel"}}
end

local function configure_selection(entities, tiles, center, player_index, renders)
  local tile_names = {}
  for _, tile in pairs(tiles) do
    tile_names[tile.name] = true
  end

  config_gui(game.get_player(player_index), tile_names)

  global.selection[player_index] = {
    entities = entities,
    tiles = tiles,
    tile_filter = tile_names,
    center = center,
    renders = renders
  }
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

  configure_selection(event.entities, event.tiles, center, event.player_index, renders)
end)

script.on_init(function()
  global.selection = {}
end)
