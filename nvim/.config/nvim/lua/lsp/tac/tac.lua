-- run on container
-- a ws yum install ArTacLSP


local function ensure_parser(parser)
  local ok = pcall(vim.treesitter.language.add, parser)

  if ok then
    return
  end

  require("nvim-treesitter").install { parser }
end

local capabilities = nil
local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok then
  capabilities = cmp_lsp.default_capabilities()
else
  capabilities = vim.lsp.protocol.make_client_capabilities()
end


vim.lsp.config['artaclsp'] = {
  cmd = { "/usr/bin/artaclsp", "-I", "/bld/" },
  filetypes = { "tac" },
  root_markers = { ".git", "src" },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      require('nvim-navic').attach(client, bufnr)
    end
  end,
}

ensure_parser('cpp')

vim.lsp.enable('artaclsp')
