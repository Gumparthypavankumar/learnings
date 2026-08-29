return {
	{
		"tpope/vim-fugitive",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation: Git Hunks
					map("n", "]c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end, { desc = "Jump to next Git hunk" })

					map("n", "[c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end, { desc = "Jump to prev Git hunk" })

					-- Navigation: LSP Diagnostics
					map("n", "]d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, { desc = "Jump to next diagnostic" })

					map("n", "[d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, { desc = "Jump to prev diagnostic" })
				end,
			})
		end,
	},
}
