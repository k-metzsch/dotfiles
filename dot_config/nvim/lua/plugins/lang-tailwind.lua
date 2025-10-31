return {
  -----------------------------------------------------------------------------
  -- Mason
  -----------------------------------------------------------------------------
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "tailwindcss" })
      return opts
    end,
  },
  -----------------------------------------------------------------------------
  -- LSP Config
  -----------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          filetypes_include = {
            "html",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "vue",
            "svelte",
            "astro",
            "blade",
            "php",
          },
          init_options = {
            userLanguages = {
              blade = "html",
            },
          },
          settings = {
            tailwindCSS = {
              classAttributes = { "class", "className", "ngClass", "class:list" },
              experimental = {
                classRegex = {
                  "tw`([^`]*)`",
                  'tw="([^"]*)"',
                  "tw={'([^'}*')'}",
                },
              },
            },
          },
        },
      },
    },
  },
  -----------------------------------------------------------------------------
  -- Add tailwind to treesitter parsers
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "tailwindcss" })
      return opts
    end,
  },
}
