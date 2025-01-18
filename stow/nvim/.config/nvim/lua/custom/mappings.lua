local M = {}

M.dap = {
	plugin = true,
	n = {
		["<leader>db"] = {
			"<cmd> DapToggleBreakpoint <CR>",
			"Add breakpoint at line",
		},

		["<leader>dus"] = {
			function()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.open()
			end,
			"Open debugging sidebar",
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
			"Run nearest test w/ debugger",
		},
	},
}

M.telescope = {
	plugin = true,
	n = {
		["<leader>dpr"] = {
			function()
				require("dap-python").test_method()
			end,
			"Run nearest test w/ debugger",
		},
	},
}

local dev_python = require("custom.dev_python")
M.dev_python = {
	plugin = false,
	n = {
		["<leader>dpr"] = {
			function()
				require("dap-python").test_method()
			end,
			"Run nearest test w/ debugger",
		},
		["<leader>pb"] = {
			function()
				dev_python.run_black_on_current_file()
			end,
			"Run black on current file",
		},

		["<leader>pm"] = {
			function()
				dev_python.run_mypy()
			end,
			"Run mypy",
		},

		["<leader>pf"] = {
			function()
				dev_python.run_flake8_on_current_file()
			end,
			"Run flake8 on current file",
		},
		["<leader>pp"] = {
			function()
				dev_python.run_pre_commit()
			end,
			"Run pre-commit",
		},
	},
}

return M
