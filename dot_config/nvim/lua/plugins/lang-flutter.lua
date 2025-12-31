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
  -- Flutter Bloc Plugin
  -----------------------------------------------------------------------------
  {
    "wa11breaker/flutter-bloc.nvim",
    dependencies = {
      "nvimtools/none-ls.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      bloc_type = "equatable", -- Choose from: 'default', 'equatable', 'freezed'
      use_sealed_classes = false,
      enable_code_actions = true,
    },
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
