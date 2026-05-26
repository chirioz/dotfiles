return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Configuración del plugin
    require("bufferline").setup({
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = true,
      }
    })

    -- Keymaps integrados
    local map = vim.keymap.set
    map('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', { desc = "Siguiente buffer" })
    map('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = "Buffer anterior" })
    map('n', '<Leader>x', '<Cmd>bdelete<CR>', { desc = "Cerrar buffer" })
  end
}
