-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
  'https://github.com/leoluz/nvim-dap-go',
}

local dap = require 'dap'
local dapui = require 'dapui'

require('mason-nvim-dap').setup {
  -- Makes a best effort to setup the various debuggers with
  -- reasonable debug configurations
  automatic_installation = true,

  -- You can provide additional configuration to the handlers,
  -- see mason-nvim-dap README for more information
  handlers = {},

  -- You'll need to check that you have the required things installed
  -- online, please don't ask me how to install them :)
  ensure_installed = {
    -- Update this to ensure that you have the debuggers for the langs you want
    'delve',
    'netcoredbg'
  },
}

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
---@diagnostic disable-next-line: missing-fields
dapui.setup {
  -- Set icons to characters that are more likely to work in every terminal.
  --    Feel free to remove or use ones that you like more! :)
  --    Don't feel like these are good choices.
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  ---@diagnostic disable-next-line: missing-fields
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

-- Change breakpoint icons
-- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
-- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
-- local breakpoint_icons = vim.g.have_nerd_font
--     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
--   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
-- for type, icon in pairs(breakpoint_icons) do
--   local tp = 'Dap' .. type
--   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
--   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
-- end

local netcoredbg_adapter = {
  type = "executable",
  command = vim.fn.stdpath("data") .. "/netcoredbg-arm64/netcoredbg/netcoredbg",
  args = { "--interpreter=vscode" }
}

dap.adapters.netcoredbg = netcoredbg_adapter
dap.adapters.coreclr = netcoredbg_adapter

local last_project_root = nil

local function find_nearest_csproj()
  local current_file = vim.fn.expand("%:p")
  local start_dir = current_file ~= "" and vim.fn.fnamemodify(current_file, ":h") or vim.fn.getcwd()
  local found = vim.fs.find(function(name)
    return name:match("%.csproj$") ~= nil
  end, { upward = true, path = start_dir })
  return found[1]
end

local function find_sln_root()
  local current_file = vim.fn.expand("%:p")
  local start_dir = current_file ~= "" and vim.fn.fnamemodify(current_file, ":h") or vim.fn.getcwd()
  local found = vim.fs.find(function(name)
    return name:match("%.sln$") ~= nil
  end, { upward = true, path = start_dir })
  return found[1] and vim.fs.dirname(found[1]) or vim.fn.getcwd()
end

local function list_all_projects()
  return vim.fn.globpath(find_sln_root(), "**/*.csproj", false, true)
end

local function pick_dll_for_project(csproj_path, on_choice)
  local project_root = vim.fs.dirname(csproj_path)
  local project_name = vim.fs.basename(csproj_path):gsub("%.csproj$", "")

  require("telescope.builtin").find_files({
    prompt_title = "DLL for " .. project_name,
    cwd = project_root,
    find_command = {
      "find", ".",
      "-path", "*/obj/*", "-prune", "-o",
      "-path", "*/bin/Debug/*", "-type", "f",
      "-iname", project_name .. ".dll", "-print"
    },
    attach_mappings = function(prompt_bufnr)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        on_choice(selection and selection.path or nil)
      end)
      return true
    end,
  })
end

local function pick_dll()
  return coroutine.create(function(dap_run_co)
    local csproj = last_project_root and (last_project_root .. "/dummy.csproj") or find_nearest_csproj()
    -- last_project_root peker på mappen, så finn faktisk .csproj i den om satt eksplisitt
    if last_project_root then
      local projects = vim.fn.globpath(last_project_root, "*.csproj", false, true)
      csproj = projects[1]
    end

    if not csproj then
      vim.notify("Fant ingen .csproj", vim.log.levels.ERROR)
      coroutine.resume(dap_run_co, nil)
      return
    end

    pick_dll_for_project(csproj, function(path)
      coroutine.resume(dap_run_co, path)
    end)
  end)
end

local function get_cwd()
  if last_project_root then
    return last_project_root
  end
  local csproj = find_nearest_csproj()
  return csproj and vim.fs.dirname(csproj) or vim.fn.getcwd()
end

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = pick_dll,
    cwd = get_cwd,
    env = { ASPNETCORE_ENVIRONMENT = "Development" },
  }
}

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

vim.keymap.set("n", "<F5>", function()
  last_project_root = nil
  require("dap").continue()
end, { desc = "Debug: Start/Continue" })

vim.keymap.set("n", "<leader>dp", function()
  local projects = list_all_projects()
  if #projects == 0 then
    vim.notify("Fant ingen .csproj-filer i solutionen", vim.log.levels.WARN)
    return
  end
  vim.ui.select(projects, {
    prompt = "Velg prosjekt å debugge:",
    format_item = function(item) return vim.fs.basename(item) end,
  }, function(choice)
    if not choice then return end
    last_project_root = vim.fs.dirname(choice)
    vim.notify("Aktivt debug-prosjekt: " .. vim.fs.basename(choice), vim.log.levels.INFO)
    require("dap").continue()
  end)
end, { desc = "Debug: Velg prosjekt og start" })

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set('n', '<F1>', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set('n', '<F7>', function() require('dapui').toggle() end, { desc = 'Debug: See last session result.' })

-- Install golang specific config
require('dap-go').setup {
  delve = {
    -- On Windows delve must be run attached or it crashes.
    -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
    detached = vim.fn.has 'win32' == 0,
  },
}
