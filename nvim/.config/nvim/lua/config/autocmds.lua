-- Search highlights
local search_group = vim.api.nvim_create_augroup("SearchHighlight", { clear=true })
local search_timer = nil

-- Clear when leaving search cmd line
vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = search_group,
  pattern = { "/", "?" },
  callback = function()
    vim.schedule(function()
      vim.cmd("nohlsearch")
    end)
  end,
})

-- Clear when starting to type
vim.api.nvim_create_autocmd("InsertEnter", {
  group = search_group,
  callback = function()
    vim.schedule(function()
      vim.cmd("nohlsearch")
    end)
  end,
})

-- Clear after delay when cursor moves
