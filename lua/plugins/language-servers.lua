return {
  -- Java
  "mfussenegger/nvim-jdtls",
  -- Latex
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      require("ufo").detach()

      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_format_enabled = true
      vim.g.vimtex_fold_enabled = true

      -- vim.g.vimtex_grammar_vlty = {
      --   lt_directory = "/opt/LanguageTool",
      --   show_suggestions = 1
      -- }

      vim.g.vimtex_compiler_latexmk = {
        out_dir = "build"
      }
      vim.opt["textwidth"] = 80
      vim.opt["wrap"] = true

      vim.opt["foldmethod"] = "expr"
      vim.opt["foldexpr"] = "vimtex#fold#level(v:lnum)"
      vim.opt["foldtext"] = "vimtex#fold#text()"
      vim.opt["foldlevel"] = 0
    end
  },
}
