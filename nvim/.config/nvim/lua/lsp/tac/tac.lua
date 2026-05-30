-- run on container
-- a ws yum install ArTacLSP

local function is_parser_installed(parser)
  local ok, parsers = pcall(require, 'nvim-treesitter.parsers')
  if not ok then return false end
  return parsers.has_parser(parser)
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

local parser = 'cpp'
if parser and not is_parser_installed(parser) then
  vim.schedule(function()
    vim.cmd("TSInstall " .. parser)
  end)
end

vim.lsp.enable('artaclsp')
