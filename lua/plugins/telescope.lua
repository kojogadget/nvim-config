return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable "make" == 1
      end,
    },
  },
  config = function ()
    pcall(require("telescope").load_extension, "fzf")
  end,
  opt = {
    pickers = {
      colorscheme = {
        enable_preview = true
      }
    }
  },
}
