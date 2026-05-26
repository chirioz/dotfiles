return {
  "nvim-telescope/telescope.nvim",
  varsion = "*",
  dependencies = { 
    "nvim-lua/plenary.nvim"
  },
  config = function()
    local telescope = require("telescope")
    
    telescope.setup({
      defaults = {
        -- Esto hace que la ventana flotante se vea limpia y use bordes redondeados
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      }
    })

    -- Configurar los atajos de teclado para buscar rápido
    local builtin = require("telescope.builtin")
    local keymap = vim.keymap.set

    -- <Leader>ff (Find Files): Busca archivos por su nombre
    keymap("n", "<leader>ff", builtin.find_files, { desc = "Buscar archivos" })
    
    -- <Leader>fg (Live Grep): Busca texto dentro de los archivos
    keymap("n", "<leader>fg", builtin.live_grep, { desc = "Buscar texto en archivos" })
    
    -- <Leader>fb (Buffers): Muestra tus archivos abiertos actualmente
    keymap("n", "<leader>fb", builtin.buffers, { desc = "Ver buffers abiertos" })
  end,
}
