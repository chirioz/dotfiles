return {
  "echasnovski/mini.icons",
  version = false, -- Usamos la rama de desarrollo para tener los últimos iconos
  lazy = false,    -- Lo cargamos temprano para que esté disponible para Which-Key
  opts = {
    -- Aquí puedes personalizar iconos en el futuro si lo necesitas
    file = {},
    directory = {},
    extension = {},
  },
  config = function(_, opts)
    local mini_icons = require("mini.icons")
    mini_icons.setup(opts)
    
    -- Este paso es mágico: "emula" los plugins viejos de iconos (como nvim-web-devicons)
    -- por si algún plugin antiguo los llega a buscar en tu entorno personal.
    mini_icons.mock_nvim_web_devicons()
  end,
}
