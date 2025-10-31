return {
  -----------------------------------------------------------------------------
  -- Flutter Plugin
  -----------------------------------------------------------------------------
  {
    "nvim-flutter/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- for UI selects
    },
    ft = { "dart" },
    opts = {
      decorations = {
        statusline = {
          app_version = true,
          device = true,
        },
      },
      widget_guides = {
        enabled = true,
      },
      closing_tags = {
        enabled = true,
      },
      dev_log = {
        enabled = true,
        open_cmd = "botright 15split",
      },
      lsp = {
        color = {
          enabled = true,
          virtual_text = true,
        },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
        },
      },
    },
    config = function(_, opts)
      require("flutter-tools").setup(opts)
    end,
  },

  -----------------------------------------------------------------------------
  -- Pubspec Dependency Helper
  -----------------------------------------------------------------------------
  {
    "nvim-flutter/pubspec-assist.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    ft = { "yaml" }, -- Triggers on pubspec.yaml
    opts = {
      -- all default
    },
    config = function(_, opts)
      require("pubspec-assist").setup(opts)
    end,
  },

  -----------------------------------------------------------------------------
  -- Treesitter
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "dart" })
      return opts
    end,
  },
}
