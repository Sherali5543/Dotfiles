-- Any custom configs can be listed
local servers = {
  lua_ls = "lsp.lua.lua",
  clangd = "lsp.cpp.cpp",
  jedi_language_server = 'lsp.python.python',
  qmlls = 'lsp.qml.qml',
  neocmake = 'lsp.cmake.cmake'
}

-- Retrieve mason->nvim lsp mappings
local mappings = require("mason-lspconfig").get_mappings()
local lsp_to_package = mappings.lspconfig_to_package
local package_to_lsp = mappings.package_to_lspconfig

local registry = require('mason-registry')


-- navic for breadcrumbs
local function base_on_attach(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    local has_navic, navic = pcall(require, 'nvim-navic')
    if has_navic then navic.attach(client, bufnr) end
  end
end

-- get completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp then
  capabilities = cmp_lsp.default_capabilities()
end

-- Install servers
local function ensure_lsp(server)
  local ok, pkg = pcall(registry.get_package, lsp_to_package[server])

  if not ok then
    vim.notify("Error installing: " .. server, vim.log.levels.WARN)
    return
  end

  if not pkg:is_installed() then
    vim.notify("Installing package: " .. server, vim.log.levels.DEBUG)
    pkg:install()
  end
end

local function setup_and_enable_server(server, require_path)
  vim.lsp.config(server, {
    capabilities = capabilities,
    on_attach = base_on_attach
  })

  local has_config, config_options = pcall(require, require_path)
  if has_config and type(config_options) == 'table' then
    vim.lsp.config(server, config_options)
  end

  vim.lsp.enable(server)
end

-- Extract servers for mason
for server_name, _ in pairs(servers) do
  ensure_lsp(server_name)
end

for _, pkg in ipairs(registry.get_installed_packages()) do
  local lsp = package_to_lsp[pkg.name]
  if lsp then
    setup_and_enable_server(lsp, servers[lsp])
  end
end
