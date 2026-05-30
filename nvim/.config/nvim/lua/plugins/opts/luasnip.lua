local luasnip = require('luasnip')

-- load snippets from friendly snippets
require('luasnip.loaders.from_vscode').lazy_load()

-- Load custom snippets
require('luasnip.loaders.from_lua').load({ paths = "~/.config/nvim/snippets/" })

-- Basic settings
luasnip.setup({
  history = true,
  updateevents = 'TextChanged,TextchangedI',
  delete_check_events = 'TextChanged',
  enable_autosnippets = true,
  store_selection_keys = '<Tab>',
})
