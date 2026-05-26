return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      -- Hace que Oil sea el explorador por defecto (ej. si abres un directorio)
      default_file_explorer = true,
      
      -- Configuración visual
      columns = {
        "icon",
      },
      
      -- Opciones de vista
      view_options = {
        show_hidden = true,
      },
      
      -- Ventana flotante integrada
      float = {
        padding = 2,
        max_width = 80,
        max_height = 0,
        border = "rounded",
      },
    })

    vim.keymap.set("n", "<leader>v", "<cmd>Oil<CR>", { desc = "Abrir explorador de archivos (Oil)" })
  end,
}
