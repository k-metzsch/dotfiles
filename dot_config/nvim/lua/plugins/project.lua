return {
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    opts = {
      manual_mode = false,
      detection_methods = { "lsp", "pattern" },
      patterns = {
        ".git",
        "_darcs",
        ".hg",
        ".bzr",
        ".svn",
        "Makefile",
        "package.json",
        "pubspec.yaml",
        "pyproject.toml",
      },
      show_hidden = false,
      silent_chdir = true,
      scope_chdir = "global",
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      pcall(require, "telescope")
      pcall(require("telescope").load_extension, "projects")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "ahmedkhalf/project.nvim" },
  },
}
