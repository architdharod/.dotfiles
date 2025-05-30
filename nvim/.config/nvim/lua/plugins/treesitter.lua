return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- Treesitter
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      auto_install = true,
      ensure_installed = { "lua", "c", "vim", "vimdoc", "query", "javascript", "html", "typescript", "astro", "go", "python" },
      indent = { enable = true },
    })
  end,
}
