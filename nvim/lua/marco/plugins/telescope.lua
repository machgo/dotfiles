return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    event = "VimEnter",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "debugloop/telescope-undo.nvim",
    },
    keys = {
        { "<leader>bb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
        { "<leader>fu", "<cmd>Telescope undo<cr>" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>" },
    },
    config = function()
        require("telescope").setup({
            -- the rest of your telescope config goes here
            extensions = {
                undo = {
                    -- telescope-undo.nvim config, see below
                },
                -- other extensions:
                -- file_browser = { ... }
            },
        })
        require("telescope").load_extension("undo")
        -- optional: vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
    end,
}
