script.on_event(defines.events.on_player_selected_area, function(event)
  if event.item ~= "ruin-maker" then return end
  local player = game.get_player(event.player_index)
  for _, entity in pairs(event.entities) do
    player.print(entity.name)
  end
  for _, tile in pairs(event.tiles) do
    player.print(tile.name)
  end
end)

script.on_event(defines.events.on_player_alt_selected_area, function(event)
  if event.item ~= "ruin-maker" then return end
  local player = game.get_player(event.player_index)
  for _, entity in pairs(event.entities) do
    player.print(entity.name)
  end
  for _, tile in pairs(event.tiles) do
    player.print(tile.name)
  end
end)
