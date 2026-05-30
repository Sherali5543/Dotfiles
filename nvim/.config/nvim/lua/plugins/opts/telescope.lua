-- lua/config/telescope.lua
local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup({
  defaults = {
    layout_config = {
      horizontal = { width = 0.9 },
    },
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<C-q>"] = "send_to_qflist",
      },
    },
    file_ignore_patterns = { "node_modules", ".git/" },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
  extensions = {
    -- Add config for extensions here
  },
})

-- Load extensions (e.g., fzf)
pcall(telescope.load_extension, 'fzf')

-- Keybindings
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Buffers" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help Tags" })
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = "Recent Files" })
vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = "Git Commits" })
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = "Git Status" })

