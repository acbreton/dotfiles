return require("lazy").setup({
  { "tpope/vim-sensible" },
  { "morhetz/gruvbox", priority = 1000, lazy = false, config = function() vim.cmd("colorscheme gruvbox") end },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = true,
          hijack_netrw_behavior = "open_default",
          filtered_items = { visible = false },
        },
        window = {
          mappings = {
            ["<space>"] = "none",
            ["o"] = "open",
            ["<cr>"] = "open",
            ["h"] = "close_node",
            ["l"] = "open",
          },
        },
      })
      vim.keymap.set("n", "<leader>n", ":Neotree toggle<CR>", { noremap = true, silent = true })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup()
      vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true })
      vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true })
      vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true })
      vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { noremap = true })
    end,
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  },
  { "L3MON4D3/LuaSnip" },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "typescript", "json" }, -- languages you want
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },
})

