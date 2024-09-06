return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    event = "VimEnter",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>xx", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
    },
}
