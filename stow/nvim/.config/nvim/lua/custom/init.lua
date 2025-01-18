vim.o.autoread = true
vim.opt.number = false -- Disable line numbers
vim.opt.relativenumber = false -- Disable relative line numbers

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	pattern = "*",
	command = "checktime",
})
