return {
  "nvim-java/nvim-java",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "mfussenegger/nvim-dap",
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    require("java").setup({
      spring_boot_tools = { enable = true },
    })

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "ts_ls", "html", "cssls", "tailwindcss",
        "lua_ls", "pyright", "terraformls",
      },
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- LSP keymaps on attach
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { noremap = true, silent = true, buffer = args.buf }
        local keymap = vim.keymap
        keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts)
        keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
        keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
        keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
        keymap.set("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
        keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
        keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
        keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
        keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)
      end,
    })

    -- Configure servers
    local servers = { "ts_ls", "html", "cssls", "tailwindcss", "pyright", "terraformls" }
    for _, server in ipairs(servers) do
      vim.lsp.config(server, { capabilities = capabilities })
    end

    -- jdtls managed by nvim-java
    vim.lsp.config("jdtls", { capabilities = capabilities })

    -- lua_ls with neovim-specific settings
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
        },
      },
    })

    vim.lsp.enable(vim.list_extend(servers, { "lua_ls", "jdtls" }))
  end,
}
