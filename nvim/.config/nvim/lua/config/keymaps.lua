local utils = require("config.keymap-utils")

utils.mapn('<leader>fm', vim.lsp.buf.format, { desc = 'Format buffer' })

-- Tab controls

