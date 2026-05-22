return require("lazy").setup({
    { "tpope/vim-sensible" },
    {
        "NLKNguyen/papercolor-theme",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme PaperColor")
        end
    },
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
                    follow_current_file = {
                        enabled = true,
                    },
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
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "ts_ls", "pyright", "lua_ls" },
                automatic_installation = true,
            })
        end,
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
        "stevearc/conform.nvim",
        opts = {},
    },
    { "mfussenegger/nvim-lint" },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "python", "javascript", "typescript", "json" },
                auto_install = true,
                ignore_install = {},
                sync_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                modules = {},
            })
        end,
    },
})
