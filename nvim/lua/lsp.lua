local lspconfig = require("lspconfig")
local null_ls = require("null-ls")

-- Setup other language servers
lspconfig.ts_ls.setup({})
lspconfig.pyright.setup({})

-- Setup Lua language server with Neovim-specific config
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- Setup null-ls
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.formatting.black,
  },
})

