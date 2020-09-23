data:extend
{
  {
    type = "selection-tool",
    name = "ruin-maker",
    icon = "__ruin-maker__/graphics/ruin-maker.png",
    icon_size = 64,
    stack_size = 1,
    selection_color = {1, 1, 1},
    alt_selection_color = {r = 1},
    selection_mode = "blueprint",
    alt_selection_mode = {"any-tile", "any-entity"},
    selection_cursor_box_type = "entity",
    alt_selection_cursor_box_type = "train-visualization",
    always_include_tiles = true
  },
  {
    type = "shortcut",
    name = "give-ruin-maker",
    action = "create-blueprint-item",
    icon =
    {
      filename = "__ruin-maker__/graphics/ruin-maker-shortcut.png",
      size = 32
    },
    item_to_create = "ruin-maker",
    style = "blue"
  }
}
