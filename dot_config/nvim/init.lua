-- bootstrap lazy.nvim, LazyVim and your plugins

vim.o.wrap = false

require("config.lazy")

require("flutter-tools").setup({})
