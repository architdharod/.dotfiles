return {
  "folke/tokyonight.nvim",
  priority = 1000,
  opts = {},
  config = function()
    require("tokyonight").setup({
      --      transparent = true,
      styles = {
        comments = {
          italic = false,
        },
      },
    })
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
-- test comment
