local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local keymap = vim.keymap

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local opts = { noremap = true, silent = true, buffer = bufnr }

		keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts)
		keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
		keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
		keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
		keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
		keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
		keymap.set("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
		keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
		keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
		keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
		keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
		keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)
	end,
})

local capabilities = cmp_nvim_lsp.default_capabilities()

local servers = { "ts_ls", "html", "cssls", "tailwindcss", "pyright", "jdtls", "terraformls" }

for _, server in ipairs(servers) do
	vim.lsp.config(server, {
		capabilities = capabilities,
	})
end

vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
})

vim.lsp.enable(vim.list_extend(servers, { "lua_ls" }))
keymap.set("n", "gsv", function()
	vim.cmd("vsplit")
	vim.lsp.buf.definition()
end, { desc = "LSP definition in vertical split" })
