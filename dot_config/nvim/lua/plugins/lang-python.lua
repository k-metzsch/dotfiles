return {
  -----------------------------------------------------------------------------
  -- Treesitter
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "python", "toml", "yaml" })
      return opts
    end,
  },
  -----------------------------------------------------------------------------
  -- Mason Tools
  -----------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "basedpyright",
        "ruff",
        "black",
        "isort",
        "debugpy", -- Python debugger
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
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
              },
            },
          },
        },
        ruff = {},
      },
    },
  },
  -----------------------------------------------------------------------------
  -- Formatting
  -----------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { "isort", "black" }
      return opts
    end,
  },
  -----------------------------------------------------------------------------
  -- Venv Selector (pyenv compatible)
  -----------------------------------------------------------------------------
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    ft = { "python" },
    opts = {
      -- Use pyenv path
      venv_path = vim.fn.expand("~/.pyenv/versions"),
      name = {
        "venv",
        ".venv",
        "env",
        ".env",
      },
      parents = 1,
      auto_refresh = true,
    },
    config = function(_, opts)
      require("venv-selector").setup(opts)
    end,
  },
  -----------------------------------------------------------------------------
  -- DAP Configuration
  -----------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("dap").adapters.python = {
        type = "executable",
        command = "python", -- This will use the venv python
        args = { "-m", "debugpy.adapter" },
      }
      require("dap").configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            -- venv-selector automatically sets vim.b.python_exec_dir
            local venv = vim.b.python_exec_dir
            if venv then
              return venv .. "/bin/python"
            end
            return "python"
          end,
        },
      }
    end,
  },
}
