-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

local wk = require("which-key")
wk.add({
  { "<leader>F", group = "flutter", icon = { icon = " ", color = "blue" } },
  { "<leader>FR", "<cmd>FlutterRun<cr>", desc = "Run" },
  { "<leader>FD", "<cmd>FlutterDebug<cr>", desc = "Debug" },
  { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Devices" },
  { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Emulators" },
  { "<leader>Fh", "<cmd>FlutterReload<cr>", desc = "Hot Reload" },
  { "<leader>Fr", "<cmd>FlutterRestart<cr>", desc = "Restart" },
  { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Quit" },
  { "<leader>Fa", "<cmd>FlutterAttach<cr>", desc = "Attach" },
  { "<leader>Ft", "<cmd>FlutterDetach<cr>", desc = "Detach" },
  { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Outline Toggle" },
  { "<leader>FO", "<cmd>FlutterOutlineOpen<cr>", desc = "Outline Open" },
  { "<leader>Fv", "<cmd>FlutterDevTools<cr>", desc = "Dev Tools" },
  { "<leader>FA", "<cmd>FlutterDevToolsActivate<cr>", desc = "Activate Dev Tools" },
  { "<leader>FC", "<cmd>FlutterCopyProfilerUrl<cr>", desc = "Copy Profiler URL" },
  { "<leader>FL", "<cmd>FlutterLspRestart<cr>", desc = "LSP Restart" },
  { "<leader>FS", "<cmd>FlutterSuper<cr>", desc = "Go to Super" },
  { "<leader>Fy", "<cmd>FlutterReanalyze<cr>", desc = "Reanalyze" },
  { "<leader>FN", "<cmd>FlutterRename<cr>", desc = "Rename" },
  { "<leader>Fg", "<cmd>FlutterLog<cr>", desc = "Log" },
  { "<leader>FG", "<cmd>FlutterLogClear<cr>", desc = "Log Clear" },
  { "<leader>FT", "<cmd>FlutterLogToggle<cr>", desc = "Log Toggle" },
})
