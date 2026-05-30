vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
  virtual_text = {
    prefix = '●',
    spacing = 2,
    source = 'if_many', -- show source if multiple sources
    format = function(diagnostic)
      local win_width = vim.api.nvim_win_get_width(0)
      local padding = 10
      local max_width = win_width - padding

      local message = diagnostic.message:gsub("\n", " ")
      if #message > max_width then
        return message:sub(1, max_width - 3) .. "..."
      else
        return message
      end
    end,
    severity = { min = vim.diagnostic.severity.WARN }
  },
  underline = true,
  update_in_insert = true,
  severity_sort = true,

  -- floating window config
  float = {
    focusable = true,
    style = 'minimal',
    border = 'rounded',
    source = true,
    header = '',
    prefix = '',
    max_width = 80,
    max_height = 20,
  },
})
