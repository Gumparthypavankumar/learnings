return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "kyazdani42/nvim-web-devicons" },
	config = function()
		vim.g.loaded = 1
		vim.g.loaded_netrwPlugin = 1
		vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF]])

		-- 2. Custom Git status colors (Change hex codes to whatever you prefer)
		vim.cmd([[ highlight NvimTreeGitDirty guifg=#E5C07B ]]) -- Changes modified files from Magenta to Yellow/Orange
		vim.cmd([[ highlight NvimTreeGitNew guifg=#98C379 ]]) -- Changes untracked files from Yellow to Green
		vim.cmd([[ highlight NvimTreeGitDeleted guifg=#EF596F ]]) -- Red for deleted
		vim.cmd([[ highlight NvimTreeGitStaged guifg=#56B6C2 ]]) -- Cyan for staged files

		require("nvim-tree").setup({
			git = {
				enable = true, -- Enables git integration
				ignore = false, -- Keeps git-ignored files visible (set to true to hide them)
			},
			renderer = {
				highlight_git = true, -- Colors the actual file names based on Git status
				icons = {
					show = {
						git = true, -- Shows Git status icons (e.g., [M]odified, [U]ntracked)
					},
				},
			},
			actions = {
				open_file = {
					window_picker = { enable = false },
				},
			},
		})
	end,
}
