return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup({
			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
			},
		})

		vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Add to harpoon" })
		vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
			{ desc = "Toggle harpoon" })

		for i = 1, 9 do
			vim.keymap.set('n', '<A-' .. i .. '>', function()
				harpoon:list():select(i)
			end, { desc = 'Harpoon file ' .. i })
		end

		-- Workaround for Ufo folds disabling when changing buffer with harpoon
		require("harpoon"):extend(require("harpoon.extensions").builtins.command_on_nav('UfoEnableFold'))
	end
}
