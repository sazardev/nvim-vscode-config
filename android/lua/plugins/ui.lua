-- ══════════════════════════════════════════════════════════════════════
-- UI Configuration for Android/Termux
-- Optimized theme and interface for mobile devices
-- ══════════════════════════════════════════════════════════════════════

return {
  -- Tokyo Night theme (mobile optimized)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- storm, moon, night, day
        transparent = false, -- Better visibility on mobile
        terminal_colors = true,
        styles = {
          comments = { italic = false }, -- Disable italics for better mobile readability
          keywords = { italic = false },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help", "terminal", "packer" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false, -- Better for mobile
        
        -- Mobile optimizations
        on_colors = function(colors)
          -- Adjust colors for better mobile visibility
          colors.bg_highlight = "#2d3149"
          colors.bg_visual = "#364A82"
        end,
        
        on_highlights = function(highlights, colors)
          -- Optimize highlights for mobile screens
          highlights.CursorLine = { bg = colors.bg_highlight }
          highlights.Visual = { bg = colors.bg_visual }
          
          -- Make diagnostics more visible on small screens
          highlights.DiagnosticError = { fg = colors.red, bold = true }
          highlights.DiagnosticWarn = { fg = colors.yellow, bold = true }
          highlights.DiagnosticInfo = { fg = colors.blue, bold = true }
          highlights.DiagnosticHint = { fg = colors.cyan, bold = true }
        end,
      })
      
      vim.cmd("colorscheme tokyonight")
    end,
  },

  -- Status line (mobile optimized)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local icons = require("config.icons")
      
      -- Check screen width for mobile optimization
      local screen_width = vim.o.columns
      local is_narrow = screen_width < 80
      
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = is_narrow and "" or { left = "", right = "" },
          section_separators = is_narrow and "" or { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true, -- Single statusline for all windows
          refresh = {
            statusline = 1000, -- Reduced refresh rate for battery
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                -- Shorter mode names for mobile
                if is_narrow then
                  return str:sub(1, 1)
                end
                return str
              end
            }
          },
          lualine_b = {
            {
              "branch",
              icon = icons.git.branch,
              fmt = function(str)
                -- Truncate branch name on narrow screens
                if is_narrow and #str > 10 then
                  return str:sub(1, 7) .. "..."
                end
                return str
              end
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.deleted
              },
            }
          },
          lualine_c = {
            {
              "filename",
              file_status = true,
              newfile_status = false,
              path = is_narrow and 0 or 1, -- Show only filename on narrow screens
              shorting_target = 40,
              symbols = {
                modified = icons.statusline.modified,
                readonly = icons.statusline.readonly,
                unnamed = "[No Name]",
                newfile = "[New]",
              }
            }
          },
          lualine_x = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
              colored = true,
              update_in_insert = false,
              always_visible = false,
            },
            {
              "encoding",
              cond = function()
                return not is_narrow -- Hide encoding on narrow screens
              end
            },
            {
              "fileformat",
              symbols = {
                unix = "LF",
                dos = "CRLF",
                mac = "CR",
              },
              cond = function()
                return not is_narrow -- Hide file format on narrow screens
              end
            },
            "filetype"
          },
          lualine_y = {
            {
              "progress",
              fmt = function(str)
                -- Shorter progress indicator for mobile
                if is_narrow then
                  return str:gsub("%%", "")
                end
                return str
              end
            }
          },
          lualine_z = {
            {
              "location",
              fmt = function(str)
                -- Compact location format for mobile
                if is_narrow then
                  local line, col = str:match("(%d+):(%d+)")
                  if line and col then
                    return line .. ":" .. col
                  end
                end
                return str
              end
            }
          }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { "nvim-tree", "toggleterm", "quickfix" }
      })
    end,
  },

  -- Buffer line (mobile optimized)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      local icons = require("config.icons")
      
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = {
            icon = "▎",
            style = "icon",
          },
          buffer_close_icon = icons.ui.close,
          modified_icon = icons.statusline.modified,
          close_icon = icons.ui.close,
          left_trunc_marker = icons.ui.arrow_left,
          right_trunc_marker = icons.ui.arrow_right,
          
          -- Mobile optimizations
          max_name_length = vim.o.columns < 80 and 10 or 18,
          max_prefix_length = vim.o.columns < 80 and 8 or 15,
          tab_size = vim.o.columns < 80 and 12 or 18,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and icons.diagnostics.Error or
                        level:match("warning") and icons.diagnostics.Warn or
                        icons.diagnostics.Info
            return " " .. icon .. count
          end,
          
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = false, -- Disabled for mobile to save space
          show_close_icon = false,
          show_tab_indicators = true,
          persist_buffer_sort = true,
          separator_style = "thin",
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          
          -- Mobile touch optimizations
          sort_by = "id",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true
            }
          },
        },
        highlights = require("tokyonight.extras.bufferline"),
      })
      
      -- Mobile-friendly buffer navigation
      vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
      vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
      vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pin buffer" })
      vim.keymap.set("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", { desc = "Close unpinned buffers" })
    end,
  },

  -- Dashboard (mobile optimized)
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      local icons = require("config.icons")
      
      -- Mobile-friendly ASCII art (smaller)
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
        "            [ Android/Termux Edition ]               ",
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", icons.file_icons.default .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("e", icons.plugins.explorer .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", icons.ui.clock .. " Recently used files", ":Telescope oldfiles <CR>"),
        dashboard.button("t", icons.ui.search .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", icons.ui.settings .. " Configuration", ":e $MYVIMRC <CR>"),
        dashboard.button("u", icons.plugins.package .. " Update plugins", ":Lazy update<CR>"),
        dashboard.button("q", icons.ui.close .. " Quit Neovim", ":qa<CR>"),
      }

      local function footer()
        local total_plugins = require("lazy").stats().count
        local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
        local version = vim.version()
        local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

        return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info .. " on Android"
      end

      dashboard.section.footer.val = footer()

      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"

      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)
      
      -- Auto-open dashboard when starting without file
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = footer() .. "   startup: " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  -- Indent guides (simplified for mobile)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = { 
          enabled = true,
          show_start = false,
          show_end = false,
        },
        exclude = {
          filetypes = {
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
        },
      })
    end,
  },

  -- Notifications (mobile optimized)
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
        fps = 15, -- Reduced for battery life
        icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "",
          TRACE = "✎",
          WARN = "",
        },
        level = 2,
        minimum_width = 30, -- Smaller for mobile
        render = "default",
        stages = "fade_in_slide_out",
        timeout = 2000, -- Shorter timeout for mobile
        top_down = true,
        max_width = function()
          return math.floor(vim.o.columns * 0.75) -- 75% of screen width
        end,
        max_height = function()
          return math.floor(vim.o.lines * 0.75) -- 75% of screen height
        end,
      })
      
      vim.notify = require("notify")
    end,
  },

  -- Better UI components
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "Input:",
          prompt_align = "left",
          insert_only = true,
          start_in_insert = true,
          anchor = "SW",
          border = "rounded",
          relative = "cursor",
          prefer_width = 40,
          width = nil,
          max_width = { 140, 0.9 },
          min_width = { 20, 0.2 },
          buf_options = {},
          win_options = {
            winblend = 10,
            wrap = false,
          },
          mappings = {
            n = {
              ["<Esc>"] = "Close",
              ["<CR>"] = "Confirm",
            },
            i = {
              ["<C-c>"] = "Close",
              ["<CR>"] = "Confirm",
              ["<Up>"] = "HistoryPrev",
              ["<Down>"] = "HistoryNext",
            },
          },
        },
        select = {
          enabled = true,
          backend = { "telescope", "builtin", "nui" },
          trim_prompt = true,
          telescope = require("telescope.themes").get_dropdown({
            layout_config = {
              width = function(_, max_columns, _)
                return math.min(max_columns, 80)
              end,
              height = function(_, _, max_lines)
                return math.min(max_lines, 15)
              end,
            },
          }),
        },
      })
    end,
  },

  -- Highlight colors (simplified for mobile)
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "*", -- Enable for all filetypes
      }, {
        RGB = true,
        RRGGBB = true,
        names = false, -- Disable named colors for performance
        RRGGBBAA = false, -- Disable alpha for performance
        css = false, -- Disable CSS features for performance
        css_fn = false,
        mode = "background",
      })
    end,
  },

  -- Smooth scrolling (battery optimized)
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        mappings = {"<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb"},
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = "linear", -- Simpler easing for better performance
        pre_hook = nil,
        post_hook = nil,
        performance_mode = true, -- Enable performance mode for mobile
      })
    end,
  },
}
