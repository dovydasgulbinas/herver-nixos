require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline

o.autoread = true
vim.opt.number = false         -- Disable line numbers
vim.opt.relativenumber = false -- Disable relative line numbers

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})

vim.diagnostic.config({
  virtual_text = false,     -- Disable inline diagnostics
  underline = false,        -- Disable underline
  signs = true,             -- Keep gutter signs (optional)
  update_in_insert = false, -- Don't update in insert mode
  severity_sort = true,
  float = {                 -- Only show diagnostics on hover/command
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    -- source = 'always',
    source = true,
    header = '',
    prefix = '',
  },
})

-- Show diagnostics ONLY for current line
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "CursorMoved", "BufHidden" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'line', -- Critical: Only show for current line
    }
    vim.diagnostic.open_float(nil, opts)
  end
})
