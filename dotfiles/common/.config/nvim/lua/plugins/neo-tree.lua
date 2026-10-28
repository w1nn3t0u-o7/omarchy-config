-- Neo-tree: close the tree after opening a file and show dotfiles by default.
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        -- Keep the repo metadata out of the tree; press H to toggle
        -- gitignored/ignored items.
        never_show = { ".git" },
      },
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function()
          require("neo-tree.command").execute({ action = "close" })
        end,
      },
    },
  },
}
