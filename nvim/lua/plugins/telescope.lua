local M = {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim",
        "natecraddock/telescope-zf-native.nvim"
    },
}

function M.config()
    local telescope = require("telescope")
    telescope.setup({
        pickers = {
            find_files = {
                find_command = function()
                    local current_file = vim.fn.expand("%")
                    if current_file ~= "" then
                        return { "sh", "-c", string.format("fd --type file --follow | proximity-sort %s", current_file) }
                    else
                        return { "fd", "--type", "file", "--follow" }
                    end
                end
            },
        },
        extensions = {
            ["zf-native"] = {
                file = {
                    enabled = true,
                },
                generic = {
                    enabled = true,
                },
                file_extension_weight = 1,
                highlight_results = true,
            },
        },
    })

    telescope.load_extension("zf-native")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>k", builtin.live_grep, { desc = "Telescope live grep" })
    vim.keymap.set("n", "<leader>[", builtin.find_files)
    vim.keymap.set("n", "<leader>;", builtin.buffers)
end

return M
