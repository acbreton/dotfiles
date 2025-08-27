local lspconfig = require("lspconfig")
local none_ls = require("none-ls") -- migrated from null-ls

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

-- Setup none-ls (formerly null-ls)
none_ls.setup({
  sources = {
    none_ls.builtins.diagnostics.eslint,
    none_ls.builtins.formatting.prettier,
    none_ls.builtins.diagnostics.flake8,
    none_ls.builtins.formatting.black,
  },
})
