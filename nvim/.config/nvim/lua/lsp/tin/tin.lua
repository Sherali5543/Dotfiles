-- for arista
vim.filetype.add({
  extension = {
    tin = 'tin',
    itin = 'itin',
  }
})

local base = vim.lsp.config.clangd or {}

base.init_options = vim.tbl_deep_extend(
  "force",
  base.init_options or {},
  { compilationDatabasePath = "/src" }
)

base.filetypes = vim.list_extend(
  base.filetypes or {},
  { "tin", "itin" }
)

base.root_markers = vim.list_extend(
  base.root_markers or {},
  { "src", ".git" }
)

vim.lsp.clangd.config = base

vim.lsp.enable('clangd')
