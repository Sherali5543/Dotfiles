return {
  name = "arista",
  dir = "/usr/share/vim/vimfiles/",
  cond = function()
    return vim.fn.isdirectory("/usr/share/vim/vimfiles/")
  end,
}
