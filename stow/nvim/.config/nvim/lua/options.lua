require "nvchad.options"



local o = vim.o
o.autoread = true
o.cursorlineopt ='both' -- to enable cursorline!

vim.opt.number = true -- Disable line numbers
vim.opt.relativenumber = false -- Disable relative line numbers
-- vim.opt.mouse = "" -- diable mouse support

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	pattern = "*",
	command = "checktime",
})

