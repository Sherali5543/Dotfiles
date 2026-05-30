local plugin_path = '/src/ArEditorPlugins/nvim/plugins/tac.nvim'

return {
    name = "tac",
    dir = plugin_path,
    opts = {},
    enabled = function()
        return vim.fn.isdirectory(plugin_path) ~= 0
    end,
}

