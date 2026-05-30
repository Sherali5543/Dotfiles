local M = {}

M.map = vim.keymap.set

M.mapn = function(lhs, rhs, opts)
	vim.keymap.set('n', lhs, rhs, opts)
end

return M
