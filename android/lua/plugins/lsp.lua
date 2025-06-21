-- ══════════════════════════════════════════════════════════════════════
-- LSP Configuration for Android/Termux
-- Language servers optimized for mobile development
-- ══════════════════════════════════════════════════════════════════════

return {
  -- Mason for managing LSP servers
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          width = math.min(vim.o.columns - 10, 120),
          height = math.min(vim.o.lines - 10, 30),
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
        install_root_dir = vim.fn.stdpath("data") .. "/mason",
        PATH = "prepend", -- "skip" seems to cause the spawning error
        log_level = vim.log.levels.INFO,
        max_concurrent_installers = 2, -- Reduced for mobile stability
        github = {
          download_url_template = "https://github.com/%s/releases/download/%s/%s",
        },
      })
    end,
  },

  -- Mason LSP config
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- Core languages
          "lua_ls",
          "tsserver",
          "pyright",
          
          -- Web development
          "html",
          "cssls",
          "jsonls",
          "yamlls",
          
          -- Optional (install based on usage)
          -- "gopls",
          -- "rust_analyzer",
          -- "astro",
          -- "tailwindcss",
          -- "marksman",
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "folke/neodev.nvim",
    },
    config = function()
      -- Setup neodev for better lua development
      require("neodev").setup({
        library = {
          enabled = true,
          runtime = true,
          types = true,
          plugins = true,
        },
        setup_jsonls = true,
        lspconfig = true,
        pathStrict = true,
      })

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- Android/Mobile optimizations
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" },
      }

      -- Diagnostic configuration (mobile optimized)
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "if_many",
          spacing = 2,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
          max_width = math.floor(vim.o.columns * 0.8),
          max_height = math.floor(vim.o.lines * 0.3),
        },
      })

      -- Diagnostic signs
      local signs = { 
        Error = "❌", 
        Warn = "⚠️", 
        Hint = "💡", 
        Info = "ℹ️" 
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- LSP handlers (mobile optimized)
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
        max_width = math.floor(vim.o.columns * 0.8),
        max_height = math.floor(vim.o.lines * 0.4),
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
        max_width = math.floor(vim.o.columns * 0.8),
        max_height = math.floor(vim.o.lines * 0.3),
      })

      -- LSP on_attach function
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Mobile-friendly mappings
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        
        -- Navigation
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", bufopts)
        vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", bufopts)
        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", bufopts)
        vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", bufopts)
        
        -- Hover and signature help
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        
        -- Workspace management
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<space>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        
        -- Code actions and refactoring
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, bufopts)
        
        -- Formatting
        if client.supports_method("textDocument/formatting") then
          vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
          end, bufopts)
        end

        -- Mobile-specific optimizations
        if vim.g.is_android then
          -- Reduce update frequency for better performance
          client.config.flags = client.config.flags or {}
          client.config.flags.debounce_text_changes = 500
          
          -- Disable some features for performance
          if client.server_capabilities.semanticTokensProvider then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end

        -- Highlight references on cursor hold
        if client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_augroup("lsp_document_highlight", {
            clear = false,
          })
          vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = "lsp_document_highlight",
          })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      -- Server configurations
      local servers = {
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
              },
              completion = { callSnippet = "Replace" },
              telemetry = { enable = false },
              hint = { enable = true },
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },

        -- TypeScript/JavaScript
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
              },
            },
          },
        },

        -- Go (optional)
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              gofumpt = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },

        -- HTML
        html = {
          capabilities = capabilities,
        },

        -- CSS
        cssls = {
          capabilities = capabilities,
        },

        -- JSON
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        -- YAML
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://json.schemastore.org/github-action.json"] = "/action.{yml,yaml}",
                ["https://json.schemastore.org/prettierrc.json"] = "/.prettierrc.{yml,yaml}",
                ["https://json.schemastore.org/circleciconfig"] = "/.circleci/**/*.{yml,yaml}",
              },
            },
          },
        },

        -- Markdown
        marksman = {},
      }

      -- Setup servers
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        
        -- Android-specific optimizations
        if vim.g.is_android then
          config.flags = config.flags or {}
          config.flags.debounce_text_changes = 500
        end
        
        lspconfig[server].setup(config)
      end
    end,
  },

  -- JSON schemas
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- Better LSP progress notifications
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
      require("fidget").setup({
        text = {
          spinner = "dots", -- Simple spinner for mobile
          done = "✓",
          commenced = "Started",
          completed = "Completed",
        },
        align = {
          bottom = true,
          right = true,
        },
        timer = {
          spinner_rate = 200, -- Slower for battery
          fidget_decay = 2000,
          task_decay = 1000,
        },
        window = {
          relative = "win",
          blend = 0, -- No transparency for better mobile visibility
          zindex = nil,
          border = "none",
        },
        fmt = {
          leftpad = true,
          stack_upwards = true,
          max_width = math.min(50, vim.o.columns - 10),
          fidget = function(fidget_name, spinner)
            return string.format("%s %s", spinner, fidget_name)
          end,
          task = function(task_name, message, percentage)
            return string.format(
              "%s%s [%s]",
              message,
              percentage and string.format(" (%s%%)", percentage) or "",
              task_name
            )
          end,
        },
        debug = {
          logging = false,
          strict = false,
        },
      })
    end,
  },

  -- Enhanced LSP UI
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup({
        ui = {
          theme = "round",
          border = "rounded",
          winblend = 0, -- No transparency for mobile
          expand = "",
          collapse = "",
          preview = " ",
          code_action = "💡",
          diagnostic = "🐞",
          incoming = " ",
          outgoing = " ",
          colors = {
            normal_bg = "#1a1b26",
          },
        },
        hover = {
          max_width = math.floor(vim.o.columns * 0.8),
          max_height = math.floor(vim.o.lines * 0.4),
          open_link = "gx",
          open_browser = "termux-open-url", -- Android browser
        },
        diagnostic = {
          show_code_action = true,
          show_source = true,
          jump_num_shortcut = true,
          max_width = math.floor(vim.o.columns * 0.8),
          max_height = math.floor(vim.o.lines * 0.4),
          keys = {
            exec_action = "o",
            quit = "q",
            go_action = "g",
          },
        },
        code_action = {
          num_shortcut = true,
          show_server_name = false,
          extend_gitsigns = true,
          keys = {
            quit = "q",
            exec = "<CR>",
          },
        },
        lightbulb = {
          enable = true,
          enable_in_insert = true,
          sign = true,
          sign_priority = 40,
          virtual_text = false, -- Disabled for mobile performance
        },
        preview = {
          lines_above = 0,
          lines_below = 10,
        },
        scroll_preview = {
          scroll_down = "<C-f>",
          scroll_up = "<C-b>",
        },
        request_timeout = 2000,
        finder = {
          max_height = 0.5,
          min_width = 30,
          force_max_height = false,
          keys = {
            jump_to = "p",
            expand_or_jump = "o",
            vsplit = "s",
            split = "i",
            tabe = "t",
            tabnew = "r",
            quit = { "q", "<ESC>" },
            close_in_preview = "<ESC>",
          },
        },
        definition = {
          edit = "<C-c>o",
          vsplit = "<C-c>v",
          split = "<C-c>i",
          tabe = "<C-c>t",
        },
        rename = {
          quit = "<C-c>",
          exec = "<CR>",
        },
        symbol_in_winbar = {
          enable = false, -- Disabled for mobile to save space
        },
        outline = {
          win_position = "right",
          win_with = "",
          win_width = math.min(30, math.floor(vim.o.columns * 0.3)),
          show_detail = true,
          auto_preview = true,
          auto_refresh = true,
          auto_close = true,
          custom_sort = nil,
          keys = {
            expand_or_jump = "o",
            quit = "q",
          },
        },
      })

      -- Mobile-friendly keymaps
      vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { desc = "LSP Finder" })
      vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code Action" })
      vim.keymap.set("v", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code Action" })
      vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "Rename" })
      vim.keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek Definition" })
      vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Goto Definition" })
      vim.keymap.set("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Show Line Diagnostics" })
      vim.keymap.set("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { desc = "Show Cursor Diagnostics" })
      vim.keymap.set("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>", { desc = "Show Buffer Diagnostics" })
      vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Previous Diagnostic" })
      vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next Diagnostic" })
      vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover Doc" })
      vim.keymap.set("n", "<A-d>", "<cmd>Lspsaga term_toggle<CR>", { desc = "Toggle Terminal" })
      vim.keymap.set("t", "<A-d>", "<cmd>Lspsaga term_toggle<CR>", { desc = "Toggle Terminal" })
      vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { desc = "Outline" })
      
      -- Android Volume Down shortcuts
      vim.keymap.set("n", "<M-ca>", "<cmd>Lspsaga code_action<CR>", { desc = "Code Action (Android)" })
      vim.keymap.set("n", "<M-rn>", "<cmd>Lspsaga rename<CR>", { desc = "Rename (Android)" })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
