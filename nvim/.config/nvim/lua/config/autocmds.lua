-- Search highlights
local search_group = vim.api.nvim_create_augroup("SearchHighlight", { clear = true })
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

-- Install parser when opening file
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype

    if pcall(vim.treesitter.language.add, ft) then
      return
    end

    vim.schedule(function()
      vim.notify("Installing parser for: " .. ft, vim.log.levels.DEBUG)
      require("nvim-treesitter").install({ ft })
    end)
  end,
})

-- local events = {
--   "BufNewFile", "BufReadPre", "BufReadPost", "BufWritePre", "BufWritePost",
--   "BufEnter", "BufLeave", "BufWinEnter", "BufWinLeave", "CmdlineEnter",
--   "CmdlineLeave", "CursorMoved", "CursorMovedI", "InsertEnter", "InsertLeave",
--   "TextChanged", "TextChangedI", "WinEnter", "WinLeave", "VimEnter"
-- }
-- local trace_group = vim.api.nvim_create_augroup("EventTracer", { clear = true })
--
-- vim.api.nvim_create_autocmd(events, {
--   group = trace_group,
--   pattern = "*",
--   callback = function(args)
--     -- Print to the message history with a timestamp
--     print(string.format("[%s] Event Fired: %s (Buffer: %d)", os.date("%H:%M:%S"), args.event, args.buf))
--   end,
-- })
-- Create a unique execution group to prevent duplicate event loops
local ts_group = vim.api.nvim_create_augroup("GlobalTreesitter", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = ts_group,
  pattern = "*", -- Matches EVERY filetype detected by Neovim
  desc = "Automatically activate Tree-sitter highlighting everywhere",
  callback = function()
    -- pcall safely catches errors if a parser library isn't downloaded yet
    pcall(vim.treesitter.start)
  end,
})

