return {
	"mason-org/mason.nvim",
	opts = {},
	lazy = false,
	dependencies = {
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
	},
  config = function()
    require("plugins.opts.mason")
  end
}
