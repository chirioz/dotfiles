return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    local status_ok, configs = pcall(require, "nvim-treesitter.configs")
    if not status_ok then return end
    
    if not status_ok then
      return
    end

    configs.setup({
      ensure_installed = { 
        "markdown", 
        "markdown_inline", 
        "bash", 
        "lua", 
        "python",
        "dart",
        "json", 
        "yaml",
        "go"
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { 
        enable = true 
      },
    })
  end,
}
