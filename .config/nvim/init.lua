local fn = vim.fn
local cmd = vim.cmd
local opt = vim.opt
local g = vim.g

local packer_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(packer_path)) > 0
then
  cmd('!git clone https://github.com/wbthomason/packer.nvim ' .. packer_path)
  cmd('packadd packer.nvim')
end

local packer = require('packer')
local use = packer.use
require('packer').startup(function()
  use 'wbthomason/packer.nvim' 
  use 'itchyny/lightline.vim'
  use 'lukas-reineke/indent-blankline.nvim'
end)

opt.hlsearch = false
opt.number = true
opt.mouse = 'a'
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.signcolumn = 'yes'
opt.completeopt = 'menuone,noselect'
opt.termguicolors = true
--cmd [[colorscheme onedark]]
--vim.g.lightline.colorscheme = 'onedark',

g.indent_blankline_char = '┊'
g.indent_blankline_filetype_exclude = { 'help', 'packer' }
g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
g.indent_blankline_show_trailing_blankline_indent = false

