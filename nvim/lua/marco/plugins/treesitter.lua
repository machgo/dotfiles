return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	enabled = true,
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			highlight = { enable = true },
			indent = { enable = true },
			auto_install = false,
			-- language list: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
			ensure_installed = {
				"lua",
				"comment", -- used for TODO:, FIXME:, XXX: and NOTE:
				"vim",
				"vimdoc",
				"bash",
				"diff",
				"make",
				"gitignore",
				"gitcommit",
				"markdown",
				"markdown_inline",
				"yaml",
				"html",
				"css",
				"javascript",
				"dockerfile",
				"query",
				"hcl",
				"terraform",
				"csv",
				"properties",
				"ini",
				"python",
				"regex",
				"json",
				"go",
				"gomod",
				"gosum",
				"editorconfig",
				"http",
				"toml",
				"sql",
				"promql",
				"nginx",
				"powershell",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-s>",
					node_incremental = "<C-s>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
