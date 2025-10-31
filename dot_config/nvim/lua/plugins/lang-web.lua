return {
  -----------------------------------------------------------------------------
  -- Treesitter
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "yaml",
        "vue",
      })
      return opts
    end,
  },
  -----------------------------------------------------------------------------
  -- Mason (for formatters, linters, etc.)
  -----------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "prettier", -- Formatter
        "stylelint", -- Linter
      })
      return opts
    end,
  },
  -----------------------------------------------------------------------------
  -- Mason LSP Config (for LSP servers only)
  -----------------------------------------------------------------------------
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "html",
        "cssls",
        "emmet_ls",
        "eslint", -- This is an LSP server
      })
      return opts
    end,
  },
  -----------------------------------------------------------------------------
  -- LSP Servers
  -----------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
        cssls = {
          settings = {
            css = {
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },
        emmet_ls = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascriptreact",
            "typescriptreact",
            "vue",
            "blade",
          },
        },
        -- tsserver is configured by typescript-tools.nvim
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
          },
        },
      },
    },
  },
  -----------------------------------------------------------------------------
  -- Auto Tag Completion
  -----------------------------------------------------------------------------
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "javascriptreact",
      "typescriptreact",
      "vue",
      "blade",
    },
    opts = {},
  },
  -----------------------------------------------------------------------------
  -- Formatting
  -----------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.javascript = { "prettier" }
      opts.formatters_by_ft.typescript = { "prettier" }
      opts.formatters_by_ft.javascriptreact = { "prettier" }
      opts.formatters_by_ft.typescriptreact = { "prettier" }
      opts.formatters_by_ft.vue = { "prettier" }
      opts.formatters_by_ft.html = { "prettier" }
      opts.formatters_by_ft.css = { "prettier" }
      opts.formatters_by_ft.scss = { "prettier" }
      opts.formatters_by_ft.json = { "prettier" }
      return opts
    end,
  },
  -----------------------------------------------------------------------------
  -- Typescript Tools for JS/TS
  -----------------------------------------------------------------------------
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    opts = {
      settings = {
        dap_adapter = {
          enabled = true,
        },
      },
    },
  },
}
