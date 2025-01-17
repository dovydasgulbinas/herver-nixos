-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local nvlsp = require "nvchad.configs.lspconfig"

local servers = {
	html = {},
	bashls = {},
  cssls = {},
	dockerls = {},
	rnix = {},
	-- ts_ls = {
	-- 	{
	-- 		init_options = {
	-- 			plugins = {
	-- 				{
	-- 					name = "@vue/typescript-plugin",
	-- 					location = "/home/hermes/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server",
	-- 					languages = { "javascript", "typescript", "vue" },
	-- 				},
	-- 			},
	-- 		},
	-- 		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	-- 	},
	-- },
	--
	-- volar = {
	-- 	init_options = {
	-- 		vue = {
	-- 			hybridMode = false,
	-- 		},
	-- 	},
	-- },

	pyright = {
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


-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
