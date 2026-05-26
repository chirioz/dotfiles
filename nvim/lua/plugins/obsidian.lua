return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = false,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/notes",
      },
    },

    new_notes_location = "notes_subdir",
    notes_subdir = "notes",

    note_id_func = function(title)
      if title ~= nil and title ~= "" then
        return title:gsub(" ", "_"):gsub("[^%w-_]", ""):lower()
      else
        return "nota_temporal_" .. tostring(os.date("%Y_%m_%d_%H%M"))
      end
    end,

    disable_frontmatter = false,

    note_frontmatter_func = function(note)
      local filename = note.name or tostring(note.id)
      local meta = note.metadata or {}

      -- Usa la fecha real del archivo si no hay created en el frontmatter
      local function get_file_date(path)
        if path ~= nil then
          local stat = vim.loop.fs_stat(tostring(path))
          if stat then
            return os.date("%Y-%m-%d, %H:%M", stat.mtime.sec)
          end
        end
        return tostring(os.date("%Y-%m-%d, %H:%M"))
      end

      -- Lee #tags del buffer y los mergea con los del frontmatter sin duplicados
      local function extract_tags_from_buffer()
        local bufnr = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local body = table.concat(lines, "\n")
        local seen = {}
        local final = {}
        for _, tag in ipairs(note.tags or {}) do
          if not seen[tag] then
            table.insert(final, tag)
            seen[tag] = true
          end
        end
        for tag in body:gmatch("#([%w_-]+)") do
          if not seen[tag] then
            table.insert(final, tag)
            seen[tag] = true
          end
        end
        return final
      end

      -- Campos inmutables: se preservan si ya existen
      local created = meta.created or get_file_date(note.path)
      local type    = meta.type    or "inbox"
      local status  = meta.status  or "inbox"
      local url     = meta.url     or {}

      return {
        title    = note.title or note.id,
        created  = created,
        type     = type,
        url      = url,
        status   = status,
        tags     = extract_tags_from_buffer(),
        filename = filename,
      }
    end,

    daily_notes = {
      folder = "journal",
      date_format = "%Y-%m-%d",
      template = "resources/Plantillas/journal.md",
    },

    templates = {
      folder = "resources/Plantillas",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },

    picker = {
      name = "telescope.nvim",
      mappings = {
        new_note = "<C-x>",
        insert_symbol = "<C-l>",
      },
    },

    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    ui = {
      enable = true,
      update_debounce = 200,
      checkboxes = {
        [" "] = { char = "", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "󰒊", hl_group = "ObsidianRightArrow" },
        ["<"] = { char = "󰃭", hl_group = "ObsidianLeftArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
      },
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },
  },

  config = function(_, opts)
    require("obsidian").setup(opts)

    local keymap = vim.keymap.set

    -- <Leader>on -> Nueva nota con prompt de título
    keymap("n", "<leader>on", function()
      vim.ui.input({ prompt = "Título de la nota (vacío para temporal): " }, function(input)
        if input then
          vim.cmd("ObsidianNew " .. input)
        end
      end)
    end, { desc = "Nueva nota Obsidian" })

    -- <Leader>od -> Daily note de hoy
    keymap("n", "<leader>od", "<cmd>ObsidianToday<CR>", { desc = "Daily note de hoy" })

    -- <Leader>oy -> Daily note de ayer
    keymap("n", "<leader>oy", "<cmd>ObsidianYesterday<CR>", { desc = "Daily note de ayer" })

    -- <Leader>os -> Buscar TEXTO dentro de todas las notas
    keymap("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Buscar texto en notas" })

    -- <Leader>oo -> Buscar nota por TÍTULO (Quick Switcher)
    keymap("n", "<leader>oo", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Buscar nota por título" })

    -- <Leader>oT -> Insertar plantilla (picker completo)
    keymap("n", "<leader>oT", "<cmd>ObsidianTemplate<CR>", { desc = "Insertar plantilla" })

    -- <Leader>otj -> Plantilla: journal
    keymap("n", "<leader>otj", "<cmd>ObsidianTemplate journal_nvim.md<CR>", { desc = "Plantilla: journal" })

    -- <Leader>og -> Buscar tags
    keymap("n", "<leader>og", "<cmd>ObsidianTags<CR>", { desc = "Buscar tags" })

    -- <Leader>or -> Renombrar nota de forma SEGURA (actualiza todos los enlaces)
    keymap("n", "<leader>or", "<cmd>ObsidianRename<CR>", { desc = "Renombrar nota de forma segura" })

    -- <Leader>ob -> Ver Backlinks de la nota actual
    keymap("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Ver backlinks de la nota actual" })

    -- <Leader>ol -> Ver links de la nota actual
    keymap("n", "<leader>ol", "<cmd>ObsidianLinks<CR>", { desc = "Ver links de la nota actual" })

    -- <Leader>oY -> Cambiar type de la nota actual
    keymap("n", "<leader>oY", function()
      vim.ui.select(
        { "inbox", "seed", "evergreen", "source_note", "resource", "index", "journal", "project" },
        { prompt = "Cambiar type:" },
        function(choice)
          if choice then
            vim.cmd(string.format("silent! %%s/^type: .*/type: %s/", choice))
          end
        end
      )
    end, { desc = "Cambiar type de nota" })

    -- <Leader>oS -> Cambiar status de la nota actual
    keymap("n", "<leader>oS", function()
      vim.ui.select(
        { "inbox", "active", "done", "archived" },
        { prompt = "Cambiar status:" },
        function(choice)
          if choice then
            vim.cmd(string.format("silent! %%s/^status: .*/status: %s/", choice))
          end
        end
      )
    end, { desc = "Cambiar status de nota" })

    -- <Leader>oi -> Notas pendientes (status: inbox)
    keymap("n", "<leader>oi", function()
      require("telescope.builtin").live_grep({
        default_text = "status: inbox",
        prompt_title = "Notas en inbox",
        cwd = vim.fn.expand("~/notes"),
      })
    end, { desc = "Ver notas en inbox" })

    -- <Leader>oR -> Notas recientes ordenadas por fecha de modificación
    keymap("n", "<leader>oR", function()
      local vault = vim.fn.expand("~/notes")
      local raw = vim.fn.systemlist(
        "find " .. vault ..
        " -name '*.md'" ..
        " -not -path '*/resources/*'" ..
        " -not -path '*/journal/*'" ..
        " -printf '%T@ %p\n'" ..
        " | sort -rn | head -20 | awk '{print $2}'"
      )

      local pickers      = require("telescope.pickers")
      local finders      = require("telescope.finders")
      local conf         = require("telescope.config").values
      local actions      = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      pickers.new({}, {
        prompt_title = "Notas recientes",
        finder = finders.new_table({
          results = raw,
          entry_maker = function(entry)
            local display = entry:gsub(vault .. "/", "")
            return {
              value   = entry,
              display = display,
              ordinal = display,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            vim.cmd("edit " .. selection.value)
          end)
          return true
        end,
      }):find()
    end, { desc = "Notas recientes" })

  end,
}
