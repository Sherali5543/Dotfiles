vim.lsp.config.neocmake = {
  cmd = { "neocmakelsp", "stdio" },
  filetypes = { "cmake" },
  root_markers = { "CMakeLists.txt", ".git", "build", "cmake" },
  init_options = {
    format = { enable = false },
    lint = { enable = false },
    scan_cmake_in_package = false,
    semantic_token = false,
  },
}

vim.lsp.enable('neocmake')
