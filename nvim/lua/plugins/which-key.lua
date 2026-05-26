return {
  "folke/which-key.nvim",
  event = "VeryLazy", -- Se carga en segundo plano para no ralentizar el inicio
  dependencies = {
    "echasnovoski/mini.icons",
  },
  opts = {
    plugins = {
      spelling = { enabled = true },
      presets = {
        operators = false, -- Desactiva ayuda para cosas super básicas como d, y, c
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    
    wk.add({
        {"<leader>e", desc = "Abrir explorador de archivos (Oil)"},
        {"<leader>o", group = "Obsidian (Notas)"},
    })
  end,
}
