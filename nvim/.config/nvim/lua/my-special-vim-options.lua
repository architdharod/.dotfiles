vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set linespace=100")

-- set relative line numbering
vim.cmd("set relativenumber")

-- the relative line "0" now shows the global line
vim.cmd("set nu rnu")

-- Cltr+s is to save the file
vim.keymap.set("n", "<C-s>", ":wa<CR>", {})
vim.g.mapleader = " "

-- split screen shortcuts: :sp and :vs (verticle split)
vim.keymap.set("n", "<leader>v", ":vs<CR>", {})
vim.keymap.set("n", "<leader>h", ":sp<CR>", {})

-- Resize buffers with arrows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", {})
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", {})
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", {})
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", {})

-- highlight text on Yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern = "*",
  desc = "Highlight selection on yank",
  callback = function()
    vim.highlight.on_yank({ timeout = 300, visual = true })
  end,
})

-- Options for VIM:

-- Decrease updatetime to 200ms
vim.opt.updatetime = 50

-- Disable text wrap
vim.opt.wrap = false

-- Enable ignorecase + smartcase for better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Always keep 8 lines above/below cursor unless at start/end of file
vim.opt.scrolloff = 15

vim.opt.guicursor = {
  "n-v-c:block",  -- Normal, visual, command-line: block cursor
  "i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
  "r-cr:hor20",   -- Replace, command-line replace: horizontal bar cursor with 20% height
  "o:hor50",      -- Operator-pending: horizontal bar cursor with 50% height
  "a:blinkon25",  -- All modes: blinking settings
}

-- Enable 24-bit color
vim.opt.termguicolors = true

-- shortcut for switching buffers
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", {})
vim.keymap.set("n", "<S-l>", ":bnext<CR>", {})
vim.keymap.set("n", "<S-d>", ":bdelete<CR>", {})
