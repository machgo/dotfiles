return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
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

		default_format_opts = {
			lsp_format = "fallback",
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
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
