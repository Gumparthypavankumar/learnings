local ts_status, ts = pcall(require, "nvim-treesitter.configs")
if not ts_status then
  return
end

ts.setup({
  ensure_installed = {
    "lua",
    "javascript",
    "typescript",
    "tsx",
    "html",
    "css",
    "json",
    "yaml",
    "python",
    "java",
    "hcl", -- terraform
    "bash",
    "markdown",
    "vim",
    "vimdoc",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  auto_install = true,
})
