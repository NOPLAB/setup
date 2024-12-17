-- When error
-- :TSUpdate lua

-- TODO

-- vim.cmd [[
-- let g:python_host_prog='/Users/nop/.pyenv/versions/2.7.18/bin/python'
-- let g:python3_host_prog='/Users/nop/.pyenv/shims/python3'
-- ]]

-- WSL Settings
-- vim.cmd [[
-- let s:clip = '/mnt/c/Windows/System32/clip.exe'
-- if executable(s:clip)
--     augroup WSLYank
--         autocmd!
--         autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
--     augroup END
-- endif
-- ]]

-- setup Lazy
require("config.lazy")

vim.encoding = "UTF-8"

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
vim.opt.mouse = 'a'

-- cmp
vim.opt.completeopt = { 'menuone', 'noinsert' }

-- leader
vim.g.mapleader = " "

-- Key Config
local set = vim.keymap.set
set('i', 'jj', '<ESC>')
set('n', 'gr', 'gT')
set('n', 'gw', '<C-w>w')

-- lsp


-- Neotree
set('n', '<C-e>', ':Neotree<CR>')

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

vim.cmd [[
let g:neoterm_default_mod = 'vertical belowright'
let g:neoterm_autoinsert = 1
]]

-- LSP
-- set('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
-- set('n', 'gf', '<cmd>lua vim.lsp.buf.format()<CR>')
-- set('n', 'gR', '<cmd>Lspsaga lsp_finder<CR>')
-- set('n', 'gd', '<cmd>Lspsaga goto_definition<CR>')
-- set('n', 'gD', '<cmd>Lspsaga peek_definition<CR>')
-- set('n', 'gn', '<cmd>Lspsaga rename<CR>')
-- set({ 'n', 'v' }, 'ga', '<cmd>Lspsaga code_action<CR>')
-- set('n', '<space>e', '<cmd>Lspsaga show_line_diagnostics<CR>')
-- set('n', 'g]', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
-- set('n', 'g[', '<cmd>Lspsaga diagnostic_jump_next<CR>')

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
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = true,
		signs = true,
		float = { border = 'single' },
		underline = true,
	}
)

-- completion (hrsh7th/nvim-cmp)
local cmp = require('cmp')
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-l>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm { select = true },
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }, -- For vsnip users.
		-- { name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = 'buffer' },
	}),
	experimental = {
		ghost_text = true,
	},
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
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

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		local bufnr = ev.buf
		vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

		local bufopts = { buffer = bufnr }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
		vim.keymap.set('n', 'gwa', vim.lsp.buf.add_workspace_folder, bufopts)
		vim.keymap.set('n', 'gwr', vim.lsp.buf.remove_workspace_folder, bufopts)
		vim.keymap.set('n', 'gwl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, bufopts)
		vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
		vim.keymap.set('n', 'gn', vim.lsp.buf.rename, bufopts)
		vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, bufopts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
		vim.keymap.set('n', 'gf', function()
			vim.lsp.buf.format { async = true }
		end, bufopts)

		-- format on save
		-- vim.api.nvim_create_autocmd("BufWritePre", {
		-- 	-- 3
		-- 	buffer = bufnr,
		-- 	callback = function()
		-- 		-- 4 + 5
		-- 		vim.lsp.buf.format { async = false, id = ev.data.client_id }
		-- 	end,
		-- })
	end
})
