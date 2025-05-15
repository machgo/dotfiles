return {
    'nvim-treesitter/nvim-treesitter',
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts = {
        ensure_installed = {
            "hcl",
            "terraform",
        },
    },
}
