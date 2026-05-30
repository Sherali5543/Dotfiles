return {
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	lazy = false,
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
  config = function()
    require("plugins.opts.tree-sitter")
  end
}
