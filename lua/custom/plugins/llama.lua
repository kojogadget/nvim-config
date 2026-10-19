vim.g.llama_config = {
  endpoint_fim = 'http://127.0.0.1:8012/infill',
  auto_fim = false,
  show_info = false,

  model_fim = 'Qwen2.5-Coder-7B-Q8_0-GGUF',
  model_inst = 'Qwen2.5-Coder-7B-Q8_0-GGUF',

  keymap_fim_trigger = '<C-l>',
  keymap_fim_accept_full = '<Tab>',
  keymap_fim_accept_line = '<S-Tab>',
  keymap_fim_accept_word = '<C-Right>',

  endpoint_inst = 'http://127.0.0.1:8012/v1/chat/completions',
  keymap_inst_trigger = '<leader>lli',
  keymap_inst_rerun = '<leader>llr',
  keymap_inst_continue = '<leader>llc',
  keymap_inst_accept = '<Tab>',
  keymap_inst_cancel = '<Esc>',
}

vim.pack.add {
  {
    src = 'https://github.com/ggml-org/llama.vim',
    name = 'llama.vim',
  },
}
