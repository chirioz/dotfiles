-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Atajos nativos
local keymap = vim.keymap.set

-- Salir del modo insertar
keymap("i", "jk", "<ESC>", { desc = "Salir del modo insertar" })

-- Limpiar resaltador de búsqueda
keymap("n", "<ESC>", "<cmd>noh<CR>", { desc = "Limpiar resaltado" })

-- Centrado de pantalla al saltar de documento
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
