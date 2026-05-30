local utils = require('config.keymap-utils')

require('nvim-tree').setup({
  sort_by = 'case_sensitive',
  view = {
    width = 35,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles= true
  },
})

utils.mapn('<leader>[', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle NvimTree file explorer' })
