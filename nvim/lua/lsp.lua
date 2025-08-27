local lspconfig = require("lspconfig")

-- Setup other language servers
lspconfig.tsserver.setup({})
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

-- Setup conform.nvim for formatting
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    -- add more filetypes/formatters as needed
  },
  -- Optionally auto-format on save:
  format_on_save = {
    -- These options will format the buffer using conform.nvim when saving
    lsp_fallback = true,
    timeout_ms = 500,
  },
})

-- Setup nvim-lint for diagnostics/linting
require("lint").linters_by_ft = {
  python = { "flake8" },
  javascript = { "eslint" },
  typescript = { "eslint" },
  -- add more filetypes/linters as needed
}

-- Optionally, auto-lint on save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
