-- TODO
-- LSPSaga の導入 Packerまではできている

vim.cmd [[
let g:python_host_prog='/Users/nop/.pyenv/versions/2.7.18/bin/python'
let g:python3_host_prog='/Users/nop/.pyenv/shims/python3'
]]


require("packer").startup(function(use)
	-- plugin manager
	use "wbthomason/packer.nvim"

	-- colorscheme
	use "sainnhe/sonokai"

	-- treesitter
	use "nvim-treesitter/nvim-treesitter"

	-- lsp config
	use "neovim/nvim-lspconfig"
	-- lsp manager
	use "williamboman/mason.nvim"
	use "williamboman/mason-lspconfig.nvim"

	-- complete
	use "hrsh7th/nvim-cmp"
	use "hrsh7th/cmp-nvim-lsp"
	use "hrsh7th/vim-vsnip"
	use "hrsh7th/cmp-path"
	use "hrsh7th/cmp-buffer"
	use "hrsh7th/cmp-cmdline"

	-- airline
	use 'vim-airline/vim-airline'

	-- vim-devicons
	use 'ryanoasis/vim-devicons'

	-- nerdtree
	use 'scrooloose/nerdtree'

	-- neoterm
	use 'kassio/neoterm'

	-- git command
	use 'tpope/vim-fugitive'
	use 'airblade/vim-gitgutter'

	-- gcc
	use 'tpope/vim-commentary'

	-- rust
	use 'rust-lang/rust.vim'

	-- lspUI
	use({
		"glepnir/lspsaga.nvim",
		branch = "main",
		config = function()
			require('lspsaga').setup({})
		end,
	})
end)

-- 行番号
vim.opt.number = true

-- カーソルライン
vim.opt.cursorline = true

-- indent
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- 検索結果をハイライト
vim.opt.showmatch = true
-- 検索の小文字大文字の区別
vim.opt.ignorecase = true
-- 検索のすばやい結果表示
vim.opt.incsearch = true

-- クリップボード
vim.opt.clipboard = 'unnamedplus'

--マウス
vim.opt.mouse = "a"

-- cmp
vim.opt.completeopt = { 'menuone', 'noinsert' }

local set = vim.keymap.set

-- Key Config
set('i', 'jj', '<ESC>')
set('n', 'gr', 'gT')
set('n', 'gw', '<C-w>w')

-- colorscheme
vim.cmd [[
let g:sonokai_style = 'andromeda'
colorscheme sonokai
]]

-- airline
vim.cmd [[
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'sonokai'
]]

-- vim-devicons

-- nerdtree
vim.cmd [[
let NERDTreeShowHidden = 1
nnoremap <silent><C-e> :NERDTreeToggle<CR>
]]

-- neoterm
set('t', '<ESC>', '<C-\\><C-n>')
set('t', '<C-t><C-t>', '<C-\\><C-n><C-w>:Ttoggle<CR>')
set('t', '<C-w>w', '<C-\\><C-n><C-w>w')
set('n', '<C-t><C-t>', ':Ttoggle<CR>')
set('n', '<C-w><C-t>', ':Ttoggle<CR>')

vim.cmd [[
let g:neoterm_default_mod = 'vertical belowright'
let g:neoterm_autoinsert = 1
]]

-- vim-fugitive
vim.cmd [[
let g:rustfmt_autosave = 1
]]

-- LSP
set('n', 'K', '<cmd>Lspsaga hover_doc<CR>')

set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')

set('n', 'gR', '<cmd>Lspsaga lsp_finder<CR>')

set('n', 'gd', '<cmd>Lspsaga goto_definition<CR>')

set('n', 'gD', '<cmd>Lspsaga peek_definition<CR>')

set('n', 'gn', '<cmd>Lspsaga rename<CR>')

set({ "n", "v" }, "ga", "<cmd>Lspsaga code_action<CR>")

set('n', '<space>e', '<cmd>Lspsaga show_line_diagnostics<CR>')

set('n', 'g]', '<cmd>Lspsaga diagnostic_jump_prev<CR>')

set('n', 'g[', '<cmd>Lspsaga diagnostic_jump_next<CR>')

-- mason
require('mason').setup()
require('mason-lspconfig').setup_handlers({ function(server)
	local opt = {
		-- -- Function executed when the LSP server startup
		-- on_attach = function(client, bufnr)
		--   local opts = { noremap=true, silent=true }
		--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
		--   vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'
		-- end,
		capabilities = require('cmp_nvim_lsp').default_capabilities(
			vim.lsp.protocol.make_client_capabilities()
		)
	}
	require('lspconfig')[server].setup(opt)

end })

-- LSP handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = false,
	signs = true,
	float = { border = "single" },
	underline = true,
}
)
-- vim.cmd([[au CursorHold * lua Lspsaga show_cursor_diagnostics]])

-- Reference highlight & diagnostic
vim.cmd [[
set updatetime=400
highlight LspReferenceText  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
highlight LspReferenceRead  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
highlight LspReferenceWrite cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
augroup lsp_document_highlight
autocmd!
autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
augroup END
]]

-- completion (hrsh7th/nvim-cmp)
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		-- { name = "buffer" },
		-- { name = "path" },
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		['<C-l>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm { select = true },
	}),
	experimental = {
		ghost_text = true,
	},
})
cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "path" },
		{ name = "cmdline" },
	},
})

-- treesitter
require 'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		disable = {
		}
	},
	indent = {
		enable = true,
	}
}
