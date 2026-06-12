-- DEPRECATED KEPT AS REFERENCE
-- Config servers using new vim.lsp.config
local servers = {
  lua_ls = "lsp.lua.lua",
  clangd = "lsp.cpp.cpp",
  jedi_language_server = 'lsp.python.python',
  -- 'artaclsp',
  qmlls = 'lsp.qml.qml',
  neocmake = 'lsp.cmake.cmake'
}

local lsp_to_parser = {
  lua_ls = 'lua',
  clangd = 'cpp',
  jedi_language_server = 'python',
  -- artaclsp = 'tac',
  qmlls = 'qmljs',
  neocmake = 'cmake',
}

-- Extract servers for mason
local mason_ensure_installed = {}
for server_name, _ in pairs(servers) do
  table.insert(mason_ensure_installed, server_name)
end

require('mason-lspconfig').setup({
  ensure_installed = mason_ensure_installed,
  automatic_installation = true,
  -- automatic_enable = false,
})

local function ensure_parser(parser)
  local ok = pcall(vim.treesitter.language.add, parser)

  if ok then
    return
  end

  require("nvim-treesitter").install({ parser })
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

-- Setup navic breadcrumbs
local function base_on_attach(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    local has_navic, navic = pcall(require, 'nvim-navic')
    if has_navic then
      navic.attach(client, bufnr)
    end
  end
end

for server, require_path in pairs(servers) do
  vim.lsp.config(server, {
    capabilities = capabilities,
    on_attach = base_on_attach
  })

  -- auto install ts parser
  local parser = lsp_to_parser[server]
  if parser then
    ensure_parser(parser)
  end

  -- Dynamically load specific config options
  local has_config, config_options = pcall(require, require_path)
  if has_config and type(config_options) == 'table' then
    vim.lsp.config(server, config_options)
  end

  vim.lsp.enable(server)
end
