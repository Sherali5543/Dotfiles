vim.cmd.colorscheme('catppuccin')
-- Define a helper to link highlight groups
local function link_hl(from, to)
  vim.api.nvim_set_hl(0, from, { link = to, default = false })
end

-- Link Navic highlight groups to built-in syntax groups
link_hl("NavicIconsFile",          "Directory")
link_hl("NavicIconsModule",        "Include")
link_hl("NavicIconsNamespace",     "Include")
link_hl("NavicIconsPackage",       "Include")
link_hl("NavicIconsClass",         "Type")
link_hl("NavicIconsMethod",        "Function")
link_hl("NavicIconsProperty",      "Identifier")
link_hl("NavicIconsField",         "Identifier")
link_hl("NavicIconsConstructor",   "Function")
link_hl("NavicIconsEnum",          "Type")
link_hl("NavicIconsInterface",     "Type")
link_hl("NavicIconsFunction",      "Function")
link_hl("NavicIconsVariable",      "Identifier")
link_hl("NavicIconsConstant",      "Constant")
link_hl("NavicIconsString",        "String")
link_hl("NavicIconsNumber",        "Number")
link_hl("NavicIconsBoolean",       "Boolean")
link_hl("NavicIconsArray",         "Type")
link_hl("NavicIconsObject",        "Type")
link_hl("NavicIconsKey",           "Identifier")
link_hl("NavicIconsNull",          "Comment")
link_hl("NavicIconsEnumMember",    "Constant")
link_hl("NavicIconsStruct",        "Structure")
link_hl("NavicIconsEvent",         "Type")
link_hl("NavicIconsOperator",      "Operator")
link_hl("NavicIconsTypeParameter", "Type")

-- Optional: Breadcrumb separators and text
link_hl("NavicText", "Normal")
link_hl("NavicSeparator", "Comment")


vim.api.nvim_set_hl(0, "Folded", {
  bg = "#301F40",
  blend = 20,
})

vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
