local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

-- fix error e5248 for .tfvar files
vim.api.nvim_create_autocmd(
  {
    "BufRead", "BufNewFile"
  },
  {
    pattern = {"*.tfvars"},
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_option(buf, "filetype", "terraform")
    end
  })
