return {
	-- colorscheme
	'rebelot/kanagawa.nvim',

	-- treesitter syntax hilight
	'nvim-treesitter/nvim-treesitter',

	-- lsp manager
	{
	    "williamboman/mason.nvim",
	    build = ":MasonUpdate",
	    opts = {},
	},
	{
	    "williamboman/mason-lspconfig.nvim",
	    dependencies = {
	        { "williamboman/mason.nvim" },
	        { "neovim/nvim-lspconfig" },
	        { "echasnovski/mini.completion", version = false },
	    },
	    keys={
		{ "<C-space>", "<cmd>lua vim.lsp.completion.get()  <CR>", mode = "i" },
		{ "gh",        "<cmd>lua vim.lsp.buf.hover()       <CR>" },
		{ "gd",        "<cmd>lua vim.lsp.buf.definition()  <CR>" },
		{ "gD",        "<cmd>lua vim.lsp.buf.declaration() <CR>" },
	    },
	},
	

	-- complete
	'hrsh7th/nvim-cmp',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/vim-vsnip',

	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	-- airline
	'vim-airline/vim-airline',
	'vim-airline/vim-airline-themes',

	-- vim-devicons
	'ryanoasis/vim-devicons',

	-- explorer
	-- 'scrooloose/nerdtree',
	{
		'nvim-neo-tree/neo-tree.nvim',
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		}
	},

	-- terminal
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		config = function()
			require("toggleterm").setup {
				size = 100,
				open_mapping = [[<c-t>]],
				hide_numbers = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = 'tab',
				close_on_exit = true,
			}

			vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
			vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
			vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
			vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
			vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
			vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
			vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)

			vim.keymap.set('n', 'tt', [[<Cmd>ToggleTerm]], opts)
			vim.keymap.set('n', 'tv', [[<Cmd>ToggleTerm direction=vertical<CR>]], opts)
			vim.keymap.set('n', 'th', [[<Cmd>ToggleTerm direction=horizontal<CR>]], opts)
		end
	},


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

	-- OverseerRun
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


	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' }
	}
}
