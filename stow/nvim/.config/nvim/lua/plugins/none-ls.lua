return {
  "nvimtools/none-ls.nvim",
  lazy = false,
  ft = {
    -- "python",
    -- "javascript",
    -- "lua",
    -- "yaml",
    -- "typescript",
    -- "javascript",
    -- "javascriptreact",
    -- "typescriptreact",
    -- "vue",
    -- "json",
    -- "html",
    -- "css",
    -- "nix",
  },
  opts = function()
    return require "configs.none-ls"
  end,
}
