-- Completion keymaps (assuming nvim-cmp is loaded)
vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  else
    return "<Tab>"
  end
end, { expr = true, noremap = true })

vim.keymap.set("i", "<S-Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  else
    return "<S-Tab>"
  end
end, { expr = true, noremap = true })

-- Show diagnostics with <leader>e
vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })

local hardmode = true

if hardmode then
  local msg = [[<cmd>echohl Error | echo "KEY DISABLED" | echohl None<CR>]]

  vim.keymap.set('i', '<Up>', '<C-o>' .. msg, { noremap = true, silent = false })
  vim.keymap.set('i', '<Down>', '<C-o>' .. msg, { noremap = true, silent = false })
  vim.keymap.set('i', '<Left>', '<C-o>' .. msg, { noremap = true, silent = false })
  vim.keymap.set('i', '<Right>', '<C-o>' .. msg, { noremap = true, silent = false })

  vim.keymap.set('n', '<Up>', msg, { noremap = true, silent = false })
  vim.keymap.set('n', '<Down>', msg, { noremap = true, silent = false })
  vim.keymap.set('n', '<Left>', msg, { noremap = true, silent = false })
  vim.keymap.set('n', '<Right>', msg, { noremap = true, silent = false })
end
