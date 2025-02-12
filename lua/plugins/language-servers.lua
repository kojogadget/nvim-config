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
      vim.opt_local.textwidth = 80
      vim.opt_local.wrap = true

      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "vimtex#fold#level(v:lnum)"
      vim.opt_local.foldtext = "vimtex#fold#text()"
      vim.opt_local.foldlevel = 0
    end
  },
}
