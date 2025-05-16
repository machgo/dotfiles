return {
	"stevearc/conform.nvim",
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", "black" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },
			-- Conform will run the first available formatter
			javascript = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettier" },
			json = { "prettier" },
			terraform = { "terraform_fmt" },
			hcl = { "hclfmt" },
			markdown = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			typescript = { "prettier" },
			ps1 = { lsp_format = "prefer" },
            hclpacker = { "packer_fmt" },
		},
		format_on_save = { timeout_ms = 500 },
	},
	keys = {
		{
			"<leader>cc",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
}
