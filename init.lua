-- ===============================
-- Leader key
-- ===============================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ===============================
-- Basic settings
-- ===============================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true

-- ===============================
-- Bootstrap lazy.nvim
-- ===============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ===============================
-- Lazy.nvim setup
-- ===============================
require("lazy").setup({
  performance = {
    rtp = {
      reset = false,
    },
  },

  spec = {

    -- LSP
    {
      "VonHeikemen/lsp-zero.nvim",
      branch = "v3.x",
      dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
      },
    },

    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "lua", "javascript", "typescript", "python",
            "go", "rust", "dockerfile", "yaml", "html", "css", "tsx",
          },
          highlight = { enable = true },
          indent = { enable = true },
        })
      end,
    },

    -- Autotag
    {
      "windwp/nvim-ts-autotag",
      event = { "BufReadPost", "BufNewFile" },
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("nvim-ts-autotag").setup({})
      end,
    },

    -- Telescope
    { 
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      cmd = "Telescope",
    },

    -- File explorer
    { 
      "stevearc/oil.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Git UI
    { 
      "kdheepak/lazygit.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      cmd = "LazyGit",
    },

    -- Terminal
    { 
      "akinsho/toggleterm.nvim",
      version = "*",
      cmd = "ToggleTerm",
    },

    -- UI
    "nvim-tree/nvim-web-devicons",
    "nvim-lualine/lualine.nvim",
    "shaunsingh/nord.nvim",

    -- Dashboard
    {
      "nvimdev/dashboard-nvim",
      event = "VimEnter",
    },

    -- QoL
    "folke/which-key.nvim",
    "numToStr/Comment.nvim",
    "windwp/nvim-autopairs",
  },
})

-- ===============================
-- Theme
-- ===============================
vim.cmd.colorscheme("nord")

-- ===============================
-- Lualine
-- ===============================
require("lualine").setup({
  options = { theme = "nord" },
})

-- ===============================
-- Oil.nvim
-- ===============================
require("oil").setup({ view_options = { show_hidden = true } })
vim.keymap.set("n", "<leader>e", require("oil").open, { desc = "File explorer" })

-- ===============================
-- Telescope (simplified)
-- ===============================
local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    file_ignore_patterns = { 
      "node_modules",
      ".git",
      "dist",
      "build",
      "migrations",
    },
  },
})

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })

-- ===============================
-- ToggleTerm
-- ===============================
require("toggleterm").setup({
  open_mapping = [[<leader>tt]],
  direction = "float",
})

-- ===============================
-- Git
-- ===============================
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit" })

-- ===============================
-- Dashboard
-- ===============================
require("dashboard").setup({
  theme = "doom",
  config = {
    header = {
      "",
      "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
      "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
      "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
      "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
      "",
    },
    center = {
      { desc = "Find File", key = "f", action = "Telescope find_files" },
      { desc = "Recent Files", key = "r", action = "Telescope oldfiles" },
      { desc = "File Explorer", key = "e", action = "lua require('oil').open()" },
      { desc = "LazyGit", key = "g", action = "LazyGit" },
      { desc = "Terminal", key = "t", action = "ToggleTerm" },
      { desc = "Quit", key = "q", action = "qa" },
    },
  },
})

-- ===============================
-- LSP
-- ===============================
local lsp = require("lsp-zero")
lsp.preset("recommended")

lsp.on_attach(function(_, bufnr)
  local o = { buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, o)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, o)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, o)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, o)
end)

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "ts_ls",
    "pyright",
    "rust_analyzer",
    "dockerls",
    "yamlls",
  },
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup({})
    end,
  },
})

lsp.setup()

-- ===============================
-- Completion
-- ===============================
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = { { name = "nvim_lsp" } },
})

-- ===============================
-- QoL
-- ===============================
require("Comment").setup()
require("which-key").setup()
require("nvim-autopairs").setup({})