return {
  -- Python LSPs
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
        ruff = {
          on_attach = function(client, _)
            -- Disable formatting from ruff_lsp, let conform handle it
            client.server_capabilities.documentFormattingProvider = false
          end,
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
        "basedpyright",
        "ruff",
        "black",
        "isort",
      })
    end,
  },
  -- Treesitter for Python + common config files
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "python", "toml", "yaml" })
    end,
  },
  -- Formatting for Python
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { "isort", "black" }
    end,
  },
  -- venv-selector plugin
  {
    "linux-cultist/venv-selector.nvim",
    ft = { "python" },
    opts = {
      -- Optionally set venv_path or other config here
      -- venv_path = vim.fn.expand("~/.virtualenvs"),
      name = "venv-selector",
    },
    config = function(_, opts)
      require("venv-selector").setup(opts)
      -- Set up buffer-local keymap for venv selection in Python buffers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function(args)
          vim.keymap.set("n", "<leader>PV", "<cmd>VenvSelect<cr>", {
            buffer = args.buf,
            desc = "Python: Select venv",
            silent = true,
            noremap = true,
          })
        end,
      })
    end,
  },
}
