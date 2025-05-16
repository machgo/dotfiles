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
	},
})

-- enable autocompletion
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

-- don't select first autocompletion match automaticaly
vim.cmd("set completeopt+=noselect")

-- setup powershell lsp
vim.lsp.config("powershell_es", {
	bundle_path = "~/.local/share/nvim/mason/packages/powershell-editor-services",
	shell = "pwsh",
})
