return {
  "glepnir/lspsaga.nvim",
  branch = "main",
  config = function()
    require("lspsaga").setup({
      move_in_saga = { prev = "<C-k>", next = "<C-j>" },
      finder = { keys = { open = "<CR>" } },
      definition = { keys = { edit = "<CR>" } },
    })
  end,
}
