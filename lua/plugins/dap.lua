return {
  "mfussenegger/nvim-dap",
  "jay-babu/mason-nvim-dap.nvim",

  { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },

  {
	"theHamsta/nvim-dap-virtual-text",
	opts = {
	  commented = true,
	}
  }
}
