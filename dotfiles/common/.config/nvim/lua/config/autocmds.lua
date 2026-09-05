-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  desc = "Deletes empty buffer right after loading snacks.nvim file picker on startup",
  callback = function(event)
    if event.data == "snacks.nvim" then
      vim.schedule(function()
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          local n = vim.api.nvim_buf_get_name(b)
          if n == "" and vim.bo[b].buftype == "" and not vim.bo[b].modified then
            pcall(vim.api.nvim_buf_delete, b, { force = true })
          end
        end
      end)
    end
  end,
})
