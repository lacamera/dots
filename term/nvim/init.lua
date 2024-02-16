-- Designed for Neovim 0.9+
--
-- Run `:Copilot auth` if you wish to use copilot completions

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true

vim.opt.updatetime = 50
vim.opt.wrap = false

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
  { "rrethy/nvim-base16" },
  { "ellisonleao/gruvbox.nvim" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
  },
  { "zbirenbaum/copilot.lua" },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      { "neovim/nvim-lspconfig" }, -- Required
      { "L3MON4D3/LuaSnip" },      -- Required
      { "hrsh7th/nvim-cmp" },      -- Required
      { "hrsh7th/cmp-nvim-lsp" },  -- Required

      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "laytan/cloak.nvim" },

      {
        "williamboman/mason.nvim",
        build = pcall(function() vim.cmd [[MasonUpdate]] end)
      },
      { "williamboman/mason-lspconfig.nvim" },
      { "folke/trouble.nvim" }
    }
  }
})

-- Theming

require("trouble").setup({
  -- no patched font or icons
  icons = false,
  fold_open = "v",
  fold_closed = ">",
  indent_lines = false,
  signs = {
    error = "err",
    warning = "warn",
    hint = "hint",
    information = "info"
  },
  use_diagnostic_signs = false
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "vimdoc" },
  auto_install = true,
  -- norg fails to compile without GNU make
  ignore_install = { "norg" },
  highlight = { enable = true }
})

-- LSP
-- TODO
local fqbn = "arduino:esp32:nano_nora"
local lsp = require("lsp-zero").preset({})
local cmp = require("cmp")
lsp.on_attach(function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
  --lsp.buffer_autoformat()
end)
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = { "gopls", "clangd", "lua_ls", "tsserver", "arduino_language_server" },
  handlers = {
    lsp.default_setup,
    lua_ls = function()
      require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
    end,
    arduino_language_server = function()
      require("lspconfig").arduino_language_server.setup {
        cmd = {
          "arduino-language-server",
          "-cli-config", "/Users/fm/.config/arduino-cli.yaml",
          "-fqbn", fqbn
        },
        on_attach = lsp.on_attach,
      }
    end,
  }
})

require("lsp-zero").extend_cmp()
require("copilot").setup({
  suggestion = { enabled = true },
  panel = { enabled = false },
})

cmp.setup({
  sources = {
    { name = "path",     max_item_count = 2 },
    { name = "copilot",  max_item_count = 1 },
    { name = "nvim_lsp", max_item_count = 5 },
    { name = "nvim_lua" },
    { name = "buffer",   max_item_count = 1 },
    { name = "cmdline",  max_item_count = 2 }
  },
  mapping = {
    ["<CR>"] = cmp.mapping.confirm({
      -- documentation says this is important
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    })
  },
})

require('cloak').setup({
  enabled = true,
  cloak_character = '*',
  -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
  highlight_group = 'Comment',
  -- Applies the length of the replacement characters for all matched
  -- patterns, defaults to the length of the matched pattern.
  cloak_length = nil, -- Provide a number if you want to hide the true length of the value.
  -- Whether it should try every pattern to find the best fit or stop after the first.
  try_all_patterns = true,
  patterns = {
    {
      -- Match any file starting with '.env'.
      -- This can be a table to match multiple file patterns.
      file_pattern = '.env*',
      -- Match an equals sign and any character after it.
      -- This can also be a table of patterns to cloak,
      -- example: cloak_pattern = { ':.+', '-.+' } for yaml files.
      cloak_pattern = '=.+',
      -- A function, table or string to generate the replacement.
      -- The actual replacement will contain the 'cloak_character'
      -- where it doesn't cover the original text.
      -- If left empty the legacy behavior of keeping the first character is retained.
      replace = nil,
    },
  },
})


vim.diagnostic.config({
  --update_in_insert = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Neovim will try to use a matching background color by default
--vim.opt.background = "dark"
require("gruvbox").setup({ contrast = "hard" })
vim.cmd([[colorscheme gruvbox]])
