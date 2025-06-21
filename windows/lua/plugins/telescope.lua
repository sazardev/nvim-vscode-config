-- ══════════════════════════════════════════════════════════════════════
-- Telescope Configuration (Fuzzy Finder)
-- ══════════════════════════════════════════════════════════════════════

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local trouble = require("trouble.providers.telescope")

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          file_ignore_patterns = { ".git/", "node_modules" },
          
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-t>"] = trouble.open_with_trouble,
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
            n = {
              ["<C-t>"] = trouble.open_with_trouble,
            },
          },
          
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          
          sorting_strategy = "ascending",
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          use_less = true,
          set_env = { ["COLORTERM"] = "truecolor" },
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        },
        
        pickers = {
          find_files = {
            theme = "dropdown",
            previewer = false,
            hidden = true,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
            initial_mode = "normal",
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
          planets = {
            show_pluto = true,
            show_moon = true,
          },
          colorscheme = {
            enable_preview = true,
          },
          lsp_references = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_definitions = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_declarations = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_implementations = {
            theme = "dropdown",
            initial_mode = "normal",
          },
        },
        
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      -- Load extensions
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      
      -- Custom functions
      local builtin = require("telescope.builtin")
      
      -- Git files or find files
      vim.keymap.set("n", "<C-p>", function()
        local git_files = vim.fn.systemlist("git ls-files")
        if vim.v.shell_error == 0 and #git_files > 0 then
          builtin.git_files()
        else
          builtin.find_files()
        end
      end, { desc = "Find files (git aware)" })
      
      -- Search in current buffer
      vim.keymap.set("n", "<leader>sb", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "Search in current buffer" })
      
      -- Search help tags
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search help" })
      
      -- Search keymaps
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
      
      -- Search for files with specific extensions
      vim.keymap.set("n", "<leader>sj", function()
        builtin.find_files({ find_command = { "fd", "-e", "js", "-e", "ts", "-e", "jsx", "-e", "tsx" } })
      end, { desc = "Search JS/TS files" })
      
      vim.keymap.set("n", "<leader>sp", function()
        builtin.find_files({ find_command = { "fd", "-e", "py" } })
      end, { desc = "Search Python files" })
      
      vim.keymap.set("n", "<leader>sg", function()
        builtin.find_files({ find_command = { "fd", "-e", "go" } })
      end, { desc = "Search Go files" })
      
      -- Resume last search
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume last search" })
      
      -- Search for word under cursor
      vim.keymap.set("n", "<leader>sw", function()
        builtin.grep_string({ search = vim.fn.expand("<cword>") })
      end, { desc = "Search word under cursor" })
      
      -- Search for visual selection
      vim.keymap.set("v", "<leader>sw", function()
        local text = vim.fn.getregion(vim.fn.getpos("'<"), vim.fn.getpos("'>"), { type = vim.fn.mode() })
        builtin.grep_string({ search = table.concat(text, "\n") })
      end, { desc = "Search selection" })
      
      -- Search in git commits
      vim.keymap.set("n", "<leader>sc", builtin.git_commits, { desc = "Search commits" })
      
      -- Search in git branches
      vim.keymap.set("n", "<leader>sb", builtin.git_branches, { desc = "Search branches" })
      
      -- Search colorschemes
      vim.keymap.set("n", "<leader>st", builtin.colorscheme, { desc = "Search themes" })
    end,
  },
  
  -- Trouble for better quickfix/location list
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      position = "bottom",
      height = 10,
      width = 50,
      icons = true,
      mode = "workspace_diagnostics",
      severity = nil,
      fold_open = "",
      fold_closed = "",
      group = true,
      padding = true,
      action_keys = {
        close = "q",
        cancel = "<esc>",
        refresh = "r",
        jump = { "<cr>", "<tab>" },
        open_split = { "<c-x>" },
        open_vsplit = { "<c-v>" },
        open_tab = { "<c-t>" },
        jump_close = { "o" },
        toggle_mode = "m",
        toggle_preview = "P",
        hover = "K",
        preview = "p",
        close_folds = { "zM", "zm" },
        open_folds = { "zR", "zr" },
        toggle_fold = { "zA", "za" },
        previous = "k",
        next = "j",
      },
      indent_lines = true,
      auto_open = false,
      auto_close = false,
      auto_preview = true,
      auto_fold = false,
      auto_jump = { "lsp_definitions" },
      signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠",
      },
      use_diagnostic_signs = false,
    },
  },
}
