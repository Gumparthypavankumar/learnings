return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "desdic/telescope-rooter.nvim",
  },
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = { hidden = true },
      },
      extensions = {
        rooter = {
          enable = true,
          patterns = { ".git", "Makefile", "package.json", "build.gradle", "pom.xml", "Cargo.toml" },
        },
      },
    })
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("rooter")
  end,
}
