local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = { "nvim-lua/plenary.nvim" } },
  { "rose-pine/neovim", name = "rose-pine" },
  { "folke/trouble.nvim" },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      -- Workaround for Neovim 0.12.1 async parse bug
      vim.g._ts_force_sync_parsing = true
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "vimdoc", "javascript", "typescript", "c", "lua", "php" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
          },
        },
      })
    end,
  },
  "theprimeagen/harpoon",
  { "theprimeagen/refactoring.nvim", dependencies = { "lewis6991/async.nvim", "nvim-treesitter/nvim-treesitter" } },
  "mbbill/undotree",
  "tpope/vim-fugitive",
  "nvim-treesitter/nvim-treesitter-context",
  {
    "VonHeikemen/lsp-zero.nvim", branch = "v3.x",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    }
  },
  "folke/zen-mode.nvim",
  "github/copilot.vim",
  "eandrju/cellular-automaton.nvim",
  "laytan/cloak.nvim",
})
