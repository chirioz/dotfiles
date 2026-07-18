# dotfiles

Configuración de mi entorno de trabajo en Linux: shell, multiplexor de terminal y editor. Pensado para funcionar en distintas distros (Ubuntu, Arch, Fedora) y en distintas máquinas que uso diario, detectando el entorno en tiempo de arranque en lugar de mantener una copia distinta por cada máquina y distro.

## Contenido

| Archivo         | Qué hace                                                                                                                                                                                                                        |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `.bashrc`       | Shell interactiva: historial deduplicado con timestamps, prompt con rama de git e indicador de exit code, detección de distro, MOTD condicional por host, gestión de `PATH` por directorio.                                     |
| `.bash_aliases` | Aliases y funciones: envoltura de `eza`/`bat` con fallback a coreutils si no están instalados, funciones de navegación de notas (Obsidian), buscador `fzf` + `ripgrep`, y una red de seguridad que redirige `rm` a `trash-put`. |
| `.tmux.conf`    | tmux con prefijo en `C-a`, navegación de paneles estilo vim, y plugins vía TPM (tema Rose Pine, tmux-fzf).                                                                                                                      |
| `nvim/`         | Configuración de Neovim en Lua, modularizada (ver abajo).                                                                                                                                                                       |
| `tmux_start.sh` | Script de arranque: instala TPM y enlaza la config.                                                                                                                                                                             |

## Neovim

Estructura modular en lugar de un `init.lua` monolítico:

```
nvim/
├── init.lua              # punto de entrada
└── lua/
    ├── core/             # options, keymaps
    ├── plugins/          # un archivo por plugin (lazy.nvim)
    └── lazy-config.lua   # bootstrap del gestor de plugins
```

Gestor de plugins: [lazy.nvim](https://github.com/folke/lazy.nvim), con bootstrap automático en el primer arranque.

Lo más trabajado es la integración con [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) para gestionar mis notas desde el editor, con lógica propia:

- **Frontmatter automático** que preserva campos inmutables (`created`, `type`, `status`) si ya existen, y deriva la fecha de creación del `mtime` real del archivo cuando falta.
- **Extracción de tags** que lee los `#tags` del cuerpo de la nota y los combina con los del frontmatter sin duplicados.
- **Cambio de `type`/`status`** de una nota vía menú de selección.
- **Picker de notas recientes** construido a mano sobre la API de Telescope, ordenado por fecha de modificación y excluyendo carpetas de plantillas y diario.

## Instalación

Clonar en `$HOME` y enlazar los archivos que quieras.

Para tmux:

```bash
./tmux_start.sh
```

> No es un instalador automático de todo el entorno — es mi referencia personal. Tómalo como ejemplo, no como algo listo para ejecutar a ciegas en tu máquina.
