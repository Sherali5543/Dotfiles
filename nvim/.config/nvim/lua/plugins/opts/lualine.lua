local disabled_files = {}
    
vim.o.laststatus = 3

local function file_breadcrumbs()
  local path = vim.fn.expand('%:.')
  if path == '' then return '[No Name]' end

  -- Get filetype icon
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  local icon, icon_color = '', nil
  if ok then
    local filename = vim.fn.expand('%:t')
    local extension = vim.fn.expand('%:e')
    icon, icon_color = devicons.get_icon_color(filename, extension, { default = true })
    icon = icon and (icon .. ' ') or ''
  end

  local parts = vim.split(path, '/', { plain = true })
  local result = {}

  -- Create temp highlight group for icon
  if icon_color then
    vim.api.nvim_set_hl(0, 'TempFileIcon', { fg = icon_color })
  end

  -- Create highlighted breadcrumbs
  for i, part in ipairs(parts) do
    if i == #parts then
      table.insert(result, '%#NavicText#' .. part .. '%*')
      -- Add icon if exists
      if icon ~= '' then
        result[#result] = '%#TempFileIcon#' .. icon .. '%*' .. result[#result]
      end
    else
      -- Highlight directories
      table.insert(result, '%#NavicIconsFile#' .. part .. '%*')
    end
  end
  return table.concat(result, '%#NavicSeperator#  %*')
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_seperators = { left = '', right = '' },
    section_seperators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = disabled_files,
      winbar = { 'NvimTree' },
      tabline = disabled_files
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = true,
    refresh = {
      statusline = 100,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'FileType',
        'ModeChanged',
      },
    },
  },

  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      'branch',
      {
        'diff',
        colored = true,
        symbols = {
          added = ' ',
          modified = '󰛿 ',
          removed = ' '
        }
      },
      'diagnostics'
    },
    lualine_c = {
      {
        'filename',
        file_status = true,
        symbols = {
          modified = '',
          readonly = '',
        }
      },
    },
    lualine_x = { 'encoding', 'fileformat', { 'filetype', icon = { align = 'right' } } },
    lualine_y = { 'searchcount', 'lsp_status', 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {
    lualine_a = {
      {
        'tabs',
        mode = 2,
        path = 0,
        use_mode_colors = true
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      'datetime'
    },
  },
  winbar = {
    lualine_c = {
      {
        -- file path breadcrumbs
        file_breadcrumbs,
      },
      {
        function()
          return require("nvim-navic").get_location()
        end,
        cond = function()
          return require('nvim-navic').is_available()
        end
      },
    },
  },
  inactive_winbar = {
    lualine_c = {
      file_breadcrumbs
    }
  },
  extensions = {}
}

