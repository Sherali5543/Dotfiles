local utils = require("config.keymap-utils")
local jump = function(opts)
  local params = vim.tbl_extend("force", { wrap = true }, opts)
  vim.diagnostic.jump(params)
end

-- LSP Diag nav
utils.mapn('[d', function() jump({ count = -1 }) end, { desc = 'Go to previous diagnostic' })
utils.mapn(']d', function() jump({ count = 1 }) end, { desc = 'Go to next diagnostic' })

-- Navigate by severity
utils.mapn('[e', function()
  jump({
    count = -1,
    severity = vim.diagnostic.severity.ERROR,
  })
end, { desc = 'Go to previous error' })

utils.mapn(']e', function()
  jump({
    count = 1,
    severity = vim.diagnostic.severity.ERROR,
  })
end, { desc = 'Go to next error' })

utils.mapn('[w', function()
  jump({
    count = -1,
    severity = vim.diagnostic.severity.WARN,
  })
end, { desc = 'Go to previous warning' })

utils.mapn(']w', function()
  jump({
    count = 1,
    severity = vim.diagnostic.severity.WARN,
  })
end, { desc = 'Go to next warning' })

-- show diagnostic in floating window
utils.mapn('<leader>d', vim.diagnostic.open_float, { desc = 'Show line diagnostics' })

-- show all diagnostics in quickfix
utils.mapn('<leader>q', vim.diagnostic.setqflist, { desc = 'Show all diagnostics in quickfix list' })

-- buf hover
utils.mapn('K', function()
  vim.lsp.buf.hover({
    border = 'rounded',
  })
end, { silent = true, desc = "Display lsp info on target under cursor" })
