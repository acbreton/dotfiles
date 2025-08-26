-- Completion keymaps (assuming nvim-cmp is loaded)
vim.api.nvim_set_keymap("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, noremap = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true, noremap = true })

-- Show diagnostics with <leader>e
vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })

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
