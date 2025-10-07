require "nvchad.mappings"
local dev_python = require "dev_python"
local map = vim.keymap.set

-- git settings
map("n", "<leader>gn", "<cmd> Neogit <cr>", { desc = "Git Neogit open in a new tab" })
map("n", "<leader>gs", function()
  dev_python.git_stage_current_buffer()
end, { desc = "Git stage current file" })
map("n", "<leader>gb", "<cmd> Gitsigns blame <cr>", { desc = "Git Gitsigns blame the whole buffer" })
map(
  "n",
  "<leader>q",
  ":delmarks a-zA-Z0-9<CR>:bufdo bdelete<CR>",
  { desc = "Cleanup marks and buffers", noremap = true }
)


-- yank code snipets and line number
map("v", "<leader>cr", function()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local file = vim.fn.expand("%")
  local text = string.format("%s:%d-%d", file, start_line, end_line)
  vim.fn.setreg("+", text) -- copy to system clipboard
  vim.notify("📋 Copied: " .. text)
end, { desc = "Copy relative file path + line range" })


map(
  "n",
  "<leader>cf",
  ":let @+ = expand('%:p')<cr>",
  { desc = "Copy absolute file path", noremap = true, silent = true }
)


-- tab settings
map("n", "<leader>tt", "<cmd> tabNext <cr>", { desc = "Tab go to Next" })
map("n", "<leader>tn", "<cmd> tabNext <cr>", { desc = "Tab go to Next" })
map("n", "<leader>tp", "<cmd> tabprevious <cr>", { desc = "Tab go to previous" })
map("n", "<leader>td", "<cmd> Telescope diagnostics <cr>", { desc = "LSP Telescope LSP diagnostics" })


-- Code Navigation

-- Python Development Mappings
map("n", "<leader>pf", function()
  dev_python.run_flake8_on_current_file()
end, { desc = "Python run flake8 on current file" })

map("n", "<leader>pm", function()
  dev_python.run_mypy()
end, { desc = "Python run mypy" })

map("n", "<leader>pp", function()
  dev_python.run_pre_commit()
end, { desc = "Python run pre-commit" })

-- Sourced from the original commit
-- Write to buffer before insert of visual mode
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

local M = {}
M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "DAP Add breakpoint at line",
    },

    ["<leader>dus"] = {
      function()
        local widgets = require "dap.ui.widgets"
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
      end,
      "DAP Open debugging sidebar",
    },
  },
}

M.dap_python = {
  plugin = true,
  n = {
    ["<leader>dpr"] = {
      function()
        require("dap-python").test_method()
      end,
      "DAP Run nearest test w/ debugger",
    },
  },
}

return M
