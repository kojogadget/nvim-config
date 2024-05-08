return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim", config = true },

        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "aznhe21/actions-preview.nvim",

        {
            "j-hui/fidget.nvim",
            tag = "legacy",
            opts = {
                window = {
                    relative = "win",
                    blend = 0,
                },
            },
        },

        -- Additional lua configuration, makes nvim stuff amazing!
        { "folke/neodev.nvim", opts = {} },
    },

    config = function()
        local servers = {
            jdtls = {},
            eslint = {},
            pyright = {},
            tsserver = { filetypes = { "javascriptreact", "typescriptreact" } },
            html = { filetypes = { "html" } },

            lua_ls = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                },
            },
        }

        local on_attach = function(_, bufnr)
            local nmap = function(keys, func, desc)
                if desc then
                    desc = "LSP: " .. desc
                end

                vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
            end

            nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
            nmap("<leader>ca", require("actions-preview").code_actions, "[C]ode [A]ction")

            nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
            nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
            nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
            nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
            nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
            nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

            -- See `:help K` for why this keymap
            nmap("K", vim.lsp.buf.hover, "Hover Documentation")
            -- nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

            -- Lesser used LSP functionality
            nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
            nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
            nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
            nmap("<leader>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, "[W]orkspace [L]ist Folders")

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
                vim.lsp.buf.format()
            end, { desc = "Format current buffer with LSP" })

            -- Debugging
            vim.keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
            vim.keymap.set("n", "<leader>bc",
                "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>")
            vim.keymap.set("n", "<leader>bl",
                "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>")
            vim.keymap.set("n", '<leader>br', "<cmd>lua require'dap'.clear_breakpoints()<cr>")
            vim.keymap.set("n", '<leader>ba', '<cmd>Telescope dap list_breakpoints<cr>')
            vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>")
            vim.keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>")
            vim.keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<cr>")
            vim.keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>")
            vim.keymap.set("n", '<leader>dd', function()
                require('dap').disconnect(); require('dapui').close();
            end)
            vim.keymap.set("n", '<leader>dt', function()
                require('dap').terminate(); require('dapui').close();
            end)
            vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>")
            vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>")
            vim.keymap.set("n", '<leader>di', function() require "dap.ui.widgets".hover() end)
            vim.keymap.set("n", '<leader>d?',
                function()
                    local widgets = require "dap.ui.widgets"; widgets.centered_float(widgets.scopes)
                end)
            vim.keymap.set("n", '<leader>df', '<cmd>Telescope dap frames<cr>')
            vim.keymap.set("n", '<leader>dh', '<cmd>Telescope dap commands<cr>')
            vim.keymap.set("n", '<leader>de',
                function() require('telescope.builtin').diagnostics({ default_text = ":E:" }) end)
        end

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        require("mason-lspconfig").setup({
            ensure_installed = vim.tbl_keys(servers),
        })

        require("mason-lspconfig").setup_handlers({
            function(server_name)
                if server_name == "jdtls" then
                    require("lspconfig").jdtls.setup({
                        cmd = { "echo", "disabled" },
                        on_attach = function()
                            return
                        end,
                    })
                else
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                    })
                end
            end,
        })

        require("mason-tool-installer").setup({
            ensure_installed = {
                "java-debug-adapter",
                "java-test",
            }
        })
    end
}
