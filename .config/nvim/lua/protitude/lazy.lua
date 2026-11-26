local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
      vim.keymap.set("n", "<C-p>", builtin.git_files, {})
      vim.keymap.set("n", "<leader>ps", function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end)
      vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
    end,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({ disable_background = true })

      function ColorMyPencils(color)
        color = color or "rose-pine"
        vim.cmd.colorscheme(color)
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      end

      ColorMyPencils()
    end,
  },

  {
    "folke/trouble.nvim",
    opts = {},
    config = function(_, opts)
      require("trouble").setup(opts)
      vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>",
        { silent = true, noremap = true })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      -- Workaround for Neovim 0.12.1 async parse bug
      vim.g._ts_force_sync_parsing = true

      -- Workaround for Neovim 0.12.x bug: injection query processing in
      -- languagetree.lua can pass a nil node to vim.treesitter.get_range,
      -- which then errors with "attempt to call method 'range' (a nil value)".
      -- nvim-treesitter master is archived upstream, so the fix lives here
      -- until migration to `main`.
      local ts = vim.treesitter
      local orig_get_range = ts.get_range
      ts.get_range = function(node, source, metadata)
        if type(node) ~= "userdata" or type(node.range) ~= "function" then
          return { 0, 0, 0, 0, 0, 0 }
        end
        local ok, res = pcall(orig_get_range, node, source, metadata)
        if ok then
          return res
        end
        return { 0, 0, 0, 0, 0, 0 }
      end

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

  {
    -- Disabled: its async parse() triggers `node:range()` on a nil value in
    -- Neovim 0.12.x languagetree internals.
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = false,
      max_lines = 0,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
      zindex = 20,
    },
  },

  {
    "theprimeagen/harpoon",
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>a", mark.add_file)
      vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

      vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
      vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
      vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
      vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)
    end,
  },

  {
    "theprimeagen/refactoring.nvim",
    dependencies = { "lewis6991/async.nvim", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("refactoring").setup({})
      vim.keymap.set("v", "<leader>ri", function()
        require("refactoring").refactor("Inline Variable")
      end, { noremap = true, silent = true })
    end,
  },

  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
  },

  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

      local Protitude_Fugitive = vim.api.nvim_create_augroup("Protitude_Fugitive", {})
      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = Protitude_Fugitive,
        pattern = "*",
        callback = function()
          if vim.bo.ft ~= "fugitive" then
            return
          end

          local bufnr = vim.api.nvim_get_current_buf()
          local opts = { buffer = bufnr, remap = false }
          vim.keymap.set("n", "<leader>p", function()
            vim.cmd.Git("push")
          end, opts)

          -- rebase always
          vim.keymap.set("n", "<leader>P", function()
            vim.cmd.Git({ "pull", "--rebase" })
          end, opts)

          -- set the upstream branch when pushing a new branch
          vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
        end,
      })
    end,
  },

  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
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
    },
    config = function()
      local lsp_zero = require("lsp-zero")

      lsp_zero.set_sign_icons({
        error = "E",
        warn = "W",
        hint = "H",
        info = "I",
      })

      lsp_zero.on_attach(function(_, bufnr)
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
      end)

      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "rust_analyzer", "intelephense" },
        handlers = {
          lsp_zero.default_setup,
        },
      })

      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
          { name = "nvim_lua" },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
      })

      vim.diagnostic.config({ virtual_text = true })
    end,
  },

  {
    "folke/zen-mode.nvim",
    config = function()
      vim.keymap.set("n", "<leader>zz", function()
        require("zen-mode").setup({ window = { width = 90, options = {} } })
        require("zen-mode").toggle()
        vim.wo.wrap = false
        vim.wo.number = true
        vim.wo.rnu = true
        ColorMyPencils()
      end)

      vim.keymap.set("n", "<leader>zZ", function()
        require("zen-mode").setup({ window = { width = 80, options = {} } })
        require("zen-mode").toggle()
        vim.wo.wrap = false
        vim.wo.number = false
        vim.wo.rnu = false
        vim.opt.colorcolumn = "0"
        ColorMyPencils()
      end)
    end,
  },

  { "github/copilot.vim", version = "1.59.0" },

  "eandrju/cellular-automaton.nvim",

  {
    "laytan/cloak.nvim",
    opts = {
      enabled = true,
      cloak_character = "*",
      highlight_group = "Comment",
      patterns = {
        {
          file_pattern = { ".env*", "wrangler.toml", ".dev.vars" },
          cloak_pattern = "=.+",
        },
      },
    },
  },
})
