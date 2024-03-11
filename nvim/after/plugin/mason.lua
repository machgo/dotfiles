local lsp_zero = require('lsp-zero')

require('mason').setup({})
require('mason-lspconfig').setup({


    ensure_installed = {
        'azure_pipelines_ls', 'bashls', 'lua_ls', 'powershell_es', 'rust_analyzer', 'terraformls', 'tsserver', 'vimls',
        'yamlls'
    },
    handlers = {
        lsp_zero.default_setup,
    }
})
