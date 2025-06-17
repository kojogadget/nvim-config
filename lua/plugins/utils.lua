return {
	"tpope/vim-fugitive",
	"tpope/vim-sleuth",
	"tpope/vim-surround",
	"tpope/vim-dadbod",
	{
		"kristijanhusak/vim-dadbod-ui",
		config = function ()
			vim.g.db_ui_tmp_query_location = "/home/kg/.local/share/db_ui/queries"
		end
	},
	"kristijanhusak/vim-dadbod-completion",

	"mbbill/undotree",
	"preservim/tagbar",
	{
		"rcarriga/nvim-notify",
		opts = {
			background_colour = "#000000"
		}
	},
}
