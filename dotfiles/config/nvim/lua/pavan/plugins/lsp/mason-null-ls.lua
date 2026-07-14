local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
  return
end

mason_null_ls.setup({
  ensure_installed = {
    "prettier", -- js/ts/css/html formatter
    "stylua", -- lua formatter
    "black", -- python formatter
    "eslint_d", -- js/ts linter
    "pylint", -- python linter
  },
})
