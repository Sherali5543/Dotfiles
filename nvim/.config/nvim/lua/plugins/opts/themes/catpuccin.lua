require("catppuccin").setup({
  flavour = 'mocha',
  background = {
    light = 'latte',
    dark = 'mocha',
  },
  transparent_background = false,
  show_end_of_buffer== false,
  term_colors = false,
  dim_inactive = {
    enabled = true,
    shade = 'dark',
    percentage = 0.15,
  },
  custom_highlights = function(c)
    return {
      ["@variable.member"] = { fg = c.peach, style = {"italic"} },
    }
  end,
})
