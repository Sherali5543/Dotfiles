return { 
	'kevinhwang91/nvim-ufo',
	dependencies = {
		'kevinhwang91/promise-async',
	},
  config = function()
    require("plugins.opts.ufo")
  end
}
