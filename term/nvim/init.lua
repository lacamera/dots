require('plugins')
require('lsp')

vim.api.nvim_command [[colorscheme gruvbox]]
vim.g.gruvbox_contrast_dark = "hard"

require('lualine').setup {
  options = {
    theme = "powerline",
    component_separators = '',
    section_separators = '',
  },
}

local ts  = 2       -- n-spaces per tab
local tui = true    -- enable mouse/clip and GUI colors
local vo  = vim.opt

vo.tabstop        = ts
vo.softtabstop    = ts
vo.shiftwidth     = ts
vo.expandtab      = true
vo.autoindent     = true
vo.smartindent    = true
vo.relativenumber = true
vo.number         = true
vo.foldenable     = false
vo.laststatus     = 3
vo.cmdheight      = 0 -- experimental

-- Keep cursor in the middle of the screen while scrolling
vo.scrolloff      = 999
vo.termguicolors  = true
vo.mouse          = "a"
vo.clipboard      = "unnamedplus"

vo.secure         = true
