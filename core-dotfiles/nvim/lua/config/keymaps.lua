vim.keymap.set("n", "gl", function()
    vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in Float" })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set("n", "<leader>y", [["+Y]])
vim.keymap.set("x", "s", [[:s/\%V]])
vim.keymap.set("n", "<leader>cf", function()
    require("conform").format({
        lsp_format = "fallback",
    })
end, { desc = "Format current file" })
