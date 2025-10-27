return {
  'stevearc/aerial.nvim',
  keys = {
    { "<leader>cc", "<cmd>AerialNavToggle<CR>", desc = "Aerial Nav" },
    { "<leader>cs", "<cmd>AerialToggle!<CR>",   desc = "Aerial Outline" },
  },
  lazy = false,
  opts = {},
  -- Optional dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require("aerial").setup({
      backends = { "lsp", "treesitter", "markdown" },
      layout = {
        preserve_equality = true,
      },
      -- filter_kind = false,
      filter_kind = {
        "Class",
        "Constructor",
        "Function",
        "Method",
        "Variable",
        "Constant"
      },
      close_on_select = true,
      nav = {
        border = "single",
        preview = true,
        -- max_height = 0.8,
        -- min_height = { 15, 0.15 },
        -- max_width = 0.8,
        -- min_width = { 0.4, 40 },
        win_opts = {
          cursorline = true,
          winblend = 10,
        },
        keymaps = {
          ["q"] = "actions.close",
          ["<esc>"] = "actions.close",
        },
      },

      lsp = {
        -- If true, fetch document symbols when LSP diagnostics update.
        diagnostics_trigger_update = true,

        -- Set to false to not update the symbols when there are LSP errors
        update_when_errors = true,

        -- How long to wait (in ms) after a buffer change before updating
        -- Only used when diagnostics_trigger_update = false
        update_delay = 300,

        -- Map of LSP client name to priority. Default value is 10.
        -- Clients with higher (larger) priority will be used before those with lower priority.
        -- Set to -1 to never use the client.
        priority = {
          -- pyright = 10,
        },
      },
      -- optionally use on_attach to set keymaps when aerial has attached to a buffer
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
    })
  end,
}
