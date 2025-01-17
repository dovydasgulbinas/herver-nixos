-- ~/.config/nvim/lua/custom/custom_commands.lua
local M = {}

function M.run_black_on_current_file()
    local file = vim.fn.expand('%:p')  -- Get the full path of the current file
    local cmd = "./.venv/bin/black " .. file
    local output = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
        vim.fn.setqflist({}, 'r', { title = 'black report', lines = output })
        vim.cmd("copen")  -- Open the quickfix list if there are errors
    else
        vim.cmd("cclose")
        print("Black Complete")
    end
end


function M.run_mypy()
    local cmd = "./.venv/bin/mypy --config-file=pyproject.toml"
    local output = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
        vim.fn.setqflist({}, 'r', { title = 'mypy errors', lines = output })
        vim.cmd("copen")  -- Open the quickfix list if there are errors
    else
        vim.cmd("cclose")
        print("No mypy errors!")
    end
end


function M.run_flake8_on_current_file()
    local file = vim.fn.expand('%:p')  -- Get the full path of the current file
    local cmd = "./.venv/bin/flake8 " .. file
    local output = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
        vim.fn.setqflist({}, 'r', { title = 'flake8 errors', lines = output })
        vim.cmd("copen")  -- Open the quickfix list if there are errors
    else
        vim.cmd("cclose")
        print("No flake8 errors!")
    end
end

-- broken ansi colors are still dispayed
function M.run_pre_commit()
    local cmd = "PRE_COMMIT_COLOR=never ./.venv/bin/pre-commit run"
    local output = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
        vim.fn.setqflist({}, 'r', { title = 'pre-commit errors', lines = output })
        vim.cmd("copen")  -- Open the quickfix list if there are errors
    else
        vim.cmd("cclose")
        print("No pre-commit errors!")
    end
end

-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*.py",
--     callback = function()
--         local view = vim.fn.winsaveview()  -- Save cursor position and view
--         vim.cmd("silent! %!./.venv/bin/black --quiet -")  -- Format buffer with Black
--         vim.fn.winrestview(view)  -- Restore cursor position and view
--     end,
-- })

-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*.py",
--     callback = function()
--         local view = vim.fn.winsaveview()  -- Save cursor position and view
--
--         -- Run Black formatter
--         local output = vim.fn.system("./.venv/bin/black --quiet -", vim.api.nvim_buf_get_lines(0, 0, -1, true))
--
--         -- Check for errors
--         if vim.v.shell_error ~= 0 then
--             -- Populate quickfix list with errors
--             vim.fn.setqflist({}, "r", {
--                 title = "Black Formatting Errors",
--                 lines = vim.split(output, "\n"),
--             })
--             vim.cmd("copen")  -- Open quickfix window
--         else
--             -- Replace buffer content with Black's output
--             vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(output, "\n"))
--             vim.cmd("cclose")  -- Open quickfix window
--         end
--
--         vim.fn.winrestview(view)  -- Restore cursor position and view
--     end,
-- })

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        local view = vim.fn.winsaveview()  -- Save cursor position and view

        -- Run Black formatter
        local output = vim.fn.system("./.venv/bin/black --quiet -", vim.api.nvim_buf_get_lines(0, 0, -1, true))

        -- Check for errors
        if vim.v.shell_error ~= 0 then
            -- Populate quickfix list with errors
            vim.fn.setqflist({}, "r", {
                title = "Black Formatting Errors",
                lines = vim.split(output, "\n"),
            })
            vim.cmd("copen")  -- Open quickfix window
        else
            -- Replace buffer content with Black's output
            vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(output, "\n"))

            -- Close the quickfix list if the title matches "Black Formatting Errors"
            local quickfix_info = vim.fn.getqflist({ title = true })
            if quickfix_info.title == "Black Formatting Errors" then
                vim.cmd("cclose")  -- Close quickfix window
            end
        end

        vim.fn.winrestview(view)  -- Restore cursor position and view
    end,
})

-- local dap = require('dap')
-- local dapui = require('dapui')
--
-- -- Configure nvim-dap-ui
-- dapui.setup()
--
-- -- Configure nvim-dap-python
-- local dap_python = require('dap-python')
-- dap_python.setup('~/.venv/bin/python') -- Replace with your Python interpreter path
--
-- -- Keybindings for DAP
-- vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'Continue debugging' })
-- vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = 'Step over' })
-- vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = 'Step into' })
-- vim.keymap.set('n', '<F12>', function() dap.step_out() end, { desc = 'Step out' })
-- vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end, { desc = 'Toggle breakpoint' })
-- vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = 'Set conditional breakpoint' })
-- vim.keymap.set('n', '<leader>dr', function() dap.repl.open() end, { desc = 'Open REPL' })
-- vim.keymap.set('n', '<leader>dl', function() dap.run_last() end, { desc = 'Run last debug session' })
--
-- -- Open/close the DAP UI automatically
-- dap.listeners.after.event_initialized['dapui_config'] = function()
--     dapui.open()
-- end
-- dap.listeners.before.event_terminated['dapui_config'] = function()
--     dapui.close()
-- end
-- dap.listeners.before.event_exited['dapui_config'] = function()
--     dapui.close()
-- end


return M

