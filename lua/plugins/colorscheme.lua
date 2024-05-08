return {
	"navarasu/onedark.nvim",
	opts = {
		style		= "darker",
		transparent 	= true,
	},
	init = function()
		require("onedark").load()
	end
}
