-- ══════════════════════════════════════════════════════════════════════
-- Git Integration & Terminal Configuration
-- ══════════════════════════════════════════════════════════════════════

return {
  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous hunk" })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Stage hunk" })
          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Reset hunk" })
          map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = "Blame line" })
          map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
          map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end, { desc = "Diff this ~" })
          map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
        end,
      })
    end,
  },

  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
      vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
      vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- customize lazygit popup window border characters
      vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
      vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed

      vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is evaluated if this value is 1
      vim.g.lazygit_config_file_path = "" -- custom config file path
    end,
  },

  -- Git blame virtual text
  {
    "f-person/git-blame.nvim",
    config = function()
      require("gitblame").setup({
        enabled = false, -- Start disabled, toggle with GitBlameToggle
        message_template = " <summary> • <date> • <author>",
        date_format = "%r",
        virtual_text_column = nil,
        highlight_group = "Comment",
        set_extmark_options = {},
        display_virtual_text = true,
        ignored_filetypes = {
          "lua",
          "help",
          "alpha",
          "dashboard",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        delay = 1000,
      })
    end,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        autochdir = false,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        auto_scroll = true,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
        winbar = {
          enabled = false,
          name_formatter = function(term)
            return term.name
          end,
        },
      })

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end

      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      -- Custom terminal functions
      local Terminal = require("toggleterm.terminal").Terminal

      -- LazyGit terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "double",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      -- Node terminal
      local node = Terminal:new({
        cmd = "node",
        direction = "horizontal",
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _NODE_TOGGLE()
        node:toggle()
      end

      -- Python terminal
      local python = Terminal:new({
        cmd = "python",
        direction = "horizontal",
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _PYTHON_TOGGLE()
        python:toggle()
      end

      -- PowerShell terminal
      local powershell = Terminal:new({
        cmd = "pwsh.exe",
        direction = "horizontal",
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _POWERSHELL_TOGGLE()
        powershell:toggle()
      end

      -- Keymaps
      vim.keymap.set("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "LazyGit" })
      vim.keymap.set("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>", { desc = "Node terminal" })
      vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Python terminal" })
      vim.keymap.set("n", "<leader>ts", "<cmd>lua _POWERSHELL_TOGGLE()<CR>", { desc = "PowerShell terminal" })
    end,
  },

  -- Diff view
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup({
        diff_binaries = false,
        enhanced_diff_hl = false,
        git_cmd = { "git" },
        use_icons = true,
        show_help_hints = true,
        watch_index = true,
        icons = {
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
          done = "✓",
        },
        view = {
          default = {
            layout = "diff2_horizontal",
          },
          merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
          },
          file_history = {
            layout = "diff2_horizontal",
          },
        },
        file_panel = {
          listing_style = "tree",
          tree_options = {
            flatten_dirs = true,
            folder_statuses = "only_folded",
          },
          win_config = {
            position = "left",
            width = 35,
            win_opts = {},
          },
        },
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = "combined",
              },
              multi_file = {
                diff_merges = "first-parent",
              },
            },
          },
          win_config = {
            position = "bottom",
            height = 16,
            win_opts = {},
          },
        },
        commit_log_panel = {
          win_config = {
            win_opts = {},
          },
        },
        default_args = {
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {},
        keymaps = {
          disable_defaults = false,
          view = {
            ["<tab>"] = require("diffview.actions").select_next_entry,
            ["<s-tab>"] = require("diffview.actions").select_prev_entry,
            ["gf"] = require("diffview.actions").goto_file,
            ["<C-w><C-f>"] = require("diffview.actions").goto_file_split,
            ["<C-w>gf"] = require("diffview.actions").goto_file_tab,
            ["<leader>e"] = require("diffview.actions").focus_files,
            ["<leader>b"] = require("diffview.actions").toggle_files,
            ["g<C-x>"] = require("diffview.actions").cycle_layout,
            ["[x"] = require("diffview.actions").prev_conflict,
            ["]x"] = require("diffview.actions").next_conflict,
          },
          diff1 = {
            ["g?"] = require("diffview.actions").help,
          },
          diff2 = {
            ["g?"] = require("diffview.actions").help,
          },
          diff3 = {
            {
              { "n", "x" },
              "2do",
              require("diffview.actions").diffget("ours"),
              { desc = "Obtain the diff hunk from the OURS version of the file" },
            },
            {
              { "n", "x" },
              "3do",
              require("diffview.actions").diffget("theirs"),
              { desc = "Obtain the diff hunk from the THEIRS version of the file" },
            },
            ["g?"] = require("diffview.actions").help,
          },
          diff4 = {
            {
              { "n", "x" },
              "1do",
              require("diffview.actions").diffget("base"),
              { desc = "Obtain the diff hunk from the BASE version of the file" },
            },
            {
              { "n", "x" },
              "2do",
              require("diffview.actions").diffget("ours"),
              { desc = "Obtain the diff hunk from the OURS version of the file" },
            },
            {
              { "n", "x" },
              "3do",
              require("diffview.actions").diffget("theirs"),
              { desc = "Obtain the diff hunk from the THEIRS version of the file" },
            },
            ["g?"] = require("diffview.actions").help,
          },
          file_panel = {
            ["j"] = require("diffview.actions").next_entry,
            ["<down>"] = require("diffview.actions").next_entry,
            ["k"] = require("diffview.actions").prev_entry,
            ["<up>"] = require("diffview.actions").prev_entry,
            ["<cr>"] = require("diffview.actions").select_entry,
            ["o"] = require("diffview.actions").select_entry,
            ["<2-LeftMouse>"] = require("diffview.actions").select_entry,
            ["-"] = require("diffview.actions").toggle_stage_entry,
            ["S"] = require("diffview.actions").stage_all,
            ["U"] = require("diffview.actions").unstage_all,
            ["X"] = require("diffview.actions").restore_entry,
            ["L"] = require("diffview.actions").open_commit_log,
            ["<c-b>"] = require("diffview.actions").scroll_view(-0.25),
            ["<c-f>"] = require("diffview.actions").scroll_view(0.25),
            ["<tab>"] = require("diffview.actions").select_next_entry,
            ["<s-tab>"] = require("diffview.actions").select_prev_entry,
            ["gf"] = require("diffview.actions").goto_file,
            ["<C-w><C-f>"] = require("diffview.actions").goto_file_split,
            ["<C-w>gf"] = require("diffview.actions").goto_file_tab,
            ["i"] = require("diffview.actions").listing_style,
            ["f"] = require("diffview.actions").toggle_flatten_dirs,
            ["R"] = require("diffview.actions").refresh_files,
            ["<leader>e"] = require("diffview.actions").focus_files,
            ["<leader>b"] = require("diffview.actions").toggle_files,
            ["g<C-x>"] = require("diffview.actions").cycle_layout,
            ["[x"] = require("diffview.actions").prev_conflict,
            ["]x"] = require("diffview.actions").next_conflict,
            ["g?"] = require("diffview.actions").help,
          },
          file_history_panel = {
            ["g!"] = require("diffview.actions").options,
            ["<C-A-d>"] = require("diffview.actions").open_in_diffview,
            ["y"] = require("diffview.actions").copy_hash,
            ["L"] = require("diffview.actions").open_commit_log,
            ["zR"] = require("diffview.actions").open_all_folds,
            ["zM"] = require("diffview.actions").close_all_folds,
            ["j"] = require("diffview.actions").next_entry,
            ["<down>"] = require("diffview.actions").next_entry,
            ["k"] = require("diffview.actions").prev_entry,
            ["<up>"] = require("diffview.actions").prev_entry,
            ["<cr>"] = require("diffview.actions").select_entry,
            ["o"] = require("diffview.actions").select_entry,
            ["<2-LeftMouse>"] = require("diffview.actions").select_entry,
            ["<c-b>"] = require("diffview.actions").scroll_view(-0.25),
            ["<c-f>"] = require("diffview.actions").scroll_view(0.25),
            ["<tab>"] = require("diffview.actions").select_next_entry,
            ["<s-tab>"] = require("diffview.actions").select_prev_entry,
            ["gf"] = require("diffview.actions").goto_file,
            ["<C-w><C-f>"] = require("diffview.actions").goto_file_split,
            ["<C-w>gf"] = require("diffview.actions").goto_file_tab,
            ["<leader>e"] = require("diffview.actions").focus_files,
            ["<leader>b"] = require("diffview.actions").toggle_files,
            ["g<C-x>"] = require("diffview.actions").cycle_layout,
            ["g?"] = require("diffview.actions").help,
          },
          option_panel = {
            ["<tab>"] = require("diffview.actions").select_entry,
            ["q"] = require("diffview.actions").close,
          },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Diffview Open" })
      vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<CR>", { desc = "Diffview File History" })
      vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<CR>", { desc = "Diffview Close" })
    end,
  },
}
