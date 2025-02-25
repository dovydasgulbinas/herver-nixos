return {
  "NeogitOrg/neogit",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = function()
    require("neogit").setup {
      -- Optional configuration
      integrations = {
        diffview = true, -- Optional: Integrates with the `diffview.nvim` plugin
      },
    }
  end,
}
