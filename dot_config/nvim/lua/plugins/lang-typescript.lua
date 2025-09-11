return {
  -- TypeScript/JavaScript support
  {
    "pmizio/typescript-tools.nvim",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "literals",
          includeInlayVariableTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
        },
      },
    },
  },
  -- ESLint LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          -- will auto-start in JS/TS projects that have eslint config
          settings = {
            workingDirectory = { mode = "auto" },
          },
        },
      },
    },
  },
  -- Ensure tools are installed
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "eslint-lsp",
        "prettierd",
        "typescript-language-server",
      })
    end,
  },
  -- Treesitter for JS/TS/TSX/JSX/JSON/CSS
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "javascript",
        "typescript",
        "tsx",
        "json",
        "css",
      })
    end,
  },
  -- Formatting for JS/TS/React
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs({
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "json",
        "css",
        "markdown",
        "yaml",
      }) do
        opts.formatters_by_ft[ft] = { "prettierd", "prettier" }
      end
    end,
  },
}
