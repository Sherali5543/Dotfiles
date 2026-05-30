-- Config servers using new vim.lsp.config
local servers = {
  'lua_ls',
  'clangd',
  'jedi_language_server',
  'artaclsp',
  'qmljs',
  'neocmake'
}

require('mason-lspconfig').setup({
  ensure_installed = servers,
  automatic_installation = true,
})

local lsp_to_parser = {
  lua_ls = 'lua',
  clangd = 'cpp',
  jedi_language_server = 'python',
  artaclsp = 'tac',
  qmlls = 'qmljs',
  cmake = 'neocmake',
}

local function is_parser_installed(parser)
  local ok, parsers = pcall(require, 'nvim-treesitter.parsers')
  if not ok then return false end
  return parsers.has_parser(parser)
end

-- get completion capabilities
local capabilities = nil
local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok then
  capabilities = cmp_lsp.default_capabilities()
else
  capabilities = vim.lsp.protocol.make_client_capabilities()
end

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

for _, server in ipairs(servers) do
  vim.lsp.config[server] = {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      if client.server_capabilities.documentSymbolProvider then
        require('nvim-navic').attach(client, bufnr)
      end
    end,
  }

  -- auto install ts parser
  local parser = lsp_to_parser[server]
  if parser and not is_parser_installed(parser) then
    vim.schedule(function()
      vim.cmd("TSInstall " .. parser)
    end)
  end
end
