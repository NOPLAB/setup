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

-- auto load
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})

-- key config
local set = vim.keymap.set
set('i', 'jj', '<ESC>')
set('n', 'gw', '<C-w>w')

-- colorscheme
vim.cmd [[
colorscheme kanagawa
]]

-- Neotree
set('n', '<C-e>', ':Neotree toggle<CR>')

-- airline
vim.cmd [[
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='minimalist'
]]

vim.cmd [[
let g:neoterm_default_mod = 'vertical belowright'
let g:neoterm_autoinsert = 1
]]

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

-- lsp
vim.lsp.enable(require('mason-lspconfig').get_installed_servers())
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})
