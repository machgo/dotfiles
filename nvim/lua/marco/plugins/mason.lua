return {
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				-- LSP servers
				"ansible-language-server",
				"gopls",
				"lua-language-server",
				"marksman",
				"powershell-editor-services",
				"pyright",
				"terraform-ls",
				"yaml-language-server",

				-- Linters and formatters
				"ansible-lint",
				"black",
				"hclfmt",
				"isort",
				"prettier",
				"prettierd",
				"stylua",
				"terraform",
			},
			run_on_start = true,
			auto_update = true,
		},
	},
}
