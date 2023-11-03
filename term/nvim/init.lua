-- Designed for Neovim 0.9+
--
-- Run `:Copilot auth` if you wish to use copilot completions

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Auto-install lazy.nvim if not present
local lazy = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy) then
  print("[init.lua] installing lazy.nvim")
  vim.fn.system({
    "git",
    "clone",
    "--branch=stable",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazy,
  })
  print("[init.lua] lazy.nvim was successfully installed")
end
vim.opt.rtp:prepend(lazy)

require("lazy").setup({
  {"rrethy/nvim-base16"},
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
  },
  {"zbirenbaum/copilot.lua"},
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "dev-v3",
    dependencies = {
      { "neovim/nvim-lspconfig" }, -- Required
      { "L3MON4D3/LuaSnip" },      -- Required
      { "hrsh7th/nvim-cmp" },      -- Required
      { "hrsh7th/cmp-nvim-lsp" },  -- Required

      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      {
        "williamboman/mason.nvim",
        build = pcall(function() vim.cmd [[MasonUpdate]] end)
      },
      { "williamboman/mason-lspconfig.nvim" },
    }
  }
})

-- Theming
vim.cmd.colorscheme("base16-gruvbox-dark-hard")
--vim.cmd.colorscheme("base16-gruvbox-light-soft")

-- Treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = {"lua", "vimdoc"},
  auto_install = true,
  -- norg fails to compile without GNU make
  ignore_install = {"norg"},
  highlight = {enable = true}
})

-- LSP
local lsp = require("lsp-zero").preset({})
local cmp = require("cmp")
lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({buffer = bufnr})
  --lsp.buffer_autoformat()
end)
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = {"gopls", "clangd", "lua_ls", "tsserver"},
  handlers = {
    lsp.default_setup,
    lua_ls = function()
      require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
    end,
  }
})
require("lsp-zero").extend_cmp()
require("copilot").setup({
  suggestion = {enabled = false},
  panel = {enabled = false},
})
cmp.setup({
  sources = {
    {name = "path"},
    {name = "copilot"},
    {name = "nvim_lsp"},
    {name = "nvim_lua"},
  },
  mapping = {
    ["<CR>"] = cmp.mapping.confirm({
      -- documentation says this is important
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    })
  },
})
