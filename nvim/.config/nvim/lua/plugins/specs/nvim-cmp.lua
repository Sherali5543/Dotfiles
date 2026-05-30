return {
	'hrsh7th/nvim-cmp',
	event = 'InsertEnter',
	dependencies = {
		-- LSP Completion support
		'hrsh7th/cmp-nvim-lsp',

		-- Other completion sources
		'hrsh7th/cmp-buffer',	-- Buffer completions
		'hrsh7th/cmp-path', 	-- Path completions
		'hrsh7th/cmp-cmdline',	-- Command line completions

		-- Snippet engine
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',	-- Snippet completions

		-- Snippet collection
		'rafamadriz/friendly-snippets',
	},
  config = function()
    require("plugins.opts.nvim-cmp")
  end
}
