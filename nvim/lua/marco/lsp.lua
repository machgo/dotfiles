vim.lsp.enable({ "yaml", "ansible", "lua", "marksman", "powershell_es", "terraformls", "pyright" })

-- yaml for ansible files
vim.filetype.add({
	pattern = {
		[".*/.*playbook.*.ya?ml"] = "yaml.ansible",
		[".*/.*tasks.*/.*ya?ml"] = "yaml.ansible",
		[".*/.*group_vars.*/.*ya?ml"] = "yaml.ansible",
		[".*/.*host_vars.*/.*ya?ml"] = "yaml.ansible",
		[".*/local.ya?ml"] = "yaml.ansible",
		[".*-ansible/.*ya?ml"] = "yaml.ansible",
        [".*pkr.hcl"] = "hclpacker",
        [".*.hcl"] = "terraform",
	},
})

-- setup powershell lsp
vim.lsp.config("powershell_es", {
	bundle_path = "~/.local/share/nvim/mason/packages/powershell-editor-services",
	shell = "pwsh",
})

-- treesitter for hcl
vim.treesitter.language.register("hcl", "hclpacker")
