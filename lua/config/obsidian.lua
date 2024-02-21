require("obsidian").setup {
  -- Where to put new notes created from completion. Valid options are
  --  * "current_dir" - put new notes in same directory as the current buffer.
  --  * "notes_subdir" - put new notes in the default notes subdirectory.
  new_notes_location = "current_dir",
  completion = {
    -- If using nvim-cmp, otherwise set to false
    nvim_cmp = true,
    -- Trigger completion at 2 chars
    min_chars = 2,
  },
  disable_frontmatter = true,
  use_advanced_uri = true,
  open_app_foreground = true,
}
