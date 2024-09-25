return {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
        file_types = { 'markdown' },
        code = {
            width = 'block',
            border = 'thick',
        },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
}
