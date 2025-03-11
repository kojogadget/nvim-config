local keymap = vim.keymap.set

keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

keymap("n", "<C-f>", ":silent !tmux neww tmux-sessionizer<CR>")

-- Dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Terminal
keymap("t", "<Esc>", "<C-\\><C-n>", { silent = true })

-- Undotree
keymap("n", "<leader>uu", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
keymap("n", "<leader>ud", vim.cmd.DBUIToggle, { desc = "Toggle Dadbod UI" })

-- Spell
keymap("n", "<localleader>s", function ()
  vim.opt.spell = not(vim.opt.spell:get())
end, { desc = "Toggle spell" })

-- Telescope
keymap("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "Find recently opened files" })
keymap("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Find existing buffers" })
keymap("n", "<leader>fs", function()
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
    winblend = 0,
    previewer = false,
  })
end, { desc = "Fuzzily search in current buffer" })
keymap("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Search Files" })
keymap("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "Search Help" })
keymap("n", "<leader>fw", require("telescope.builtin").grep_string, { desc = "Search current Word" })
keymap("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Search by Grep" })
keymap("n", "<leader>fo", require("telescope.builtin").lsp_document_symbols, { desc = "Search Symbols" })

-- Diagnostic keymaps
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
