local configs = require "nvchad.configs.lspconfig"

-- TODO: add a fallback to mason package here if vue or local is missing
-- local mason_registry = require "mason-registry"
-- local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
--   .. "/node_modules/@vue/language-server"
local vue_language_server_path = "~/.nix-profile/bin/vue-language-server"

local servers = {
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = {
          globals = { "vim" }, -- Prevents 'undefined vim' warnings
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true), -- Load Neovim runtime files
        },
        telemetry = { enable = false },
      },
    },
  },
  html = {},
  bashls = {},
  dockerls = {},
  rnix = {
    cmd = { "nil" }, -- path to the nix-lsp executable
    filetypes = { "nix", "nix-os" }
    -- root_dir = lspconfig.util.root_pattern("default.nix", "flake.nix")
  },
  cssls = {},
  ltex = {
    settings = {
      ltex = { language = "en-US" },
    },
    filetypes = { "markdown", "tex", "latex", "text", "lr" },
  },
  ts_ls = {
    {
      init_options = {
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_language_server_path,
            languages = { "javascript", "typescript", "vue" },
          },
        },
      },
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    },
  },

  volar = {
    init_options = {
      vue = {
        hybridMode = false,
      },
    },
  },

  ruff = {
    init_options = {
      settings = {
        -- Tell Ruff to fix things automatically
        args = { "--fix" },
      },
    },
    on_attach = function(client, bufnr)
      -- Optional: format on save
      local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
      buf_set_option("formatexpr", "v:lua.vim.lsp.formatexpr()")

      -- Keymap for formatting manually
      vim.keymap.set("n", "<leader>fr", function()
        vim.lsp.buf.format { async = true }
      end, { buffer = bufnr })
    end,
  },

  basedpyright = {
    settings = {
      filetypes = { "python" },
      python = {
        analysis = {
          autoSearchPaths = true,
          typeCheckingMode = "strict",
          autoImportCompletions = true,
          useLibraryCodeForTypes = true,
        },
      },
    },
    before_init = function(_, config)
      -- This function sets the Python path dynamically based on the presence of a .venv directory
      local venv_path = vim.fn.getcwd() .. "/.venv/bin/python"
      if vim.fn.filereadable(venv_path) == 1 then
        config.settings.python.pythonPath = venv_path
      else
        config.settings.python.pythonPath = "/usr/bin/python3" -- Fallback global Python
      end
    end,
  },
}

-- Dynamically attack capbilities to all configured servers
for name, opts in pairs(servers) do
  opts.on_init = configs.on_init
  opts.on_attach = configs.on_attach
  opts.capabilities = configs.capabilities

  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end


