return {
  -----------------------------------------------------------------------------
  -- Treesitter (PHP + common web languages)
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local ensure = opts.ensure_installed or {}
      local function add(lang)
        if not vim.tbl_contains(ensure, lang) then
          table.insert(ensure, lang)
        end
      end
      for _, lang in ipairs({
        "php",
        "phpdoc",
        "blade",
      }) do
        add(lang)
      end
      opts.ensure_installed = ensure
      return opts
    end,
  },

  -----------------------------------------------------------------------------
  -- Blade syntax fallback
  -----------------------------------------------------------------------------
  {
    "jwalton512/vim-blade",
    event = { "BufReadPre *.blade.php", "BufNewFile *.blade.php" },
  },

  -----------------------------------------------------------------------------
  -- Mason (Ensure tools are installed)
  -----------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- blade_formatter is a formatter, not an LSP, so it belongs here.
      vim.list_extend(opts.ensure_installed, { "blade-formatter" })
      return opts
    end,
  },

  -----------------------------------------------------------------------------
  -- Mason LSP Config (LSP servers only)
  -----------------------------------------------------------------------------
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "intelephense" })
      return opts
    end,
  },

  -----------------------------------------------------------------------------
  -- LSPCONFIG
  -----------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              files = { maxSize = 5 * 1024 * 1024 },
              format = { enable = false }, -- Pint handles formatting
              diagnostics = { enable = true },
            },
          },
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Phpactor
  -----------------------------------------------------------------------------
  {
    "gbprod/phpactor.nvim",
    ft = "php",
    opts = {},
    config = function(_, opts)
      require("phpactor").setup(opts)
    end,
  },

  -----------------------------------------------------------------------------
  -- Conform: formatting (Pint / Blade)
  -----------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft.php = { "pint" }
      opts.formatters_by_ft.blade = { "blade-formatter" }

      opts.formatters.pint = opts.formatters.pint
        or {
          command = "./vendor/bin/pint",
          stdin = false,
        }
      opts.formatters["blade-formatter"] = {
        command = "blade-formatter",
        args = { "--stdin" },
        stdin = true,
      }
      return opts
    end,
  },
}
