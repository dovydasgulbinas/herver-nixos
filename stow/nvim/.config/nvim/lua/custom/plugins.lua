local plugins = {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"vue-language-server",
				"typescript-language-server",
				"yamlfmt",
				"yamllint",
				"black",
				"debugpy",
				"pyright",
				"html-lsp",
				"lua-language-server",
				"stylua",
				"bash-language-server",
				-- "docker-compose-language-service",
				-- "dockerfile-language-server",
			},
		},
	},

	{
		"nvimtools/none-ls.nvim",
		ft = {
			"python",
			"javascript",
			"lua",
			"yaml",
			"typescript",
			"javascript",
			"javascriptreact",
			"typescriptreact",
			"vue",
			"json",
			"html",
			"css",
			"nix",
		},
		opts = function()
			return require("custom.configs.none-ls")
		end,
	},

	{
		"nvim-telescope/telescope-file-browser.nvim",
		lazy = false,
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},

	-- {
	-- 	"NeogitOrg/neogit",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim", -- required
	-- 		"sindrets/diffview.nvim", -- optional - Diff integration
	-- 		-- Only one of these is needed.
	-- 		"nvim-telescope/telescope.nvim", -- optional
	-- 	},
	-- 	config = function()
	-- 		require("neogit").setup({
	-- 			-- Optional configuration
	-- 			integrations = {
	-- 				diffview = true, -- Optional: Integrates with the `diffview.nvim` plugin
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"NeogitOrg/neogit",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true,
	},
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		opts = {
			position = "right",
		},
	},
	{
		"chentoast/marks.nvim",
		lazy = false,
		config = function()
			require("marks").setup()
		end,
	},
	{
		"tpope/vim-obsession",
		lazy = false,
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},
	{
		"mfussenegger/nvim-dap",
		config = function(_, opts)
			require("core.utils").load_mappings("dap")
		end,
	},

	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
		config = function(_, opts)
			-- local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup("uv")
			require("core.utils").load_mappings("dap_python")
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
}

return plugins
