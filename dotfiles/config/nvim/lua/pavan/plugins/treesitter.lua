return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "lua", "javascript", "typescript", "tsx", "html", "css",
      "json", "yaml", "python", "java", "hcl", "bash",
      "markdown", "vim", "vimdoc",
    })

    -- Enable treesitter highlighting for all supported filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "lua", "javascript", "typescript", "typescriptreact", "html", "css",
        "json", "yaml", "python", "java", "terraform", "bash", "sh",
        "markdown", "vim",
      },
      callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
