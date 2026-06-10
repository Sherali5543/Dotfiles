require('nvim-treesitter').setup{}
require('nvim-treesitter').install {
  'lua', 'vim', 'vimdoc', 'query',
  'cpp', 'python',
  'yaml', 'markdown', 'markdown_inline', 'json'
}

require('nvim-treesitter-textobjects').setup {
  select = {
    lookahead = true,
  }
}

vim.keymap.set({'x', 'o'}, 'af', function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({'x', 'o'}, 'if', function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({'x', 'o'}, 'ac', function()
  require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({'x', 'o'}, 'ic', function()
  require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
end)
