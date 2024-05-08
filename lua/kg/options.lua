local options = {
	number			= true,
	relativenumber 	= true,

	clipboard      	= "unnamedplus",

	breakindent    	= true,
	tabstop        	= 4,
	softtabstop    	= 4,
	shiftwidth     	= 4,
	expandtab      	= true,

	undofile       	= true,
	undodir        	= vim.fn.stdpath("data") .. "/undodir",

	hlsearch		= false,
	ignorecase     	= true,
	smartcase      	= true,

	completeopt    	= "menuone,noselect",

	timeout        	= true,
	timeoutlen     	= 500,

	foldcolumn		= "0",
	foldlevel		= 99,
	foldlevelstart 	= 99,
	foldenable		= true,

	spelllang		= { "nb", "en" },
	spellcapcheck	= "",
}

vim.g.spellfile_URL = "https://ftp.nluug.nl/pub/vim/runtime/spell/"

for k, v in pairs(options) do
	vim.opt[k] = v
end
