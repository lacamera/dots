call plug#begin()
	Plug 'github/copilot.vim'

	Plug 'ciaranm/securemodelines'
	Plug 'yggdroot/indentline'
	Plug 'godlygeek/tabular'
	Plug 'editorconfig/editorconfig-vim'
	Plug 'justinmk/vim-sneak'
	Plug 'ervandew/supertab'
	Plug 'junegunn/fzf', { 'dir': '~/.local/share/fzf', 'do': './install --all' }
	Plug 'junegunn/fzf.vim'
	Plug 'itchyny/lightline.vim'
	Plug 'mengelbrecht/lightline-bufferline'

	Plug 'base16-project/base16-vim'
	Plug 'mike-hearn/base16-vim-lightline'

	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/lsp_extensions.nvim'
	Plug 'ray-x/lsp_signature.nvim'

	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-vsnip'
	Plug 'hrsh7th/vim-vsnip'

	Plug 'rust-lang/rust.vim'
	Plug 'fatih/vim-go'
	Plug 'neovimhaskell/haskell-vim'
	Plug 'vim-perl/vim-perl'
	Plug 'plasticboy/vim-markdown'
	Plug 'lervag/vimtex'
	Plug 'elzr/vim-json'
	Plug 'cespare/vim-toml'
	Plug 'stephpy/vim-yaml'
	Plug 'ninjin/vim-openbsd'
call plug#end()

"set t_Co=256
let base16colorspace=256
set termguicolors
colorscheme base16-classic-dark

let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_python_provider = 0
let g:loaded_node_provider = 0

lua << END
local cmp = require'cmp'
local lspconfig = require'lspconfig'

cmp.setup({
  experimental = {ghost_text = true},
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  sources = cmp.config.sources({
	{name='nvim_lsp'}, {name='vsnip'}}, 
	{{name='buffer'}, {name='path'}}
  )
})

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  -- get signatures (and _only_ signatures) when in argument lists
  require "lsp_signature".on_attach({
    doc_lines = 0,
    handler_opts = { border = "none" }
  })
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.gopls.setup{}
lspconfig.pylsp.setup{}

-- git clone https://github.com/haskell/haskell-language-server
-- cd haskell-language-server && cabal install
-- lspconfig.hls.setup{}

lspconfig.clangd.setup { cmd={ "clangd", "--background-index" } }

lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      completion = { postfix = { enable = false } },
    },
  },
  capabilities = capabilities
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)
END

let g:secure_modelines_allowed_items = [
      \ "textwidth",   "tw",
      \ "softtabstop", "sts",
      \ "tabstop",     "ts",
      \ "shiftwidth",  "sw",
      \ "expandtab",   "et",   "noexpandtab", "noet",
      \ "filetype",    "ft",
      \ "foldmethod",  "fdm",
      \ "readonly",    "ro",   "noreadonly", "noro",
      \ "rightleft",   "rl",   "norightleft", "norl",
      \ "colorcolumn"
      \ ]

let g:lightline = {
	  \ 'colorscheme': 'base16_classic_dark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileencoding', 'filetype' ] ],
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ['close'] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename'
      \ }
      \ }

function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

set completeopt=menuone,noinsert,noselect
set cmdheight=1
set clipboard+=unnamedplus
set scrolloff=2

set nofoldenable
set noshowmode
set nowrap
set nojoinspaces
set noexpandtab

set signcolumn=yes
set secure
set splitright
set splitbelow
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor
set shiftwidth=4
set softtabstop=4
set tabstop=4
set gdefault
set vb t_vb=
set synmaxcol=500
set laststatus=2
set relativenumber
set number
set mouse=a
set shortmess+=c

set diffopt+=iwhite
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic

"set listchars=nbsp:¬,eol:¶,extends:»,precedes:«,trail:•

let mapleader = "\<Space>"

noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" ,p will paste clipboard into buffer
noremap <leader>p :read !xsel --clipboard --output<cr>
" ,c will copy entire buffer into clipboard
noremap <leader>c :w !xsel -ib<cr><cr>
" open new file adjacent to current file
nnoremap <leader>o :e <C-R>=expand("%:p:h") . "/" <CR>
" left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>
" toggle between buffers
nnoremap <leader><leader> <c-^>
" toggle hidden chars
nnoremap <leader>, :set invlist<cr>

autocmd InsertLeave * set nopaste
autocmd BufRead *.md set filetype=markdown
autocmd BufRead *.tex set filetype=tex
autocmd BufRead *.h set filetype=c

" jump to last edit position on opening file
if has("autocmd")
  " https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

