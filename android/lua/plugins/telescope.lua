-- ══════════════════════════════════════════════════════════════════════
-- Telescope Configuration for Android/Termux
-- Fuzzy finder optimized for mobile screens and touch navigation
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
      local icons = require("config.icons")
      
      -- Mobile screen detection
      local screen_width = vim.o.columns
      local screen_height = vim.o.lines
      local is_mobile = screen_width < 100
      
      telescope.setup({
        defaults = {
          prompt_prefix = icons.ui.search .. " ",
          selection_caret = icons.ui.arrow_right .. " ",
          path_display = is_mobile and { "tail" } or { "truncate" },
          file_ignore_patterns = { 
            ".git/", 
            "node_modules/",
            "%.cache/",
            "__pycache__/",
            "%.apk",
            "%.dex",
            "build/",
            "dist/",
          },
          
          mappings = {
            i = {
              -- Mobile-friendly mappings
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-u>"] = false,
              ["<C-d>"] = false,
              ["<Esc>"] = actions.close,
              ["<C-c>"] = actions.close,
              
              -- Android specific mappings
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<M-a>"] = actions.select_all,
              ["<M-t>"] = actions.select_tab,
              ["<M-v>"] = actions.select_vertical,
              ["<M-h>"] = actions.select_horizontal,
            },
            n = {
              ["q"] = actions.close,
              ["<Esc>"] = actions.close,
              ["<C-c>"] = actions.close,
            },
          },
          
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = is_mobile and 0.4 or 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
              prompt_position = "top",
              preview_height = is_mobile and 0.3 or 0.4,
            },
            width = is_mobile and 0.95 or 0.87,
            height = is_mobile and 0.90 or 0.80,
            preview_cutoff = is_mobile and 60 : 120,
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
          
          -- Performance optimizations for mobile
          cache_picker = {
            num_pickers = is_mobile and 5 or 10,
            limit_entries = is_mobile and 500 or 1000,
          },
        },
        
        pickers = {
          find_files = {
            theme = is_mobile and "dropdown" or "ivy",
            previewer = not is_mobile,
            hidden = true,
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
          },
          
          live_grep = {
            theme = is_mobile and "ivy" or nil,
            additional_args = function()
              return { "--hidden" }
            end,
          },
          
          buffers = {
            theme = "dropdown",
            previewer = false,
            initial_mode = "normal",
            sort_lastused = true,
            sort_mru = true,
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
                ["<Del>"] = actions.delete_buffer,
              },
            },
          },
          
          oldfiles = {
            theme = is_mobile and "dropdown" or "ivy",
            previewer = not is_mobile,
          },
          
          help_tags = {
            theme = "ivy",
            previewer = true,
          },
          
          commands = {
            theme = "dropdown",
            previewer = false,
          },
          
          keymaps = {
            theme = "dropdown",
            previewer = false,
          },
          
          -- LSP pickers (mobile optimized)
          lsp_references = {
            theme = "dropdown",
            initial_mode = "normal",
            show_line = false,
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
          
          lsp_type_definitions = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          
          diagnostics = {
            theme = "ivy",
            initial_mode = "normal",
            line_width = "full",
          },
          
          -- Git pickers
          git_files = {
            theme = is_mobile and "dropdown" or "ivy",
            previewer = not is_mobile,
            show_untracked = true,
          },
          
          git_commits = {
            theme = "ivy",
          },
          
          git_bcommits = {
            theme = "ivy",
          },
          
          git_branches = {
            theme = "dropdown",
            previewer = false,
          },
          
          git_status = {
            theme = "ivy",
            initial_mode = "normal",
          },
          
          -- Colorscheme picker
          colorscheme = {
            theme = "dropdown",
            enable_preview = true,
            previewer = false,
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
            require("telescope.themes").get_dropdown({
              winblend = 10,
              layout_config = {
                width = function(_, max_columns, _)
                  return math.min(max_columns, is_mobile and 60 or 80)
                end,
                height = function(_, _, max_lines)
                  return math.min(max_lines, is_mobile and 10 or 15)
                end,
              },
            }),
          },
        },
      })

      -- Load extensions
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      
      -- Custom functions
      local builtin = require("telescope.builtin")
      
      -- Smart file finder (git-aware)
      vim.keymap.set("n", "<C-p>", function()
        local git_files = vim.fn.systemlist("git ls-files --cached --others --exclude-standard")
        if vim.v.shell_error == 0 and #git_files > 0 then
          builtin.git_files()
        else
          builtin.find_files()
        end
      end, { desc = "Find files (git aware)" })
      
      -- Mobile-optimized search in current buffer
      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
          layout_config = {
            width = is_mobile and 0.9 or 0.6,
            height = is_mobile and 0.7 or 0.5,
          },
        }))
      end, { desc = "Search in current buffer" })
      
      -- Quick access shortcuts
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
      vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Commands" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Key maps" })
      vim.keymap.set("n", "<leader>ft", builtin.colorscheme, { desc = "Themes" })
      
      -- Search by file type (mobile shortcuts)
      vim.keymap.set("n", "<leader>sj", function()
        builtin.find_files({ 
          find_command = { "fd", "-e", "js", "-e", "ts", "-e", "jsx", "-e", "tsx" } 
        })
      end, { desc = "Search JS/TS files" })
      
      vim.keymap.set("n", "<leader>sp", function()
        builtin.find_files({ find_command = { "fd", "-e", "py" } })
      end, { desc = "Search Python files" })
      
      vim.keymap.set("n", "<leader>sg", function()
        builtin.find_files({ find_command = { "fd", "-e", "go" } })
      end, { desc = "Search Go files" })
      
      vim.keymap.set("n", "<leader>sm", function()
        builtin.find_files({ find_command = { "fd", "-e", "md" } })
      end, { desc = "Search Markdown files" })
      
      -- Advanced search
      vim.keymap.set("n", "<leader>sw", function()
        builtin.grep_string({ search = vim.fn.expand("<cword>") })
      end, { desc = "Search word under cursor" })
      
      vim.keymap.set("v", "<leader>sw", function()
        local text = vim.fn.getregion(vim.fn.getpos("'<"), vim.fn.getpos("'>"), { type = vim.fn.mode() })
        builtin.grep_string({ search = table.concat(text, "\n") })
      end, { desc = "Search selection" })
      
      -- Resume last search
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume last search" })
      
      -- Git integration
      vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Git files" })
      vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
      vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
      vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
      
      -- LSP integration
      vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to definition" })
      vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Find references" })
      vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "Go to implementation" })
      vim.keymap.set("n", "gt", builtin.lsp_type_definitions, { desc = "Go to type definition" })
      vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "Document symbols" })
      vim.keymap.set("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })
      vim.keymap.set("n", "<leader>dd", builtin.diagnostics, { desc = "Diagnostics" })
      
      -- Android-specific Volume Down shortcuts
      vim.keymap.set("n", "<M-f>", builtin.find_files, { desc = "Find files (Android)" })
      vim.keymap.set("n", "<M-g>", builtin.live_grep, { desc = "Live grep (Android)" })
      vim.keymap.set("n", "<M-o>", builtin.oldfiles, { desc = "Recent files (Android)" })
      vim.keymap.set("n", "<M-CR>", builtin.commands, { desc = "Command palette (Android)" })
    end,
  },

  -- File browser integration
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").load_extension("file_browser")
      
      vim.keymap.set("n", "<leader>fe", ":Telescope file_browser<CR>", { desc = "File browser" })
      vim.keymap.set("n", "<leader>fE", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { desc = "File browser (current dir)" })
    end,
  },

  -- Project management
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        manual_mode = false,
        detection_methods = { "lsp", "pattern" },
        patterns = { 
          ".git", 
          "_darcs", 
          ".hg", 
          ".bzr", 
          ".svn", 
          "Makefile", 
          "package.json",
          "go.mod",
          "Cargo.toml",
          "requirements.txt",
          "setup.py",
          "build.gradle",
        },
        ignore_lsp = {},
        exclude_dirs = {
          "~/Downloads/*",
          "/tmp/*",
          "/data/data/com.termux/files/usr/tmp/*"
        },
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = "global",
        datapath = vim.fn.stdpath("data"),
      })
      
      require("telescope").load_extension("projects")
      
      vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Find Projects" })
    end,
  },

  -- Enhanced search and replace
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      { "<leader>S", function() require("spectre").toggle() end, desc = "Replace in files (Spectre)" },
    },
  },
}
