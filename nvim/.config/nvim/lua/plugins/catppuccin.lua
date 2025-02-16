return {
  "catppuccin/nvim",
  enabled = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("catppuccin")
  end,
}

-- instead of calling the following function in init.lua:
-- color Theme
--require("catppuccin").setup()
--vim.cmd.colorscheme "catppuccin"
--we call the "config = function()
--    vim.cmd.colorscheme "catppuccin
--end
