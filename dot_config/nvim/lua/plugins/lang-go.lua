return {
  -----------------------------------------------------------------------------
  -- Mason (Go tools)
  -----------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "gopls", -- Go Language Server
        "delve", -- Go Debugger
      })
      return opts
    end,
  },
  -----------------------------------------------------------------------------
  -- Treesitter
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "go", "gomod", "gosum" })
      return opts
    end,
  },
  -----------------------------------------------------------------------------
  -- Conform (Formatting)
  -----------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- Use both goimports (organizes imports) and gofmt (formats code)
      opts.formatters_by_ft.go = { "goimports", "gofmt" }
      return opts
    end,
  },
  -----------------------------------------------------------------------------
  -- Go Plugin and LSP setup
  -----------------------------------------------------------------------------
  {
    "ray-x/go.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod" },
    event = { "CmdlineEnter" },
    build = ':lua require("go.install").update_all_sync()', -- Installs go tools
    config = function()
      require("go").setup({
        -- Disable go.nvim's formatter to let conform.nvim handle it
        gofmt_enabled = false,
        -- You can add other go.nvim settings here
      })

      -- Setup gopls LSP via lspconfig
      require("lspconfig").gopls.setup({
        settings = {
          gopls = {
            -- Example settings
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
              shadow = true,
            },
          },
        },
      })
    end,
  },
  -----------------------------------------------------------------------------
  -- DAP Configuration for Go
  -----------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.adapters.go = {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }

      dap.configurations.go = {
        {
          type = "go",
          name = "Debug",
          request = "launch",
          program = "${fileDirname}",
        },
        {
          type = "go",
          name = "Debug Test",
          request = "launch",
          mode = "test",
          program = "${fileDirname}",
        },
      }
    end,
  },
}
