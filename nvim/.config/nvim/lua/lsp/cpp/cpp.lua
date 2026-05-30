vim.lsp.enable("clangd")

vim.lsp.config.clangd = {
  cmd = { "clangd", "--enable-config", "--header-insertion=never", "--fallback-style=Google" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
}
