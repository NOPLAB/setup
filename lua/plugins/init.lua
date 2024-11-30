return {
	-- colorscheme
	'sainnhe/sonokai',

	-- treesitter syntax hilight
	'nvim-treesitter/nvim-treesitter',

	-- lsp config
	'neovim/nvim-lspconfig',
	-- lsp manager
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',

	-- complete
	'hrsh7th/nvim-cmp',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/vim-vsnip',

	-- airline
	'vim-airline/vim-airline',

	-- vim-devicons
	'ryanoasis/vim-devicons',

	-- nerdtree
	'scrooloose/nerdtree',

	-- neoterm
	'kassio/neoterm',

	-- git
	'tpope/vim-fugitive',
	-- 'airblade/vim-gitgutter',\
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup()
		end
	},

	-- gcc gc
	'tpope/vim-commentary',

	-- rust
	-- 'rust-lang/rust.vim',

	-- lsp saga
	{
		'nvimdev/lspsaga.nvim',
		config = function()
			require('lspsaga').setup({})
		end,
		dependencies = {
			'nvim-treesitter/nvim-treesitter', -- optional
			'nvim-tree/nvim-web-devicons' -- optional
		}
	},

	{
		'stevearc/overseer.nvim',
		config = function()
			require('overseer').setup({
				templates = { "builtin" },
			})
		end
	},

	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("hlchunk").setup({})
		end
	},
}
