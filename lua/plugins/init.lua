return {
	-- colorscheme
	'sainnhe/sonokai',

	-- treesitter シンタックスハイライト
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

	-- git command
	'tpope/vim-fugitive',
	'airblade/vim-gitgutter',

	-- gcc
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
	}
}
