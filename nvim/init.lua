local core_conf_files = {
  "plugins.vim", -- install plugins
  "options.vim", -- basic options settings
  "treesitter.lua", -- treesitter settings
  "lualine.lua", -- lualine settings
  "nvim-cmp.lua", -- nvim-cmp settings
  "mason.lua", -- mason settings
  "nvimtree.lua", -- nvimtree settings
}

-- source all the core config files
for _, name in ipairs(core_conf_files) do
  local path = string.format("%s/%s", vim.fn.stdpath("config"), name)
  local source_cmd = "source " .. path
  vim.cmd(source_cmd)
end
