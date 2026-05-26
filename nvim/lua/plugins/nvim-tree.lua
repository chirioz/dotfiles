-- nvim-tree.lua
-- Coloca este archivo en: ~/.config/nvim/lua/plugins/nvim-tree.lua
-- (o donde sea que cargues tus plugins con lazy.nvim / packer)

-- Deshabilita netrw desde el inicio (requerido por nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Termcolors para los íconos (requiere una Nerd Font)
vim.opt.termguicolors = true

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local nvimtree = require("nvim-tree")

    nvimtree.setup({

      -- ── Apariencia ───────────────────────────────────────────────────────
      hijack_cursor = true,          -- El cursor siempre al primer carácter del nombre
      sync_root_with_cwd = true,     -- La raíz del árbol sigue el cwd de neovim
      respect_buf_cwd = true,        -- Al abrir un buffer, actualiza la raíz
      update_focused_file = {
        enable = true,
        update_root = false,         -- No cambia la raíz al enfocar un archivo
        ignore_list = {},
      },

      -- ── Comportamiento de la ventana ─────────────────────────────────────
      view = {
        width = 35,
        side = "left",
        preserve_window_proportions = true,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
      },

      -- ── Renderizado ───────────────────────────────────────────────────────
      renderer = {
        add_trailing = false,         -- No agrega "/" al final de carpetas
        group_empty = true,           -- Agrupa carpetas vacías en una sola línea
        highlight_git = true,
        full_name = false,
        highlight_opened_files = "name",
        root_folder_label = ":~:s?$?/..?", -- Muestra la ruta relativa al home

        indent_width = 2,
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge   = "│",
            item   = "│",
            bottom = "─",
            none   = " ",
          },
        },

        icons = {
          webdev_colors = true,
          git_placement = "before",
          padding = " ",
          symlink_arrow = " ➛ ",
          show = {
            file        = true,
            folder      = true,
            folder_arrow = true,
            git         = true,
          },
          glyphs = {
            default  = "",
            symlink  = "",
            bookmark = "󰆤",
            folder = {
              arrow_closed = "",
              arrow_open   = "",
              default      = "",
              open         = "",
              empty        = "",
              empty_open   = "",
              symlink      = "",
              symlink_open = "",
            },
            git = {
              unstaged  = "✗",
              staged    = "✓",
              unmerged  = "",
              renamed   = "➜",
              untracked = "★",
              deleted   = "",
              ignored   = "◌",
            },
          },
        },

        special_files = {
          "Cargo.toml",
          "Makefile",
          "README.md",
          "readme.md",
          ".env",
          "docker-compose.yml",
          "package.json",
        },
      },

      -- ── Filtros ───────────────────────────────────────────────────────────
      filters = {
        dotfiles = false,              -- Muestra dotfiles (puedes togglarlo con `H`)
        git_clean = false,
        no_buffer = false,
        custom = {
          "^.git$",                    -- Oculta la carpeta .git
          "node_modules",
          ".DS_Store",
          "__pycache__",
          ".pytest_cache",
          ".mypy_cache",
        },
        exclude = {},
      },

      -- ── Git ───────────────────────────────────────────────────────────────
      git = {
        enable = true,
        ignore = true,                 -- Oculta archivos en .gitignore
        show_on_dirs = true,
        show_on_open_dirs = true,
        timeout = 400,
      },

      -- ── Acciones ──────────────────────────────────────────────────────────
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = false,
          restrict_above_cwd = false,
        },
        expand_all = {
          max_folder_discovery = 300,
          exclude = { ".git", "node_modules", ".venv" },
        },
        file_popup = {
          open_win_config = {
            col = 1,
            row = 1,
            relative = "cursor",
            border = "rounded",
            style = "minimal",
          },
        },
        open_file = {
          quit_on_open = false,        -- No cierra nvim-tree al abrir un archivo
          resize_window = true,
          window_picker = {
            enable = true,
            picker = "default",
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype  = { "nofile", "terminal", "help" },
            },
          },
        },
        remove_file = {
          close_window = true,
        },
      },

      -- ── Diagnósticos (LSP) ────────────────────────────────────────────────
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        debounce_delay = 50,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
        icons = {
          hint    = "",
          info    = "",
          warning = "",
          error   = "",
        },
      },

      -- ── Papelera ─────────────────────────────────────────────────────────
      trash = {
        cmd = "gio trash",             -- Usa gio en Linux; cambia a "trash" si usas macOS
      },

      -- ── Live filter ──────────────────────────────────────────────────────
      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = false,
      },

      -- ── Notificaciones ───────────────────────────────────────────────────
      notify = {
        threshold = vim.log.levels.INFO,
        absolute_path = true,
      },

      -- ── UI ───────────────────────────────────────────────────────────────
      ui = {
        confirm = {
          remove = true,
          trash  = true,
        },
      },

      -- ── Keymaps dentro del árbol ──────────────────────────────────────────
      -- Documentación completa: :help nvim-tree-default-mappings
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        -- Carga los keymaps por defecto primero
        api.config.mappings.default_on_attach(bufnr)

        -- ── Navegación ──────────────────────────────────────────────────────
        vim.keymap.set("n", "l",     api.node.open.edit,            opts("Abrir"))
        vim.keymap.set("n", "<CR>",  api.node.open.edit,            opts("Abrir"))
        vim.keymap.set("n", "h",     api.node.navigate.parent_close, opts("Cerrar nodo padre"))
        vim.keymap.set("n", "H",     api.tree.collapse_all,          opts("Colapsar todo"))
        vim.keymap.set("n", "E",     api.tree.expand_all,            opts("Expandir todo"))

        -- ── Abrir en splits / tabs ───────────────────────────────────────────
        vim.keymap.set("n", "v",  api.node.open.vertical,   opts("Abrir split vertical"))
        vim.keymap.set("n", "s",  api.node.open.horizontal, opts("Abrir split horizontal"))
        vim.keymap.set("n", "t",  api.node.open.tab,        opts("Abrir en tab"))

        -- ── Archivos ─────────────────────────────────────────────────────────
        vim.keymap.set("n", "a",  api.fs.create,  opts("Crear archivo/carpeta"))
        vim.keymap.set("n", "d",  api.fs.trash,   opts("Papelera"))
        vim.keymap.set("n", "D",  api.fs.remove,  opts("Eliminar definitivamente"))
        vim.keymap.set("n", "r",  api.fs.rename,  opts("Renombrar"))
        vim.keymap.set("n", "x",  api.fs.cut,     opts("Cortar"))
        vim.keymap.set("n", "c",  api.fs.copy.node, opts("Copiar"))
        vim.keymap.set("n", "p",  api.fs.paste,   opts("Pegar"))
        vim.keymap.set("n", "y",  api.fs.copy.filename,          opts("Copiar nombre"))
        vim.keymap.set("n", "Y",  api.fs.copy.relative_path,     opts("Copiar ruta relativa"))
        vim.keymap.set("n", "gy", api.fs.copy.absolute_path,     opts("Copiar ruta absoluta"))

        -- ── Filtros y búsqueda ───────────────────────────────────────────────
        vim.keymap.set("n", "f",  api.live_filter.start,  opts("Filtrar"))
        vim.keymap.set("n", "F",  api.live_filter.clear,  opts("Limpiar filtro"))
        vim.keymap.set("n", ".",  api.node.run.cmd,        opts("Ejecutar comando"))
        vim.keymap.set("n", "S",  api.tree.search_node,   opts("Buscar nodo"))

        -- ── Vista ─────────────────────────────────────────────────────────────
        vim.keymap.set("n", "R",  api.tree.reload,        opts("Recargar"))
        vim.keymap.set("n", "I",  api.tree.toggle_gitignore_filter, opts("Toggle gitignore"))
        vim.keymap.set("n", "gh", api.tree.toggle_hidden_filter,    opts("Toggle dotfiles"))
        vim.keymap.set("n", "U",  api.tree.toggle_custom_filter,    opts("Toggle filtros custom"))
        vim.keymap.set("n", "q",  api.tree.close,         opts("Cerrar"))
        vim.keymap.set("n", "?",  api.tree.toggle_help,  opts("Ayuda"))

        -- ── Marcadores ────────────────────────────────────────────────────────
        vim.keymap.set("n", "m",   api.marks.toggle,           opts("Toggle marcador"))
        vim.keymap.set("n", "bmv", api.marks.bulk.move,        opts("Mover marcados"))
        vim.keymap.set("n", "btd", api.marks.bulk.trash,       opts("Papelera marcados"))
      end,
    })

    -- ── Keymaps globales (fuera del árbol) ────────────────────────────────────
    local map = vim.keymap.set
    local api = require("nvim-tree.api")

    map("n", "<leader>e",  api.tree.toggle,             { desc = "Toggle nvim-tree" })
    map("n", "<leader>ef", api.tree.focus,              { desc = "Enfocar nvim-tree" })
    map("n", "<leader>ec", api.tree.collapse_all,       { desc = "Colapsar árbol" })
    map("n", "<leader>er", api.tree.reload,             { desc = "Recargar árbol" })

    -- Cierra nvim-tree automáticamente si es la última ventana abierta
    vim.api.nvim_create_autocmd("QuitPre", {
      callback = function()
        local invalid_win = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
          local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
          if bufname:match("NvimTree_") ~= nil then
            table.insert(invalid_win, w)
          end
        end
        if #invalid_win == #wins - 1 then
          -- Solo queda nvim-tree: ciérralo
          for _, w in ipairs(invalid_win) do
            vim.api.nvim_win_close(w, true)
          end
        end
      end,
    })
  end,
}
