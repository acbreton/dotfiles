local lspconfig = require("lspconfig")
local null_ls = require("null-ls")

-- Setup language servers
lspconfig.tsserver.setup({})
lspconfig.pyright.setup({})

-- Setup null-ls for linting & formatting
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.formatting.black,
  },
})

