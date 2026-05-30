return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
  lazy = false,
	config = function() 
    require("plugins.opts.themes.catpuccin")
  end
}
