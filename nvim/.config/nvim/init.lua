-- Selecting and loading lazy.vim as our package manager :)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

---@diagnostic disable-next-line: unused-local
local opts = {}

-- all my settings and keybindings can go there
require("my-special-vim-options")

-- if you have the /plugins.lua structure, only the line below has to be required
require("lazy").setup("plugins")
