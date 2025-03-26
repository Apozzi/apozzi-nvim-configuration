return {
        "smoka7/hop.nvim",
        version = "*",
        config = function()
            local hop = require("hop")
            hop.setup { keys = "etovxqpdygfblzhckisuran" }
            vim.keymap.set("", "f", function() hop.hint_words() end, { remap = true })
            vim.keymap.set("", "F", function() hop.hint_char1() end, { remap = true })
            vim.keymap.set("", "<leader>j", function() hop.hint_lines() end, { remap = true })
            vim.keymap.set("", "<leader>w", function() hop.hint_words() end, { remap = true })
        end,
}