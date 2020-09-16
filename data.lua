data:extend
{
  {
    type = "selection-tool",
    name = "ruin-maker",
    icon = "__core__/graphics/empty.png",
    icon_size = 1,
    stack_size = 1,
    selection_color = {1, 1, 1},
    alt_selection_color = {r = 1},
    selection_mode = "blueprint",
    alt_selection_mode = {"any-tile", "any-entity"},
    selection_cursor_box_type = "entity",
    alt_selection_cursor_box_type = "train-visualization",
    flags = {"only-in-cursor"},
    always_include_tiles = true
  },
  {
    type = "shortcut",
    name = "give-ruin-maker",
    action = "create-blueprint-item",
    icon =
    {
      filename = "__core__/graphics/empty.png",
      size = 1
    },
    item_to_create = "ruin-maker"
  }
}
