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
map("v", "<leader>cc", function()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  local file = vim.fn.expand("%:t")
  local lines = vim.fn.getline(start_line, end_line)
  
  -- Get the directory relative to the file
  local file_path = vim.fn.expand("%:p")
  local dir_path = vim.fn.fnamemodify(file_path, ":h")
  
  -- Simple approach: split dir_path and check from root down
  local rel_dir = ""
  local dir_parts = {}
  for p in string.gmatch(dir_path, "[^/]+") do
    table.insert(dir_parts, p)
  end
  
  -- Build relative paths from longest to shortest and find the first one that exists
  for len = #dir_parts, 1, -1 do
    local test_parts = {}
    for k = 1, len do
      table.insert(test_parts, dir_parts[k])
    end
    local test_path = table.concat(test_parts, "/")
    if vim.fn.isdirectory(test_path) == 1 then
      rel_dir = test_path
      break
    end
  end
  
  -- Get current buffer number
  local bufnr = vim.api.nvim_get_current_buf()

  -- Detect language from Treesitter if available
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  
  -- Only use Treesitter if we have a valid filetype and Treesitter is available
  local lang = "plain"  -- fallback when Treesitter unavailable
  if filetype and filetype ~= "" and vim.treesitter and vim.treesitter.get_lang_info then
    local langinfo = vim.treesitter.get_lang_info(filetype)
    if langinfo and langinfo.valid then
      local lang = filetype
      -- Check if it's a known language we want to mark (simple version)
      local known_langs = {
        "c", "python", "javascript", "rust", "typescript", "go", "java", "cpp",
        "swift", "kotlin", "scala", "php", "ruby", "perl", "elixir", "erlang",
        "racket", "clojure", "groovy", "tcl", "fsharp", "ocaml", "haskell",
        "coq", "isabelle", "agda", "lean", "verilog", "systemverilog", "d",
        "nim", "pike", "scheme", "luau", "lua", "gdscript", "gd", "csharp",
        "vbnet", "fift", "vhdl", "adlers", "asc", "asm", "basic", "blazor",
        "cobol", "conf", "csv", "dart", "diff", "dockerfile", "edn",
        "fortran", "gas", "gcode", "gd", "gdyaml", "glsl", "gmsl", "gradle",
        "groovy", "haml", "hcl", "html", "ini", "jade", "jenkinsfile",
        "julia", "json", "jsp", "jsx", "json5", "jsonnet", "jssm", "kt",
        "lasso", "less", "libreoffice", "llama", "lisp", "llvm", "llvmir",
        "lua", "makefile", "markdown", "mermaid", "matlab", "ml",
        "monkey", "mipsasm", "mupad", "nginx", "nim", "ninja", "nosql",
        "nu", "nunjucks", "oasis", "ocaml", "opal", "org", "pas", "pascal",
        "patch", "perl", "php", "phpjs", "plantuml", "plaintext", "pom",
        "pony", "properties", "protobuf", "purescript", "puppet", "r",
        "rake", "raku", "racket", "renpy", "rest", "rst", "sass", "scala",
        "scss", "sh", "smali", "smt", "solidity", "sparql", "svelte", "swift",
        "tcl", "textile", "tiki", "toml", "tsx", "tsv", "twig", "v",
        "vhd", "vhdl", "vim", "vuln", "webidl", "webpage", "wiki", "wit",
        "wml", "wsdl", "x86asm", "xml", "xsd", "xsl", "yaml", "yml",
        "zig", "ziggy"
      }
      
      for _, known in ipairs(known_langs) do
        if vim.fn.stridx(lang, known) == 0 then
          break
        end
      end
    end
  end
  
  -- Build the markdown code block
  local header = string.format("# %s:%d-%d", file, start_line, end_line)
  
  -- Combine header and code block
  local content = header .. "\n\n```" .. lang .. "\n" .. table.concat(lines, "\n") .. "\n\n```\n"
  
  vim.fn.setreg("+", content) -- copy to system clipboard
  vim.notify("📋 Copied: " .. header .. " (" .. lang .. ")", "info")
end, { desc = "Copy relative file path + line range + code content (markdown)" })


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