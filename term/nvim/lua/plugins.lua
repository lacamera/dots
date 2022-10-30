local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

-- Automatically run PackerSync if plugins.lua changed
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

return require('packer').startup(function()
  -- Dont remove packer from this list otherwise
  -- the plugin manager will remove itself upon startup
  use 'wbthomason/packer.nvim'

  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  use 'neovim/nvim-lspconfig'
  use 'ray-x/lsp_signature.nvim'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/vim-vsnip'

  use 'morhetz/gruvbox'
  use 'nvim-treesitter/nvim-treesitter'
  use 'mfussenegger/nvim-jdtls'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- Automatically run PackerSync if packer has just been
  -- bootstrapped. This needs to be at the bottom.
  if ensure_packer() then require('packer').sync() end
end)
