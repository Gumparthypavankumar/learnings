return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  config = function()
    vim.g.loaded = 1
    vim.g.loaded_netrwPlugin = 1
    vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF]])
    require("nvim-tree").setup({
      actions = {
        open_file = {
          window_picker = { enable = false },
        },
      },
    })
  end,
}
