-- Bootstrap lazy.nvim (same as before)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local hardmode = true

if hardmode then
  local msg = [[<cmd>echohl Error | echo "KEY DISABLED" | echohl None<CR>]]

  vim.api.nvim_set_keymap('i', '<Up>', '<C-o>' .. msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap('i', '<Down>', '<C-o>' .. msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap('i', '<Left>', '<C-o>' .. msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap('i', '<Right>', '<C-o>' .. msg, { noremap = true, silent = false })

  vim.api.nvim_set_keymap('n', '<Up>', msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap('n', '<Down>', msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap('n', '<Left>', msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap('n', '<Right>', msg, { noremap = true, silent = false })
end

-- Load config modules
require("settings")
require("keymaps")
require("plugins")
require("lsp")


