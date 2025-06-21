-- ══════════════════════════════════════════════════════════════════════
-- File Explorer Configuration for Android/Termux
-- Optimized for touch navigation and mobile workflows
-- ══════════════════════════════════════════════════════════════════════

return {
  -- File explorer (mobile optimized)
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local icons = require("config.icons")
      
      -- Disable netrw at the very start of your init.lua
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        auto_reload_on_write = true,
        disable_netrw = false,
        hijack_netrw = true,
        hijack_cursor = false,
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
        reload_on_bufenter = false,
        respect_buf_cwd = false,
        
        -- Mobile optimizations
        view = {
          adaptive_size = true, -- Auto-adjust width based on content
          centralize_selection = false,
          width = function()
            -- Responsive width based on screen size
            local screen_width = vim.o.columns
            if screen_width < 80 then
              return math.max(25, math.floor(screen_width * 0.4))
            else
              return 30
            end
          end,
          height = 30,
          hide_root_folder = false,
          side = "left",
          preserve_window_proportions = false,
          number = false,
          relativenumber = false,
          signcolumn = "yes",
          mappings = {
            custom_only = false,
            list = {
              -- Mobile-friendly mappings
              { key = { "l", "<CR>", "o" }, action = "edit" },
              { key = "h", action = "close_node" },
              { key = "v", action = "vsplit" },
              { key = "s", action = "split" },
              { key = "t", action = "tabnew" },
              { key = "<", action = "prev_sibling" },
              { key = ">", action = "next_sibling" },
              { key = "P", action = "parent_node" },
              { key = "<BS>", action = "close_node" },
              { key = "<Tab>", action = "preview" },
              { key = "K", action = "first_sibling" },
              { key = "J", action = "last_sibling" },
              { key = "I", action = "toggle_git_ignored" },
              { key = "H", action = "toggle_dotfiles" },
              { key = "R", action = "refresh" },
              { key = "a", action = "create" },
              { key = "d", action = "remove" },
              { key = "D", action = "trash" },
              { key = "r", action = "rename" },
              { key = "<C-r>", action = "full_rename" },
              { key = "x", action = "cut" },
              { key = "c", action = "copy" },
              { key = "p", action = "paste" },
              { key = "y", action = "copy_name" },
              { key = "Y", action = "copy_path" },
              { key = "gy", action = "copy_absolute_path" },
              { key = "[c", action = "prev_git_item" },
              { key = "]c", action = "next_git_item" },
              { key = "-", action = "dir_up" },
              { key = "S", action = "search_node" },
              { key = ".", action = "run_file_command" },
              { key = "<C-k>", action = "toggle_file_info" },
              { key = "g?", action = "toggle_help" },
              { key = "m", action = "toggle_mark" },
              { key = "bmv", action = "bulk_move" },
            },
          },
          float = {
            enable = false,
            quit_on_focus_loss = true,
            open_win_config = {
              relative = "editor",
              border = "rounded",
              width = 30,
              height = 30,
              row = 1,
              col = 1,
            },
          },
        },
        
        renderer = {
          add_trailing = false,
          group_empty = false,
          highlight_git = true,
          full_name = false,
          highlight_opened_files = "none",
          root_folder_label = ":~:s?$?/..?",
          indent_width = 2,
          indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
              corner = "└",
              edge = "│",
              item = "│",
              bottom = "─",
              none = " ",
            },
          },
          icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            glyphs = {
              default = icons.file_icons.default,
              symlink = icons.file_icons.default,
              bookmark = "",
              folder = {
                arrow_closed = icons.ui.arrow_right,
                arrow_open = icons.ui.arrow_down,
                default = icons.file_icons.folder,
                open = icons.file_icons.folder_open,
                empty = icons.file_icons.folder_empty,
                empty_open = icons.file_icons.folder_empty_open,
                symlink = icons.file_icons.folder,
                symlink_open = icons.file_icons.folder_open,
              },
              git = {
                unstaged = icons.git.modified,
                staged = icons.git.staged,
                unmerged = icons.git.conflict,
                renamed = icons.git.renamed,
                untracked = icons.git.untracked,
                deleted = icons.git.deleted,
                ignored = icons.git.ignored,
              },
            },
          },
          special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "package.json" },
          symlink_destination = true,
        },
        
        hijack_directories = {
          enable = true,
          auto_open = true,
        },
        
        update_focused_file = {
          enable = true,
          update_root = false,
          ignore_list = {},
        },
        
        system_open = {
          cmd = "termux-open", -- Android-specific file opener
          args = {},
        },
        
        diagnostics = {
          enable = true,
          show_on_dirs = false,
          show_on_open_dirs = true,
          debounce_delay = 50,
          severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
          },
          icons = {
            hint = icons.diagnostics.Hint,
            info = icons.diagnostics.Info,
            warning = icons.diagnostics.Warning,
            error = icons.diagnostics.Error,
          },
        },
        
        filters = {
          dotfiles = false,
          git_clean = false,
          no_buffer = false,
          custom = {
            "node_modules",
            "\\.cache",
            "__pycache__",
          },
          exclude = {},
        },
        
        filesystem_watchers = {
          enable = true,
          debounce_delay = 50,
          ignore_dirs = {},
        },
        
        git = {
          enable = true,
          ignore = true,
          show_on_dirs = true,
          show_on_open_dirs = true,
          timeout = 400,
        },
        
        actions = {
          use_system_clipboard = true,
          change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
          },
          expand_all = {
            max_folder_discovery = 300,
            exclude = {},
          },
          file_popup = {
            open_win_config = {
              col = 1,
              row = 1,
              relative = "cursor",
              border = "shadow",
              style = "minimal",
            },
          },
          open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
              enable = true,
              picker = "default",
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
          remove_file = {
            close_window = true,
          },
        },
        
        trash = {
          cmd = "gio trash", -- Use system trash if available
          require_confirm = true,
        },
        
        live_filter = {
          prefix = "[FILTER]: ",
          always_show_folders = true,
        },
        
        tab = {
          sync = {
            open = false,
            close = false,
            ignore = {},
          },
        },
        
        notify = {
          threshold = vim.log.levels.INFO,
        },
        
        log = {
          enable = false,
          truncate = false,
          types = {
            all = false,
            config = false,
            copy_paste = false,
            dev = false,
            diagnostics = false,
            git = false,
            profile = false,
            watcher = false,
          },
        },
      })

      -- Mobile-friendly keymaps
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })
      vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<cr>", { desc = "Find file in explorer" })
      vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<cr>", { desc = "Refresh explorer" })
      vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<cr>", { desc = "Collapse explorer" })
      
      -- Auto-open nvim-tree when starting with a directory
      local function open_nvim_tree(data)
        local directory = vim.fn.isdirectory(data.file) == 1
        if not directory then
          return
        end
        vim.cmd.cd(data.file)
        require("nvim-tree.api").tree.open()
      end
      vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
    end,
  },

  -- File operations (mobile optimized)
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        columns = {
          "icon",
          "permissions",
          "size",
          "mtime",
        },
        buf_options = {
          buflisted = false,
          bufhidden = "hide",
        },
        win_options = {
          wrap = false,
          signcolumn = "no",
          cursorcolumn = false,
          foldcolumn = "0",
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = "nvic",
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        lsp_file_methods = {
          timeout_ms = 1000,
          autosave_changes = false,
        },
        constrain_cursor = "editable",
        experimental_watch_for_changes = false,
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = "actions.select_vsplit",
          ["<C-h>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
        use_default_keymaps = true,
        view_options = {
          show_hidden = false,
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".")
          end,
          is_always_hidden = function(name, bufnr)
            return false
          end,
          sort = {
            { "type", "asc" },
            { "name", "asc" },
          },
        },
        float = {
          padding = 2,
          max_width = 0,
          max_height = 0,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          override = function(conf)
            return conf
          end,
        },
        preview = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = 0.9,
          min_height = { 5, 0.1 },
          height = nil,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          update_on_cursor_moved = true,
        },
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          height = nil,
          border = "rounded",
          minimized_border = "none",
          win_options = {
            winblend = 0,
          },
        },
      })
      
      -- Keymap for oil
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Quick file switching
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})

      -- Mobile-friendly harpoon keymaps
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end, { desc = "Add file to harpoon" })
      vim.keymap.set("n", "<leader>he", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle harpoon menu" })

      -- Quick access to first 4 files (mobile optimized)
      vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Previous harpoon file" })
      vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Next harpoon file" })
    end,
  },
}
