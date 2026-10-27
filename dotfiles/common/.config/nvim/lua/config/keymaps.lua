-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Fuzzy project picker in a tmux popup (requires nvim to run inside tmux).
-- Replaces normal-mode Ctrl+F (page forward); <C-d>/<C-u> still page.
vim.keymap.set("n", "<C-f>", function()
  if not vim.env.TMUX then
    vim.notify("tmux-sessionizer: nvim must be running inside tmux", vim.log.levels.WARN)
    return
  end

  vim.fn.system({
    "tmux",
    "display-popup",
    "-E",
    "-w",
    "80%",
    "-h",
    "70%",
    "-T",
    "Projects",
    vim.fn.expand("~/.local/bin/tmux-sessionizer"),
  })

  if vim.v.shell_error ~= 0 then
    vim.notify("tmux-sessionizer failed (exit " .. vim.v.shell_error .. ")", vim.log.levels.ERROR)
  end
end, { desc = "Project sessionizer" })

